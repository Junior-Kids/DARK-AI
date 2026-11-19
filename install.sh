#!/bin/bash
set -e

if [ -d "/data/data/com.termux" ]; then
    export ENV_TYPE="termux"
    pkg update -y
    pkg install -y python git clang make
elif command -v apt-get >/dev/null 2>&1; then
    export ENV_TYPE="debian"
    sudo apt-get update -y
    sudo apt-get install -y python3 python3-pip python3-dev build-essential git
elif command -v pacman >/dev/null 2>&1; then
    export ENV_TYPE="arch"
    sudo pacman -Sy --noconfirm python python-pip base-devel git
elif command -v dnf >/dev/null 2>&1; then
    export ENV_TYPE="fedora"
    sudo dnf install -y python3 python3-pip python3-devel gcc make git
else
    export ENV_TYPE="unknown"
fi

if [ "$ENV_TYPE" != "termux" ]; then
    python3 -m venv venv
    source venv/bin/activate
    export PYTHON_BIN="python3"
else
    export PYTHON_BIN="python"
fi

$PYTHON_BIN -m pip install --upgrade pip
$PYTHON_BIN -m pip install requests cython rich

mkdir -p "$HOME/.dark_ai/projects" "$HOME/.dark_ai/tools" "$HOME/Promt_Export"

if [ ! -f "$HOME/.dark_ai/config.json" ]; then
    echo '{}' > "$HOME/.dark_ai/config.json"
fi

if [ -f "run.py" ]; then
    TARGET="run.py"
elif [ -f "main.py" ]; then
    TARGET="main.py"
elif [ -f "wormgpt.py" ]; then
    TARGET="wormgpt.py"
else
    TARGET="wormgpt.py"
fi

echo "[OK] Instalasi selesai. Environment: $ENV_TYPE"
if [ "$ENV_TYPE" != "termux" ]; then
    echo "[OK] Jalankan: source venv/bin/activate && python3 $TARGET"
else
    echo "[OK] Jalankan: python $TARGET"
fi
