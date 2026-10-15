#!/usr/bin/env bash
# Пакет .deb для Ubuntu/Debian: подвійний клік -> «Встановити».
#   bash installer/build-deb.sh <publish-out> <версія> <вихідний.deb>
# Кладе все в /opt/nyx, команду nx - у /usr/bin, ярлик «Nx IDE» - у меню.
set -euo pipefail
umask 022
src="$1"; ver="$2"; out="$3"
work="$(mktemp -d)"
root="$work/pkg"
mkdir -p "$root/DEBIAN" "$root/opt/nyx" "$root/usr/bin" "$root/usr/share/applications" "$root/usr/share/icons/hicolor/256x256/apps"
cp -r "$src"/. "$root/opt/nyx/"
chmod 755 "$root/opt/nyx/Nx"
ln -s /opt/nyx/Nx "$root/usr/bin/nx"
cp "$src/ide/assets/icon.png" "$root/usr/share/icons/hicolor/256x256/apps/nyxilum-node.png"
# інші назви, ніж у пакеті nx-ide (окрема програма Nx IDE) - щоб обидва ставились разом
cat > "$root/usr/share/applications/nyxilum-node-ide.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Nx IDE (NyxilumNode)
Comment=Середовище NyxilumLang: блоки (як Scratch) і код
Exec=/opt/nyx/Nx ide
Icon=nyxilum-node
Terminal=false
Categories=Development;
DESKTOP
size=$(du -sk "$root/opt" | cut -f1)
cat > "$root/DEBIAN/control" <<CONTROL
Package: nyx
Version: $ver
Section: devel
Priority: optional
Architecture: amd64
Depends: libc6, libx11-6
Installed-Size: $size
Maintainer: Faneraiy14 <faneraiy14@users.noreply.github.com>
Homepage: https://github.com/Faneraiy14/NyxilumNode
Description: NyxilumLang - мова програмування і Nx IDE
 Команда nx (запуск .nx, REPL, бібліотеки) і Nx IDE - середовище з блоками
 (як Scratch) і кодом, уроками, git, терміналом і розширеннями.
CONTROL
chmod -R go-w "$root"
dpkg-deb --build --root-owner-group "$root" "$out" >/dev/null
rm -rf "$work"
echo "Готово: $out"
