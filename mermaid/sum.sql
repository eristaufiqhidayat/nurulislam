select 
`b`.`id`, 
`b`.`nama_barang`, 
COALESCE(bm.total_masuk, 0) as total_masuk, 
COALESCE(dp.total_keluar, 0) as total_keluar, 
(COALESCE(bm.total_masuk, 0) - COALESCE(dp.total_keluar, 0)) as stok_baru 
from `barang` as `b` 
left join (select `barang_id`, SUM(jumlah) as total_masuk from `barang_masuk` group by `barang_id`) as `bm` 
on `b`.`id` = `bm`.`barang_id` 
left join (select `barang_id`, SUM(jumlah) as total_keluar from `detail_penjualan` group by `barang_id`) as `dp` 
on `b`.`id` = `dp`.`barang_id` order by `b`.`nama_barang` asc