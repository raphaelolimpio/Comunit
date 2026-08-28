import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allResults = [
    {
      'type': 'term',
      'title': 'Closure (Função Anônima)',
      'content': 'Uma closure é uma função que se lembra do seu escopo léxico mesmo quando a função é executada fora desse escopo...',
    },
    {
      'type': 'code',
      'title': 'Exemplo de Future no Dart',
      'language': 'dart',
      'code': 'Future<void> carregarDados() async {\n  print("Iniciando...");\n  await Future.delayed(const Duration(seconds: 2));\n  print("Concluído!");\n}',
    },
    {
      'type': 'term',
      'title': 'Widget Stateless',
      'content': 'Um widget que não mantém estado interno mutável. Toda a sua configuração é fornecida por um construtor...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar e Pesquisar'),
        // Abas visuais solicitadas (Item 2)
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Termos'),
            Tab(text: 'Códigos'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar termos ou blocos de código...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {}); 
              },
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResultList('all'),
                _buildResultList('term'),
                _buildResultList('code'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList(String category) {
    final filtered = _allResults.where((item) {
      final matchesCategory = category == 'all' || item['type'] == category;
      final query = _searchController.text.toLowerCase();
      final matchesQuery = item['title'].toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text('Nenhum resultado encontrado.', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];

        if (item['type'] == 'term') {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  // Área de visualização expandida da definição
                  Text(
                    item['content'],
                    style: const TextStyle(fontSize: 14, height: 1.4),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        } 
        
        else {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Chip(
                        label: Text(
                          item['language'].toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Área de prévia expandida do código
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['code'],
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}