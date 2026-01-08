# Meindo Web Developer Technical Assessment

Repository ini berisi solusi lengkap untuk Technical Assessment posisi Web Developer. Solusi ini mencakup normalisasi database, implementasi API menggunakan Laravel (Query Builder), Helper function, dan skrip otomasi server.

**Kandidat:** Mochamad Ryan Hanafi

---

##  Daftar Isi
1. [Prasyarat Sistem](#prasyarat-sistem)
2. [Instalasi & Konfigurasi](#-instalasi--konfigurasi)
3. [Panduan Pengujian](#-panduan-pengujian)
4. [Struktur Proyek](#-struktur-proyek)
5. [Catatan Penting](#-catatan-penting)

---

## Prasyarat Sistem
Pastikan sistem Anda telah terinstal:
* **Docker** & **Docker Compose** (Metode yang disarankan)
* Git

---

##  Instalasi & Konfigurasi

Proyek ini telah dikontainerisasi sepenuhnya untuk mempermudah proses review.

### 1. Clone & Inisialisasi
Clone repository atau ekstrak file zip, lalu masuk ke direktori proyek:
```bash
cd meindo-assessment

# Membangun dan menjalankan container
docker compose up -d --build