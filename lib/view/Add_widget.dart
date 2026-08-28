import 'package:flutter/material.dart';
import '../shared/color.dart'; // Certifique-se de que o caminho do import está correto para o seu projeto

class AddWidgetForm extends StatefulWidget {
  const AddWidgetForm({Key? key}) : super(key: key);

  @override
  State<AddWidgetForm> createState() => _AddWidgetFormState();
}

class _AddWidgetFormState extends State<AddWidgetForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  bool _adicionarCodigo = false;
  String? _linguagemSelecionada = 'dart';

  final List<String> _linguagensDisponiveis = [
    'dart',
    'javascript',
    'python',
    'flutter',
    'json',
    'html/css',
    'sql'
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _salvarFormulario() {
    if (_formKey.currentState!.validate()) {
      // Pegando os dados preenchidos
      final titulo = _tituloController.text;
      final conteudo = _conteudoController.text;
      final codigo = _adicionarCodigo ? _codigoController.text : null;
      final linguagem = _adicionarCodigo ? _linguagemSelecionada : null;

      debugPrint('Título: $titulo');
      debugPrint('Conteúdo: $conteudo');
      if (_adicionarCodigo) {
        debugPrint('Linguagem: $linguagem');
        debugPrint('Código: $codigo');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulário validado com sucesso!')),
      );
    }
  }

  // Estilo reutilizável para os InputDecoration no padrão Tech
  InputDecoration _techInputDecoration({required String labelText, String? hintText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: techTextGray),
      hintText: hintText,
      hintStyle: const TextStyle(color: techTextGray),
      filled: true,
      fillColor: techBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: techBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: techBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: techPrimary),
      ),
      alignLabelWithHint: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        elevation: 0,
        title: const Text(
          'Adicionar Novo Widget / Post',
          style: TextStyle(color: techTextWhite, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: techTextWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de Título
              TextFormField(
                controller: _tituloController,
                style: const TextStyle(color: techTextWhite),
                decoration: _techInputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _conteudoController,
                style: const TextStyle(color: techTextWhite),
                maxLines: 4,
                decoration: _techInputDecoration(labelText: 'Conteúdo / Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o conteúdo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Card(
                color: techSurface,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: techBorderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: const Text(
                          'Adicionar Bloco de Código',
                          style: TextStyle(color: techTextWhite, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Ative para incluir trechos de programação.',
                          style: TextStyle(color: techTextGray, fontSize: 12),
                        ),
                        value: _adicionarCodigo,
                        activeColor: techPrimary,
                        onChanged: (bool value) {
                          setState(() {
                            _adicionarCodigo = value;
                          });
                        },
                      ),
                      
                      if (_adicionarCodigo) ...[
                        const Divider(height: 24, color: techBorderColor),
                        
                        DropdownButtonFormField<String>(
                          value: _linguagemSelecionada,
                          dropdownColor: techSurface,
                          style: const TextStyle(color: techTextWhite),
                          decoration: _techInputDecoration(labelText: 'Linguagem'),
                          items: _linguagensDisponiveis.map((String lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Text(
                                lang.toUpperCase(),
                                style: const TextStyle(color: techTextWhite),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? novaLinguagem) {
                            setState(() {
                              _linguagemSelecionada = novaLinguagem;
                            });
                          },
                        ),
                        
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _codigoController,
                          maxLines: 6,
                          style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
                          decoration: _techInputDecoration(
                            labelText: 'Código-fonte',
                            hintText: 'Cole seu código aqui...',
                          ),
                          validator: (value) {
                            if (_adicionarCodigo && (value == null || value.isEmpty)) {
                              return 'O campo de código não pode estar vazio se a opção estiver ativa.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: techPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Salvar Publicação',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}