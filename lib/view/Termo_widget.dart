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
    return Scaffold(
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: techBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: techBorderColor),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: techTextWhite),
            decoration: const InputDecoration(
              hintText: 'Pesquisar termo ou conceito...',
              hintStyle: TextStyle(color: techTextGray),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: techTextGray),
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
                        backgroundColor: techSurface,
                        selectedColor: techPrimary.withOpacity(0.2),
                        label: Text('${t.nome} (${t.totalTermos})'),
                        selected: isSelected,
                        labelStyle: TextStyle(
                          color: isSelected ? techPrimary : techTextWhite,
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
          const Divider(height: 1, color: techBorderColor),
          Expanded(
            child: _termosFiltradosFuture == null
                ? const Center(
                    child: Text(
                      'Busque por um termo ou selecione um tópico acima.',
                      style: TextStyle(color: techTextGray),
                    ),
                  )
                : FutureBuilder<List<TermoCompletoModel>>(
                    future: _termosFiltradosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: techPrimary));
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