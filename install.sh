#!/usr/bin/env bash
# Встановлення NyxilumLang (nx + Nx IDE) однією командою - Linux і macOS:
#
#   curl -fsSL https://raw.githubusercontent.com/Faneraiy14/NyxilumNode/main/install.sh | bash
#
# Без sudo: усе в ~/.nyx, команда nx - у ~/.local/bin, на Linux - ярлик
# «Nx IDE» у меню й на робочому столі. Повторний запуск = оновлення
# (або nx update-self).
set -euo pipefail

repo="Faneraiy14/NyxilumNode"
dest="$HOME/.nyx"
bin="$HOME/.local/bin"

case "$(uname -s)-$(uname -m)" in
    Linux-x86_64) rid="linux-x64" ;;
    Darwin-x86_64) rid="osx-x64" ;;
    Darwin-arm64) rid="osx-arm64" ;;
    *) echo "Для $(uname -s) $(uname -m) готової збірки нема (є Linux x64, macOS x64/arm64)." >&2; exit 1 ;;
esac

url="https://github.com/$repo/releases/latest/download/Nx-$rid.tar.gz"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo "Завантажую $url ..."
curl -fL --progress-bar "$url" -o "$tmp/nx.tar.gz"
mkdir -p "$tmp/new"
tar -xzf "$tmp/nx.tar.gz" -C "$tmp/new"

# ide/src, lib - замінюються цілком (даних користувача там нема:
# вони в ~/.nyx-ide і в теках з програмами)
mkdir -p "$dest"
rm -rf "$dest/ide/src" "$dest/ide/examples" "$dest/ide/extensions" "$dest/lib"
cp -R "$tmp/new"/. "$dest/"
chmod +x "$dest/Nx"

mkdir -p "$bin"
ln -sf "$dest/Nx" "$bin/nx"

if [ "$(uname -s)" = "Linux" ]; then
    apps="$HOME/.local/share/applications"
    mkdir -p "$apps"
    cat > "$apps/nx-ide.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Nx IDE
Comment=Середовище NyxilumLang: блоки (як Scratch) і код
Exec="$dest/Nx" ide
Icon=$dest/ide/assets/icon.png
Terminal=false
Categories=Development;
DESKTOP
    desk="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
    if [ -d "$desk" ]; then
        cp "$apps/nx-ide.desktop" "$desk/Nx IDE.desktop"
        chmod +x "$desk/Nx IDE.desktop"
        gio set "$desk/Nx IDE.desktop" metadata::trusted true 2>/dev/null || true
    fi
fi

echo
echo "Готово: $("$dest/Nx" --version)"
case ":$PATH:" in
    *":$bin:"*) echo "Команда nx уже доступна. Nx IDE: nx ide (або ярлик «Nx IDE»)." ;;
    *)
        rc="$HOME/.bashrc"
        [ "${SHELL##*/}" = "zsh" ] && rc="$HOME/.zshrc"
        if ! grep -q '.local/bin' "$rc" 2>/dev/null; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc"
        fi
        echo "Відкрий новий термінал (або source $rc) - і буде команда nx."
        ;;
esac
