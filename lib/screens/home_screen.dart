import 'package:flutter/material.dart';
import 'package:nurulislam/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../features/menus/models/menu_model.dart';
import '../features/register/services/auth_service.dart';
// import 'admin_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late Future<List<MenuItem>> _menuFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final auth = context.watch<AuthProvider>();

    if (auth.user == null) return;

    _menuFuture = AuthService().getUserMenu(auth.user!.role);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.user == null) {
      return Scaffold(
        backgroundColor: Colors.green.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.green.shade700),
              const SizedBox(height: 16),
              const Text(
                'User belum login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Silakan login untuk mengakses dashboard',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      // appBar: AppBarCustom(
      //   title: 'Dashboard',
      //   showBack: false,
      // ),
      backgroundColor: Colors.green.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 125,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // 🔹 Baris atas: Avatar + Logout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Assalamu’alaikum",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  auth.user!.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 🔹 Logout button (cantik)
                        InkWell(
                          onTap: () async {
                            await auth.logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // 🔹 Subtitle bawah
                    const Text(
                      "Selamat datang di Dashboard",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(spacing: 12, runSpacing: 12, children: [
                FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/kegiatanCrud'),
                  icon: const Icon(Icons.event), label: const Text('Kelola Kegiatan'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/kajianCrud'),
                  icon: const Icon(Icons.menu_book), label: const Text('Kelola Kajian'),
                ),
              ]),
            ),
          ),
          FutureBuilder<List<MenuItem>>(
            future: _menuFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return SliverLayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.crossAxisExtent;

                  // 🔧 atur ukuran item (fix)
                  const double itemWidth = 110;

                  int crossAxisCount = (maxWidth / itemWidth).floor();
                  if (crossAxisCount < 2) crossAxisCount = 2;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final item = snapshot.data![i];
                      return InkWell(
                        onTap: () => Navigator.pushNamed(context, item.route),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _menuIcon(item.icon),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }, childCount: snapshot.data!.length),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuIcon(String iconName) {
    return Image.asset(
      'assets/images/$iconName',
      width: 40,
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // fallback kalau image tidak ditemukan
        return const Icon(
          Icons.apps,
          size: 40,
          color: Colors.green,
        );
      },
    );
  }
}
