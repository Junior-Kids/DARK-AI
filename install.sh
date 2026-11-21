#!/bin/bash
set -e

REPO="https://github.com/Junior-Kids/DARK-AI.git"
DIR="$HOME/DARK-AI"
BIN="python3"

echo "[*] Memulai instalasi..."

if [ -d "/data/data/com.termux" ]; then
    pkg update -y
    pkg install -y git python clang make
    BIN=$(command -v python)
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y git python3 python3-pip python3-venv build-essential
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm git python python-pip base-devel
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git python3 python3-pip python3-devel gcc make
fi

if [ -d "$DIR" ]; then
    cd "$DIR"
    git pull
else
    git clone "$REPO" "$DIR"
    cd "$DIR"
fi

if [ ! -d "/data/data/com.termux" ]; then
    $BIN -m venv venv
    source venv/bin/activate
    BIN="$DIR/venv/bin/python3"
fi

$BIN -m pip install --upgrade pip
$BIN -m pip install requests cython rich

mkdir -p "$HOME/.dark_ai/projects" "$HOME/.dark_ai/tools" "$HOME/Promt_Export"

if [ ! -f "$HOME/.dark_ai/config.json" ]; then
    echo '{}' > "$HOME/.dark_ai/config.json"
fi

TARGET="$DIR/run.py"
if [ ! -f "$TARGET" ]; then
    if [ -f "$DIR/wormgpt.py" ]; then
        TARGET="$DIR/wormgpt.py"
    elif [ -f "$DIR/main.py" ]; then
        TARGET="$DIR/main.py"
    fi
fi

ALIAS="alias dark-ai='cd $DIR && $BIN $TARGET'"

if [ -n "$ZSH_VERSION" ]; then
    RC="$HOME/.zshrc"
else
    RC="$HOME/.bashrc"
fi

if ! grep -q "alias dark-ai=" "$RC"; then
    echo "" >> "$RC"
    echo "$ALIAS" >> "$RC"
else
    sed -i "/alias dark-ai=/c\\$ALIAS" "$RC"
fi

source "$RC" 2>/dev/null || true

echo "[+] Instalasi selesai. Jalankan perintah: dark-ai"
