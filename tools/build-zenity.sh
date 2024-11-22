pacman --noconfirm --sync --needed pactoys
pacman -Sw msys2-runtime --noconfirm
tarPath=$(ls /var/cache/pacman/pkg/msys2-runtime-devel-*.zst -lrt | tail -1 | awk -F' ' '{print $NF}')
#cp "$tarPath" .
tar -C ./ -xf "$tarPath"
mv usr ucrt64
cp -r ucrt64 /
rm -rf /ucrt64/include/regex.h
pacman --noconfirm --sync --needed  mingw-w64-ucrt-x86_64-gettext-runtime \
mingw-w64-ucrt-x86_64-gettext-tools mingw-w64-ucrt-x86_64-gcc help2man mingw-w64-ucrt-x86_64-libadwaita mingw-w64-ucrt-x86_64-meson \
mingw-w64-ucrt-x86_64-gtk4 mingw-w64-ucrt-x86_64-yelp-tools --overwrite '*' 
#cp -r ucrt64 /
cp -r ucrt64/include/langinfo.h /ucrt64/include

# prepare nl_langinfo function

cat > langinfo.h << 'EOF'
#include <stdlib.h>
#define CODESET 1
//typedef int nl_item;

//static char *nl_langinfo(nl_item item)
char *nl_langinfo(nl_item item)
{
    static char empty[8] = "";
    static char ascii[8] = "ASCII";
    static char utf8[8] = "UTF-8";
    if (item == CODESET)
    {
        return (MB_CUR_MAX == 1) ? ascii : utf8;
    }
    return empty;
}

EOF
sed -i 's!typedef __nl_item nl_item;! typedef int nl_item;!' /ucrt64/include/langinfo.h
sed -i '\|#endif /\* !_LANGINFO_H_ \*/|e cat langinfo.h' /ucrt64/include/langinfo.h
    sed -i 's!\(#include <sys/_types.h>\)!//\1!' /ucrt64/include/langinfo.h
tail -20 /ucrt64/include/langinfo.h

# prepare kill function
cat > kill.c << 'EOF'
#ifdef _UCRT
#include <windows.h>
#include <tlhelp32.h>
typedef __int64 pid_t;

int kill(pid_t pid, int sig)
{
    int ret;
    HANDLE h;

    h = OpenProcess(PROCESS_TERMINATE, FALSE, pid);
    if (h == NULL) return -1;

    ret = TerminateProcess(h, 0) ? 0 : -1;
    CloseHandle(h);
    return ret;
}

//ULONG_PTR GetParentProcessId() // By Napalm @ NetCore2K
pid_t getppid() // By Napalm @ NetCore2K
{
 ULONG_PTR pbi[6];
 ULONG ulSize = 0;
 LONG (WINAPI *NtQueryInformationProcess)(HANDLE ProcessHandle, ULONG ProcessInformationClass,
  PVOID ProcessInformation, ULONG ProcessInformationLength, PULONG ReturnLength); 
 *(FARPROC *)&NtQueryInformationProcess = 
  GetProcAddress(LoadLibraryA("NTDLL.DLL"), "NtQueryInformationProcess");
 if(NtQueryInformationProcess){
  if(NtQueryInformationProcess(GetCurrentProcess(), 0,
    &pbi, sizeof(pbi), &ulSize) >= 0 && ulSize == sizeof(pbi))
     return (pid_t)pbi[5];
 }
 return (pid_t)-1;
}


#endif

EOF

# build
git clone https://github.com/GNOME/zenity.git
cd zenity || exit 1

sed -i '\|#include <config.h>|r ../kill.c' src/progress.c
meson -Dwebkitgtk=false build/
ninja -C build/
