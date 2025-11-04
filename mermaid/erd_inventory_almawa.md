```mermaid
erDiagram

    PEMBELI {
        int id
        string nama
        string alamat
        string no_telepon
        datetime created_at
    }

    BARANG {
        int id
        string nama_barang
        string kategori
        string satuan
        decimal harga_beli
        decimal harga_jual
        int stok
        datetime created_at
    }

    BARANG_MASUK {
        int id
        int barang_id
        int jumlah
        datetime tgl_masuk
        decimal harga_beli
        string supplier
    }

    PENJUALAN {
        int id
        int pembeli_id
        datetime tgl_transaksi
        decimal total_harga
        decimal total_modal
        decimal total_margin
    }

    DETAIL_PENJUALAN {
        int id
        int penjualan_id
        int barang_id
        int jumlah
        decimal harga_jual
        decimal harga_beli
        decimal margin
    }

    PEMBELI ||--o{ PENJUALAN : melakukan
    PENJUALAN ||--o{ DETAIL_PENJUALAN : memiliki
    BARANG ||--o{ DETAIL_PENJUALAN : terjual
    BARANG ||--o{ BARANG_MASUK : masuk
