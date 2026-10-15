#!/usr/bin/env bash
# Пакет .pkg для macOS (запускається на macOS-раннері, потрібен pkgbuild).
#   bash installer/build-pkg.sh <publish-out> <версія> <вихідний.pkg>
# Кладе все в /usr/local/nyx, команду nx - у /usr/local/bin.
set -euo pipefail
umask 022
src="$1"; ver="$2"; out="$3"
work="$(mktemp -d)"
root="$work/root"
mkdir -p "$root/usr/local/nyx" "$root/usr/local/bin"
cp -R "$src"/. "$root/usr/local/nyx/"
chmod 755 "$root/usr/local/nyx/Nx"
ln -s /usr/local/nyx/Nx "$root/usr/local/bin/nx"
pkgbuild --root "$root" --identifier io.github.faneraiy14.nyx --version "$ver" --install-location / "$out"
rm -rf "$work"
echo "Готово: $out"
