import 'dart:async';
import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/Service/termo_service.dart'; // Ajustado para TermoService correto
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Seachview extends StatefulWidget {
  final void Function(TermoCompletoModel suggestion) onSuggestionSelected;
  final void Function(String query) onSearchSubmitted;
  final VoidCallback onSearchCleared;
  final String initialValue;

  const Seachview({
    Key? key,
    required this.onSuggestionSelected,
    required this.onSearchSubmitted,
    required this.onSearchCleared,
    this.initialValue = "",
  }) : super(key: key);

  @override
  State<Seachview> createState() => _SearchViewState();
}

class _SearchViewState extends State<Seachview> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    _controller.addListener(_onTextChanged);
  }

  void _submitSearch() {
    widget.onSearchSubmitted(_controller.text);
    FocusScope.of(context).unfocus();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<List<TermoCompletoModel>> _fetchSuggestions(String query) async {
    _debounceTimer?.cancel();
    final completer = Completer<List<TermoCompletoModel>>();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        completer.complete([]);
        return;
      }
      try {
        // Usando o TermoService correto para buscar termos por string de busca
        final resultados = await TermoService.listarTermos(busca: query);
        completer.complete(resultados);
      } catch (e) {
        print("Exceção ao buscar sugestão: $e");
        completer.complete([]);
      }
    });
    
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadField<TermoCompletoModel>(
              controller: _controller,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Buscar Termo",
                    hintText: "Digite o nome do Termo...",
                    prefixIcon: Icon(Icons.search, color: theme.primaryColorDark),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColorDark, width: 2.0),
                    ),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: theme.primaryColorDark),
                            tooltip: "Limpar busca",
                            onPressed: () {
                              controller.clear();
                              widget.onSearchCleared();
                              focusNode.unfocus();
                            },
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _submitSearch(),
                );
              },
              suggestionsCallback: _fetchSuggestions,
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.titulo),
                  subtitle: Text(suggestion.categoria),
                );
              },
              onSelected: (suggestion) {
                _controller.clear();
                FocusScope.of(context).unfocus();
                widget.onSearchSubmitted("");
                widget.onSuggestionSelected(suggestion);
              },
              emptyBuilder: (context) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Nenhum termo encontrado."),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}