# nurulislam

Pembauatan Android dan Web untuk kegiatan Nurul Islam

## Getting Started

- Install API dengan laravell && JWT


## Struktur Direktory

- nurul islam
    -- /api <-- api laravell
    -- /nurulislam <-- web

flutter run -d chrome --web-browser-flag "--disable-web-security" --web-port=8181
flutter build web --release       
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
Pembuatan cart dengan api


