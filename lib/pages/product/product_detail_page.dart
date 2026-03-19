import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurulislam/pages/product/cart_page.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:nurulislam/models/product_model.dart';
import 'package:nurulislam/providers/cart_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final String imageBaseUrl;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.imageBaseUrl,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyModal(context);
    });

    final images = [
      if (widget.product.image != null && widget.product.image!.isNotEmpty)
        widget.product.image!,
      ...(widget.product.imageJson ?? []),
    ];

    selectedImage = images.isNotEmpty ? images.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final List<String> images = [
      if (widget.product.image != null && widget.product.image!.isNotEmpty)
        widget.product.image!,
      ...(widget.product.imageJson ?? []),
    ];
    // String? selectedImage;
    // final String? mainImage = images.isNotEmpty ? images.first : null;
    // selectedImage = images.isNotEmpty ? images.first : null;
    //print("IMAGE JSON: ${widget.product.imageJson}");
    //print("TOTAL IMAGE: ${widget.product.imageJson?.length}");
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Detail Produk',
        leading: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Consumer<CartProvider>(
                  builder: (_, cart, __) {
                    if (cart.totalItems == 0) return const SizedBox();
                    return CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.totalItems.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text(
            'Tambah ke Keranjang',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            try {
              cart.addToCart(widget.product);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Produk ditambahkan ke keranjang')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Cart Tidak Boleh Beda Shop'),
                backgroundColor: Colors.red,
              ));
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectedImage != null
                ? Image.network(
                    '${widget.imageBaseUrl}$selectedImage',
                    fit: BoxFit.fitWidth,
                    //width: 400,
                    //height: 250,
                  )
                : Container(
                    //height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image)),
                  ),
            if (images.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final img = images[index];
                    final isSelected = img == selectedImage;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = img;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            '${widget.imageBaseUrl}$img',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rupiah.format(widget.product.price),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.product.description ?? '-'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _showMyModal(context),
              child: const Text("Buka Modal"),
            )
          ],
        ),
      ),
    );
  }

  void _showMyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔴 HEADER + CLOSE BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tambah Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // tutup modal
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
