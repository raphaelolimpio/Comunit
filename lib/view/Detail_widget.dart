import 'package:dicionario/DS/Components/bash/code_block_widget.dart';
import 'package:flutter/material.dart';
import '../Config/model/Post_model.dart';
import '../Service/termo_service.dart';


class DetailWidget extends StatefulWidget {
  final int termoId;
  const DetailWidget({Key? key, required this.termoId}) : super(key: key);

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<TermoCompletoModel?> _termoFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _carregarDados();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _carregarDados({bool forceRefresh = false}) {
    setState(() {
      _termoFuture = TermoService.obterDetalhes(widget.termoId, forceRefresh: forceRefresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Termo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'Entendimentos'),
            Tab(icon: Icon(Icons.code), text: 'Snippets & Funções'),
          ],
        ),
      ),
      body: FutureBuilder<TermoCompletoModel?>(
        future: _termoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Erro ao carregar detalhes: ${snapshot.error}'));
          }

          final termo = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              // Aba 1: Explicações da Comunidade
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(termo.titulo, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Chip(label: Text(termo.categoria)),
                  const SizedBox(height: 16),
                  const Text('Visões e Entendimentos:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (termo.explicacoes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: Text('Nenhuma explicação cadastrada ainda.')),
                    ),
                  ...termo.explicacoes.map((exp) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(exp.autorNome, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Chip(label: Text(exp.nivel, style: const TextStyle(fontSize: 10))),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(exp.conteudo),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                                onPressed: () async {
                                  bool sucesso = await TermoService.likeExplicacao(exp.id, termo.id);
                                  if (sucesso) {
                                    _carregarDados(forceRefresh: true);
                                  }
                                },
                              ),
                              Text('${exp.upvotes}'),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
                ],
              ),
              // Aba 2: Snippets Práticos
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (termo.snippets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: Text('Nenhum snippet cadastrado ainda.')),
                    ),
                  ...termo.snippets.map((snip) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snip.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Por: ${snip.autorNome}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          CodeBlockWidget(code: snip.codigo, linguagem: snip.linguagem),
                          const SizedBox(height: 8),
                          Text(snip.explicacao, style: const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aqui você pode abrir um BottomSheet para adicionar nova explicação ou snippet chamando CreateService
        },
        icon: const Icon(Icons.add_comment),
        label: const Text('Contribuir'),
      ),
    );
  }
}