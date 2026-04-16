import 'package:flutter/material.dart';
import 'package:nurulislam/features/order/services/order_service.dart';
import 'package:nurulislam/models/order_model.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class trasaksiPage extends StatefulWidget {
  const trasaksiPage({super.key});

  @override
  State<trasaksiPage> createState() => _trasaksiPageState();
}

class _trasaksiPageState extends State<trasaksiPage>
    with SingleTickerProviderStateMixin {
  final service = OrderService();
  late TabController _tabController;

  final List<String> statuses = [
    'pending',
    'paid',
    'shipped',
    'completed',
    'cancelled'
  ];
  List<Order> order = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: statuses.length, vsync: this);
    fetch();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> getFilteredOrders(String status) {
    return order.where((e) => e.status == status).toList();
  }

  Future<void> fetch() async {
    setState(() => loading = true);

    try {
      order = await service.getOrders();
    } catch (e) {
      // ignore: use_build_context_synchronously
      print(e);
      AuthHelper.handle401(context, message: e.toString());
      setState(() => loading = false);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Transaksi'),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => openForm(),
      //   child: const Icon(Icons.add),
      // ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.green.shade100,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.green.shade900,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.green,
                    tabs: statuses.map((s) {
                      return Tab(text: s.toUpperCase());
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: statuses.map((status) {
                      final filtered = getFilteredOrders(status);

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text("Tidak ada data"),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final s = filtered[i];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// HEADER
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Order #${s.id}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _statusBadge(s.status),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  /// PAYMENT
                                  Text(
                                      "${s.paymentMethod ?? '-'} (${s.paymentStatus})"),

                                  const Divider(),

                                  /// ITEMS
                                  Column(
                                    children: s.items.map((e) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(e.product?.name ?? '-'),
                                          ),
                                          Text("x${e.quantity}"),
                                          Text(
                                              "Rp ${e.subtotal.toStringAsFixed(0)}"),
                                        ],
                                      );
                                    }).toList(),
                                  ),

                                  const Divider(),

                                  /// TOTAL
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total"),
                                      Text(
                                        "Rp ${s.totalAmount.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'paid':
        color = Colors.green;
        break;
      case 'shipped':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.teal;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
