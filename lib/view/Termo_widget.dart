import 'package:flutter/material.dart';
import '../Config/model/Post_model.dart';
import '../Service/topico_sevice.dart';
import '../Service/termo_service.dart';
import '../DS/Components/Card/ListCard/List_card_custom.dart';
import '../shared/color.dart';

class TermoWidget extends StatefulWidget {
  const TermoWidget({super.key});

  @override
  State<TermoWidget> createState() => _TermoWidgetState();
}

class _TermoWidgetState extends State<TermoWidget> {
  String? _categoriaSelecionada;
  late Future<List<TopicoModel>> _topicosFuture;
  Future<List<TermoCompletoModel>>? _termosFiltradosFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _topicosFuture = TopicoService.listarTopicos();
  }

  void _buscarTermos(String query) {
    setState(() {
      _categoriaSelecionada = null;
      _termosFiltradosFuture = TermoService.listarTermos(busca: query);
    });
  }

  void _selecionarTopico(String topico) {
    setState(() {
      _categoriaSelecionada = topico;
      _termosFiltradosFuture = TopicoService.obterTermosPorTopico(topico);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.5,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Pesquisar termo ou conceito...',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey),
            ),
            onSubmitted: _buscarTermos,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: FutureBuilder<List<TopicoModel>>(
              future: _topicosFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final topicos = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: topicos.length,
                  itemBuilder: (context, index) {
                    final t = topicos[index];
                    final isSelected = _categoriaSelecionada == t.nome;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('${t.nome} (${t.totalTermos})'),
                        selected: isSelected,
                        selectedColor: primaryColor.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? primaryColor : BlackTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) => _selecionarTopico(t.nome),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _termosFiltradosFuture == null
                ? Center(
                    child: Text(
                      'Busque por um termo ou selecione um tópico acima.',
                      style: TextStyle(color: theme.hintColor),
                    ),
                  )
                : FutureBuilder<List<TermoCompletoModel>>(
                    future: _termosFiltradosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: primaryColor));
                      }
                      final termos = snapshot.data ?? [];
                      return ListCard(items: termos, displayMode: CardDisplayMode.verticalList);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}