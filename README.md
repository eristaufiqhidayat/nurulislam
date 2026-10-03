# nurulislam

Pembauatan Android dan Web untuk kegiatan Nurul Islam September 2026

## Getting Started

- Install API dengan laravell && JWT


## Struktur Direktory

- nurul islam
    -- /api <-- api laravell
    -- /nurulislam <-- web

flutter run -d chrome --web-browser-flag "--disable-web-security" --web-port=8181
flutter build web --release
flutter build appbundle --release
## Task Yang harus di buat
- Mebuat CRUD pagecontent

## tranfer sftp
rsync -avz /Users/user/Project/flutter/nurulislam/nurulislam/build/web/ root@10.147.17.187:/docker/nurulislam/public/web/

## import database cli
docker exec -i mysql_container mysql -u root -p nama_database < backup.sql

#### DEVELOPEMENT PROSES ######

18 Maret 2026
Pembuatan upload multepleImage
- Peubahan di API (Product)

Next
Pembiatan New Product Untuk Anggota Koperasi - done
Pembuatan SHOP - done
Pembuatan cart dengan api - done

Pembuatan Transaksi , mengambil data dari Order




## CRUD Kegiatan dan Kajian

Login lalu buka **Akun/Dashboard → Kelola Kegiatan / Kelola Kajian**.
Route Flutter: `/kegiatanCrud` dan `/kajianCrud`.

- Daftar, pencarian judul/deskripsi, tambah, edit, dan konfirmasi hapus.
- Form judul wajib (maksimal 255 karakter), deskripsi dan gambar opsional.
- Upload/ganti gambar JPG, PNG, GIF, WEBP maksimal 2 MB; hapus gambar dari konten.
- Tombol simpan dikunci selama upload/simpan; error API ditampilkan pada form.
- API: GET/POST `/api/kegiatan`, PUT/DELETE `/api/kegiatan/{id}`; pola sama untuk kajian.
- Upload: POST `/api/upload-image` dengan Bearer token. Konten menyimpan `filename` agar cocok dengan kartu publik.
- Endpoint Laravel harus sudah diperbarui dari repo `nurulislam-api`. Hak akses ditentukan oleh backend; menu tersedia untuk akun yang telah login.

Verifikasi pada mesin dengan Flutter SDK:

```bash
flutter pub get
flutter analyze lib/features/content_management
flutter build web --release
```

Uji dengan akun yang berizin: tambah konten bergambar, cari judul, edit judul/gambar,
batalkan hapus, lalu konfirmasi hapus. Periksa daftar publik setelah dimuat ulang.
