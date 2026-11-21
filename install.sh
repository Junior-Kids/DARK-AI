#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# install.sh — DARK-AI Termux Bootstrap
# Jalan di Termux native. Ngurus: dependency, clone, proot,
# python env di Ubuntu, wrapper sekali eksekusi.
# ============================================================
set -euo pipefail

# ---------- Pengaturan dasar ----------
REPO_URL="https://github.com/Junior-Kids/DARK-AI.git"
PROJECT_DIR="$HOME/DARK-AI"
DISTRO="ubuntu"
WRAPPER="$HOME/darkai.sh"
LOG_PREFIX="[darkai-install]"

# ---------- Fungsi bantuan ----------
log()  { printf '%s %s\n' "$LOG_PREFIX" "$*"; }
die()  { printf '%s ERROR: %s\n' "$LOG_PREFIX" "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------- 1. Pastiin jalan di Termux ----------
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    die "Script ini cuma buat Termux native. Lo kelihatannya jalan di environment lain."
fi

# ---------- 2. Pasang alat dasar ----------
log "Update package index & pasang dependency dasar..."
pkg update -y >/dev/null 2>&1 || true
for p in git proot-distro python; do
    if ! have "$p"; then
        log "Pasang $p..."
        pkg install -y "$p" || die "Gagal pasang $p"
    else
        log "$p sudah ada, skip."
    fi
done

# ---------- 3. Ambil kode DARK-AI ----------
if [ -d "$PROJECT_DIR/.git" ]; then
    log "Repo sudah ada di $PROJECT_DIR, pull ulang..."
    git -C "$PROJECT_DIR" pull --ff-only || log "Pull gagal, pakai versi lokal yang ada."
else
    log "Clone $REPO_URL -> $PROJECT_DIR"
    rm -rf "$PROJECT_DIR"
    git clone "$REPO_URL" "$PROJECT_DIR" || die "Clone gagal. Cek URL / koneksi."
fi

[ -f "$PROJECT_DIR/run.py" ] || die "run.py gak ketemu di $PROJECT_DIR. Repo-nya beda struktur?"

# ---------- 4. Siapin Ubuntu di dalam Termux ----------
if ! proot-distro list 2>/dev/null | grep -q "^$DISTRO"; then
    log "Install rootfs $DISTRO (bisa makan waktu & ~300-500MB)..."
    proot-distro install "$DISTRO" || die "Gagal install $DISTRO"
else
    log "Rootfs $DISTRO sudah ada."
fi

# ---------- 5. Pasang Py + requests di Ubuntu ----------
log "Setup python3 + pip + requests di dalam $DISTRO..."
proot-distro login "$DISTRO" -- bash -c "
    set -e
    export DEBIAN_FRONTEND=noninteractive
    apt update -y
    apt install -y python3 python3-pip
    pip3 install --upgrade pip requests
" || die "Setup python di $DISTRO gagal."

# ---------- 6. make shortcut ~/darkai.sh ----------
log "Bikin wrapper $WRAPPER..."
{
    printf '%s\n' '#!/data/data/com.termux/files/usr/bin/bash'
    printf '%s\n' '# Wrapper DARK-AI: login proot, masuk folder, jalanin run.py.'
    printf '%s\n' 'set -e'
    printf 'PROJECT_DIR="%s"\n' "$PROJECT_DIR"
    printf 'exec proot-distro login %s -- bash -c "cd '\''$PROJECT_DIR'\'' && python3 run.py \$*"\n' "$DISTRO"
} > "$WRAPPER"
chmod +x "$WRAPPER"

# ---------- 7. Tes cepat main.so ----------
log "Smoke test: import main.so di dalam $DISTRO..."
if proot-distro login "$DISTRO" -- bash -c "
    cd '$PROJECT_DIR' && python3 -c 'import main; print(\"[ok] main.so loaded\")'
" 2>/dev/null; then
    SMOKE_STATUS="✅ OK — main.so berhasil dimuat di Ubuntu"
else
    SMOKE_STATUS="⚠️  GAGAL — main.so belum bisa dimuat (baca bagian 'KALAU ADA MASALAH' di bawah)"
fi

# ---------- 8. summary user friendly ----------
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              🎉  INSTALASI SELESAI  🎉                  ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Status smoke test : $SMOKE_STATUS"
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  📥  CARA PAKAI SCRIPT INI (install.sh)"
echo "──────────────────────────────────────────────────────────"
echo ""
echo "  Kalau lo baru pertama kali jalanin, urutannya begini:"
echo ""
echo "  1) Kasih izin eksekusi ke script ini (sekali aja):"
echo "        chmod +x ~/install.sh"
echo ""
echo "  2) Jalanin installernya:"
echo "        ~/install.sh"
echo ""
echo "  Atau kalau lo ada di folder yang sama dengan install.sh:"
echo ""
echo "        chmod +x install.sh"
echo "        ./install.sh"
echo ""
echo "  Atau lewat bash langsung (tanpa chmod):"
echo ""
echo "        bash install.sh"
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  🚀  CARA JALANIN DARK-AI (setelah install selesai)"
echo "──────────────────────────────────────────────────────────"
echo ""
echo "  Ketik perintah ini di Termux (copy-paste aja):"
echo ""
echo "        ~/darkai.sh"
echo ""
echo "  Itu satu-satunya perintah yang lo butuhin tiap hari."
echo "  Gak perlu buka Ubuntu, gak perlu cd ke mana-mana."
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  📖  KALAU MAU KIRIM ARGUMEN TAMBAHAN"
echo "──────────────────────────────────────────────────────────"
echo ""
echo "  Contoh: mau lihat bantuan run.py"
echo ""
echo "        ~/darkai.sh --help"
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  🔧  KALAU MAU DEBUG / MASUK UBUNTU MANUAL"
echo "──────────────────────────────────────────────────────────"
echo ""
echo "  1) Masuk ke Ubuntu:"
echo "        proot-distro login $DISTRO"
echo ""
echo "  2) Di dalam Ubuntu, masuk ke folder project:"
echo "        cd $PROJECT_DIR"
echo ""
echo "  3) Jalanin langsung:"
echo "        python3 run.py"
echo ""
echo "  4) Keluar dari Ubuntu:"
echo "        exit"
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  ⚠️   KALAU ADA MASALAH"
echo "──────────────────────────────────────────────────────────"
echo ""
echo "  • Kalau muncul error 'libc.so.6 not found' di Termux native:"
echo "      Itu normal. JANGAN jalanin 'python3 run.py' langsung dari"
echo "      Termux. Selalu lewat '~/darkai.sh' — itu yang bikin dia"
echo "      jalan di dalam Ubuntu."
echo ""
echo "  • Kalau smoke test di atas GAGAL:"
echo "      Coba cek manual dengan perintah ini:"
echo "        proot-distro login $DISTRO -- bash -c \"cd $PROJECT_DIR && python3 -c 'import main'\""
echo "      Tempel error yang muncul biar bisa dibaca."
echo ""
echo "  • Kalau 'requests' gak kebaca:"
echo "        proot-distro login $DISTRO -- bash -c 'pip3 show requests'"
echo "      Harusnya muncul info package. Kalau kosong, install ulang:"
echo "        proot-distro login $DISTRO -- bash -c 'pip3 install requests'"
echo ""
echo "──────────────────────────────────────────────────────────"
echo "  📌  RINGKASAN FILE"
echo "──────────────────────────────────────────────────────────"
echo ""
echo "  install.sh     → script yang baru lo jalanin (bootstrap)"
echo "  darkai.sh      → tinggal ketik '~/darkai.sh' buat jalanin"
echo "  DARK-AI/       → folder repo, isinya kode programnya"
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Selesai. Tinggal ketik:  ~/darkai.sh                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
