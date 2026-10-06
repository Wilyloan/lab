#!/usr/bin/env bash
# Права root / sudo не нужны.

set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lab"
bindir="$HOME/.local/bin"

mkdir -p "$bindir"
cp "$src" "$bindir/lab"
chmod +x "$bindir/lab"
if [[ -f "$(dirname "$src")/tools/clang-format" ]]; then
    cp "$(dirname "$src")/tools/clang-format" "$bindir/lab-clang-format"
    chmod +x "$bindir/lab-clang-format"
fi

case ":$PATH:" in
    *":$bindir:"*) ;;
    *)
        line='export PATH="$HOME/.local/bin:$PATH"'
        touch "$HOME/.bashrc"
        for rc in "$HOME/.bashrc" "$HOME/.profile"; do
            if [[ -f $rc ]] && ! grep -qxF "$line" "$rc"; then
                printf '\n# lab\n%s\n' "$line" >> "$rc"
            fi
        done
        ;;
esac

echo "Готово! Запустите команду: lab"
echo "Откройте новый терминал."
