import 'package:flutter/material.dart';
import 'package:dicionario/shared/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Apenas duas abas: Posts e Favoritos
      child: Scaffold(
        backgroundColor: techBackground,
        appBar: AppBar(
          backgroundColor: techSurface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.add_box_outlined, color: techTextWhite),
            onPressed: () {
              // Ação do Botão Criar no topo
            },
          ),
          title: const Text(
            'raphael_olimpo',
            style: TextStyle(color: techTextWhite, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: techTextWhite),
              onPressed: () {
                // showTechSettingsModal(context);
              },
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: techPrimary,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                          ),
                          Expanded(
                            child: Row(
                              // CORREÇÃO 1: Adicionado MainAxisAlignment correto
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                _StatColumn(count: '14', label: 'posts'),
                                _StatColumn(count: '1.2k', label: 'seguidores'),
                                _StatColumn(count: '342', label: 'seguindo'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Raphael Olimpo',
                        style: TextStyle(color: techTextWhite, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '💻 Software Developer\n🚀 Flutter & Dart Enthusiast\n⚡ Build. Break. Fix. Repeat.',
                        style: TextStyle(color: techTextGray, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: techBorderColor),
                                backgroundColor: techSurface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {},
                              child: const Text('Editar Perfil', style: TextStyle(color: techTextWhite)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: techBorderColor),
                                backgroundColor: techSurface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {},
                              child: const Text('Compartilhar Perfil', style: TextStyle(color: techTextWhite)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    indicatorColor: techPrimary,
                    labelColor: techPrimary,
                    unselectedLabelColor: techTextGray,
                    tabs: [
                      Tab(icon: Icon(Icons.grid_on)),
                      Tab(icon: Icon(Icons.bookmark_border)),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildPostGrid(),
              _buildPostGrid(isFavoriteGrid: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostGrid({bool isFavoriteGrid = false}) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Container(
          color: techSurface,
          child: Center(
            child: Icon(
              isFavoriteGrid ? Icons.bookmark : Icons.code,
              color: techTextGray,
            ),
          ),
        );
      },
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String count;
  final String label;

  const _StatColumn({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(color: techTextWhite, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: techTextGray, fontSize: 12),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: techBackground,
      child: _tabBar,
    );
  }

  // CORREÇÃO 2: Implementação obrigatória do shouldRebuild
  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}