pacman --noconfirm --sync --needed pactoys
pacman -Sw msys2-runtime
tarPath=$(ls /var/cache/pacman/pkg/msys2-runtime-devel-*.zst -lrt | tail -1 | awk -F' ' '{print $NF}')
#cp "$tarPath" .
tar -C ./ -xf "$tarPath"
mv usr ucrt64
cp -r ucrt64 /
rm -rf /ucrt64/include/regex.h
pacboy sync --overwrite "*" gettext-runtime:p gettext-tools:p gcc:p help2man: libadwaita:p meson:p gtk4:p yelp-tools:p
git clone https://github.com/GNOME/zenity.git
cd zenity || exit 1
meson -Dwebkitgtk=false build/
ninja -C build/
