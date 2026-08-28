import 'package:flutter/material.dart';

class CodeBlockFormSection extends StatefulWidget {
  const CodeBlockFormSection({Key? key}) : super(key: key);

  @override
  State<CodeBlockFormSection> createState() => _CodeBlockFormSectionState();
}

class _CodeBlockFormSectionState extends State<CodeBlockFormSection> {
  // 1. Estado para controlar a exibição do bloco de código
  bool _adicionarCodigo = false;
  
  // 2. Linguagem selecionada (padrão nula ou Dart)
  String? _linguagemSelecionada = 'dart';

  final List<String> _linguagensDisponiveis = [
    'dart',
    'javascript',
    'python',
    'flutter',
    'json',
    'html/css'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Switch para ativar/desativar o bloco de código
        SwitchListTile(
          title: const Text('Deseja adicionar um bloco de código?'),
          subtitle: const Text('Ative para incluir trechos de programação no seu post.'),
          value: _adicionarCodigo,
          onChanged: (bool value) {
            setState(() {
              _adicionarCodigo = value;
            });
          },
        ),
        
        // Espaçamento visual
        const SizedBox(height: 12),

        // 3. Renderização Condicional do Seletor e do Editor de Código
        if (_adicionarCodigo) ...[
          // Dropdown para escolher a linguagem
          DropdownButtonFormField<String>(
            value: _linguagemSelecionada,
            decoration: const InputDecoration(
              labelText: 'Linguagem de Programação',
              border: OutlineInputBorder(),
            ),
            items: _linguagensDisponiveis.map((String lang) {
              return DropdownMenuItem<String>(
                value: lang,
                child: Text(lang.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? novaLinguagem) {
              setState(() {
                _linguagemSelecionada = novaLinguagem;
              });
            },
          ),
          
          const SizedBox(height: 16),

          // Campo de Texto para inserir o Código
          TextFormField(
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Cole seu código aqui',
              hintText: 'ex: void main() { print("Olá Mundo!"); }',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (_adicionarCodigo && (value == null || value.isEmpty)) {
                return 'Por favor, insira o código ou desative a opção.';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }
}