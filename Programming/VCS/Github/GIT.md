# Materi Dasar Git dan GitHub

## 1. Pengertian Git dan GitHub

**Git** adalah Version Control System (VCS) terdistribusi yang digunakan untuk melacak perubahan file, terutama source code.

**GitHub** adalah layanan hosting repository Git yang menyediakan fitur kolaborasi, pull request, issue tracking, CI/CD, dan manajemen proyek.

Perbedaan sederhananya.

| Git                        | GitHub                          |
| -------------------------- | ------------------------------- |
| Software VCS               | Platform hosting repository Git |
| Berjalan di komputer lokal | Berjalan di server/cloud        |
| Digunakan untuk versioning | Digunakan untuk kolaborasi      |

---

# 2. Instalasi Git

Linux Ubuntu

```bash
sudo apt update
sudo apt install git
```

Arch Linux

```bash
sudo pacman -S git
```

Windows

Unduh dari Git for Windows.

---

# 3. Konfigurasi Awal

Melihat versi Git

```bash
git --version
```

Mengatur nama pengguna

```bash
git config --global user.name "Afrizal"
```

Mengatur email

```bash
git config --global user.email "email@example.com"
```

Melihat konfigurasi

```bash
git config --list
```

Melihat konfigurasi tertentu

```bash
git config user.name
```

---

# 4. Konsep Dasar Git

Git memiliki tiga area utama.

```
Working Directory
        │
        ▼
Staging Area
        │
        ▼
Repository (.git)
```

Working Directory

Tempat file diedit.

Staging Area

Tempat memilih file yang akan disimpan.

Repository

Tempat seluruh riwayat commit disimpan.

---

# 5. Membuat Repository Baru

Masuk ke folder

```bash
cd project
```

Inisialisasi Git

```bash
git init
```

Hasil

```
project/
 ├── .git/
 ├── index.php
 └── README.md
```

---

# 6. Melihat Status

```bash
git status
```

Output

```
Untracked files:
README.md
```

Status file.

* Untracked
* Modified
* Staged
* Committed

---

# 7. Menambahkan File ke Staging

Tambah satu file

```bash
git add README.md
```

Tambah semua file

```bash
git add .
```

Tambah beberapa file

```bash
git add app.py index.html
```

---

# 8. Commit

Commit adalah snapshot project.

```bash
git commit -m "Initial commit"
```

Melihat riwayat

```bash
git log
```

Ringkas

```bash
git log --oneline
```

Grafik

```bash
git log --graph --all --decorate
```

---

# 9. Melihat Perubahan

Perubahan sebelum staging

```bash
git diff
```

Perubahan setelah staging

```bash
git diff --cached
```

---

# 10. Mengubah Nama Branch

Melihat branch

```bash
git branch
```

Mengganti branch utama

```bash
git branch -M main
```

---

# 11. Membuat Branch

```bash
git branch fitur-login
```

Pindah branch

```bash
git checkout fitur-login
```

Atau

```bash
git switch fitur-login
```

Membuat sekaligus pindah

```bash
git checkout -b fitur-login
```

atau

```bash
git switch -c fitur-login
```

---

# 12. Merge Branch

Kembali ke main

```bash
git switch main
```

Gabungkan

```bash
git merge fitur-login
```

---

# 13. Menghapus Branch

```bash
git branch -d fitur-login
```

Paksa

```bash
git branch -D fitur-login
```

---

# 14. Menghubungkan Repository GitHub

Tambah remote

```bash
git remote add origin https://github.com/user/project.git
```

Melihat remote

```bash
git remote -v
```

Mengubah URL

```bash
git remote set-url origin https://github.com/user/project.git
```

Menghapus remote

```bash
git remote remove origin
```

---

# 15. Push

Pertama kali

```bash
git push -u origin main
```

Selanjutnya

```bash
git push
```

Push branch lain

```bash
git push origin fitur-login
```

---

# 16. Clone Repository

```bash
git clone https://github.com/user/project.git
```

Clone ke folder tertentu

```bash
git clone https://github.com/user/project.git projectbaru
```

---

# 17. Pull

Mengambil update

```bash
git pull
```

Secara eksplisit

```bash
git pull origin main
```

---

# 18. Fetch

Mengambil update tanpa merge

```bash
git fetch
```

---

# 19. Restore File

Mengembalikan file

```bash
git restore index.php
```

Restore dari commit tertentu

```bash
git restore --source HEAD~1 index.php
```

---

# 20. Reset

Membatalkan staging

```bash
git reset
```

Reset file tertentu

```bash
git reset README.md
```

Reset commit

Soft

```bash
git reset --soft HEAD~1
```

Mixed

```bash
git reset --mixed HEAD~1
```

Hard

```bash
git reset --hard HEAD~1
```

---

# 21. Stash

Simpan perubahan sementara

```bash
git stash
```

Melihat stash

```bash
git stash list
```

Mengembalikan

```bash
git stash pop
```

---

# 22. Melihat Riwayat File

```bash
git blame app.py
```

Melihat perubahan commit

```bash
git show
```

---

# 23. Tag

Membuat tag

```bash
git tag v1.0
```

Melihat tag

```bash
git tag
```

Push tag

```bash
git push origin v1.0
```

---

# 24. File .gitignore

Contoh

```
node_modules/
.env
*.log
dist/
__pycache__/
```

---

# 25. Workflow Git Sederhana

```
Edit File
    │
    ▼
git status
    │
    ▼
git add .
    │
    ▼
git commit -m "Pesan commit"
    │
    ▼
git push
```

---

# 26. Workflow Kolaborasi

```
Clone
   │
   ▼
Branch Baru
   │
   ▼
Coding
   │
   ▼
git add
   │
   ▼
git commit
   │
   ▼
git push
   │
   ▼
Pull Request
   │
   ▼
Review
   │
   ▼
Merge
```

---

# 27. Command Git yang Paling Sering Digunakan

| Command           | Fungsi                             |
| ----------------- | ---------------------------------- |
| `git init`        | Membuat repository                 |
| `git clone`       | Mengunduh repository               |
| `git status`      | Melihat status                     |
| `git add`         | Menambah ke staging                |
| `git commit -m`   | Menyimpan snapshot                 |
| `git log`         | Melihat riwayat commit             |
| `git diff`        | Melihat perubahan                  |
| `git branch`      | Melihat branch                     |
| `git switch`      | Pindah branch                      |
| `git checkout -b` | Membuat branch baru                |
| `git merge`       | Menggabungkan branch               |
| `git fetch`       | Mengambil update tanpa merge       |
| `git pull`        | Mengambil dan menggabungkan update |
| `git push`        | Mengirim commit ke remote          |
| `git remote -v`   | Melihat remote                     |
| `git stash`       | Menyimpan perubahan sementara      |
| `git restore`     | Mengembalikan file                 |
| `git reset`       | Membatalkan staging atau commit    |
| `git tag`         | Membuat versi rilis                |
| `git blame`       | Melihat penulis setiap baris       |
| `git show`        | Menampilkan detail commit          |

---

# 28. Contoh Praktik Lengkap

```bash
# Masuk ke folder proyek
cd belajar-git

# Inisialisasi repository
git init

# Tambahkan file
echo "# Belajar Git" > README.md

# Cek status
git status

# Masukkan ke staging
git add README.md

# Commit pertama
git commit -m "Initial commit"

# Ganti branch utama
git branch -M main

# Hubungkan ke GitHub
git remote add origin https://github.com/user/belajar-git.git

# Push pertama
git push -u origin main
```

Materi ini mencakup fondasi penggunaan Git dan GitHub yang umum dipakai dalam pengembangan perangkat lunak maupun kolaborasi tim. Setelah menguasai alur dasar `init → add → commit → push → pull`, langkah berikutnya adalah mempelajari workflow kolaborasi seperti Git Flow, GitHub Flow, penanganan merge conflict, rebase, cherry-pick, revert, squash commit, serta penggunaan Pull Request dan Continuous Integration.
