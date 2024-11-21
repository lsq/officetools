pacman --noconfirm --sync --needed pactoys
pacman -Sw msys2-runtime --noconfirm
tarPath=$(ls /var/cache/pacman/pkg/msys2-runtime-devel-*.zst -lrt | tail -1 | awk -F' ' '{print $NF}')
#cp "$tarPath" .
tar -C ./ -xf "$tarPath"
mv usr ucrt64
cp -r ucrt64 /
rm -rf /ucrt64/include/regex.h
pacman --noconfirm --sync --needed  mingw-w64-ucrt-x86_64-gettext-runtime \
mingw-w64-ucrt-x86_64-gettext-tools mingw-w64-ucrt-x86_64-gcc help2man mingw-w64-ucrt-x86_64-libadwaita mingw-w64-ucrt-x86_64-meson\
mingw-w64-ucrt-x86_64-gtk4 mingw-w64-ucrt-x86_64-yelp-tools --overwrite '*' 
git clone https://github.com/GNOME/zenity.git
cd zenity || exit 1
meson -Dwebkitgtk=false build/
ninja -C build/
