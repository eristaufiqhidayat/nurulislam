```mermaid
flowchart TD

A[Start] --> B[Input Data Barang Masuk]
B --> C[Update Stok Barang]

C --> D[Input Data Pembeli]
D --> E[Input Data Barang Terjual]
E --> F[Hitung Pengurangan Stok]
F --> G[Update Stok Barang]

G --> H[Hitung Margin Penjualan]
H --> I[Generate Laporan Penjualan dan Stok]

I --> J{Stok Habis?}
J -->|Ya| K[Notifikasi / Purchase Order]
J -->|Tidak| L[Continue Operation]

K --> L --> M[End]
