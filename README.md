[JW]
Ini versi README.md lu yang udah gw tambahin bagian Cara Pemasangan secara profesional, dan gw sesuaikan struktur direktorinya biar nyambung sama installer yang udah kita bikin.

Tinggal lu copy-paste aja ke file README.md lu:

```markdown
# ☠️ Dark AI — WormGPT Engine

![Version](https://img.shields.io/badge/version-2.8-red)
![Python](https://img.shields.io/badge/python-3.8%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Dark AI** adalah Terminal User Interface (TUI) interaktif berbasis Python yang dirancang sebagai antarmuka untuk berinteraksi dengan Large Language Models (LLM).

Dibangun menggunakan arsitektur modular, proyek ini menghadirkan pengalaman *live code streaming* yang memungkinkan pengguna memantau proses generasi kode AI secara langsung melalui terminal.

Dark AI mengusung persona **John Wick (JW)** — merepresentasikan instrumen presisi, efisiensi, dan eksekusi tanpa basa-basi. Sistem dirancang untuk membantu menghasilkan kode, menjalankan instruksi, serta menyelesaikan berbagai tugas pemrograman.

---

## ⚡ Fitur Utama

| Fitur | Deskripsi |
|---|---|
| **Live Code Streaming** | Menampilkan kode yang dihasilkan AI secara real-time, dilengkapi indikator progres dan kecepatan token. |
| **Modular Architecture** | Struktur kode dipisahkan ke dalam beberapa modul (`api`, `config`, `utils`, `dashboard`, dll.) agar mudah dipelihara dan dikembangkan. |
| **Auto-Formatter & Auto-Fix** | Merapikan format kode dan memperbaiki kesalahan sintaks, khususnya pada Python dan C/C++. |
| **Live Outline Tracker** | Panel Live Info mendeteksi fungsi, class, dan elemen HTML secara langsung. Mendukung Python, JavaScript, C, C++, Rust, Go, HTML, dan bahasa lainnya. |
| **Smart Export (`/run`)** | Mengekspor kode ke `/sdcard/Promt` (Android) atau `~/Promt_Export` (Linux/PC). |
| **Interactive Terminal** | Mendukung riwayat input, navigasi tombol panah, interaksi mouse, dan raw terminal mode tanpa mengganggu tampilan antarmuka. |

---

## 🚀 Cara Pemasangan

### Prasyarat

- **Python 3.8** atau lebih baru
- **Git** dan **Cython** (sudah otomatis terinstal oleh script)
- Terminal dengan dukungan ANSI (Termux, Linux, atau Proot)

### Langkah Instalasi (Otomatis)

Ikuti langkah berikut untuk memasang Dark AI dari nol:

**1. Clone repositori**

```bash
git clone https://github.com/Junior-Kids/DARK-AI.git
cd DARK-AI
```

2. Jalankan Script Installer

Script ini akan otomatis mendeteksi OS (Termux/Linux), menginstal semua dependensi (Python, Cython, Requests, dll.), dan membuat shortcut alias dark-ai di terminal Anda.

```bash
chmod +x install.sh
./install.sh
```

3. Jalankan Aplikasi

Setelah instalasi selesai, Anda dapat menjalankan aplikasi dari direktori mana pun di terminal Anda dengan mengetik:

```bash
dark-ai
```

(Jika Anda menggunakan Linux PC dan belum me-reload .bashrc, jalankan perintah source ~/.bashrc terlebih dahulu, atau buka terminal baru).

---

🎮 Daftar Perintah

Setelah aplikasi berjalan, masukkan perintah melalui prompt └─❯.

Perintah Deskripsi
/new <ide> Memulai sesi baru dan meminta AI menghasilkan kode berdasarkan ide yang diberikan.
/edit <instruksi> Mengedit kode aktif berdasarkan instruksi pengguna.
/fix Meminta AI menganalisis dan memperbaiki bug pada kode aktif.
/run Mengekspor kode ke direktori ekspor.
/save <nama> Menyimpan kode ke direktori proyek internal.
/open <file> Membuka file dari direktori proyek internal.
/show Menampilkan kode aktif di terminal.
/list Menampilkan daftar file dalam direktori proyek internal.
/paste Memasukkan kode secara manual hingga penanda EOF.
/undo Mengembalikan kode ke versi sebelumnya.
/jailbreak <txt> Menambahkan instruksi prompt khusus ke sistem.
/model <nama> Mengganti model AI yang digunakan.
/clear Membersihkan layar dan kembali ke menu utama.
/quit Keluar dari aplikasi.

---

📂 Struktur Direktori

```
DarkAI/
├── LICENSE
├── README.md
├── SECURITY.md
├── install.sh
├── main.so
└── run.py
```

---

🧠 Mekanisme Auto-Fix

Fitur Auto-Fix mendeteksi dan memperbaiki kesalahan pada kode yang dihasilkan AI secara otomatis.

Alur kerja:

1. Output Parsing — Fungsi parse_output pada utils.py mengekstrak kode dari fenced code block Markdown.
2. Code Formatting — Fungsi format_code merapikan indentasi dan format kode (Python: 4 spasi, C/C++: standar).
3. Syntax Validation — Fungsi check_code memeriksa sintaks untuk mendeteksi kemungkinan kesalahan.
4. Automatic Correction — Jika ditemukan kesalahan, sistem mengirim pesan error kembali ke AI agar kode diperbaiki.
5. Retry Mechanism — Proses perbaikan dapat dilakukan hingga 3 kali (dapat dikonfigurasi via auto_fix di config.py).
6. Final Validation — Kode diperiksa ulang sebelum digunakan atau diekspor.

---

⚠️ Disclaimer

Dark AI disediakan untuk tujuan edukasi, pengembangan perangkat lunak, dan penelitian keamanan dalam lingkungan yang sah serta terkontrol.

Pengguna bertanggung jawab penuh atas penggunaan aplikasi dan kode yang dihasilkan oleh sistem AI. Pengembang tidak bertanggung jawab atas penyalahgunaan perangkat lunak ini, termasuk aktivitas ilegal, akses tanpa izin, atau tindakan yang dapat merugikan pihak lain.

Gunakan secara bijak, bertanggung jawab, dan sesuai hukum yang berlaku.

---

<p align="center"><b>DARK AI // PRECISION OVER NOISE.</b></p>
```
