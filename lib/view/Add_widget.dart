import 'package:dicionario/DS/Layout/app_layout_config.dart';
import 'package:flutter/material.dart';
import '../Service/Creat_service.dart';
import '../Service/Validation_service.dart';
import '../shared/color.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _linguagemController = TextEditingController(text: 'dart');
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _explicacaoController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _salvarSnippet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final sucesso = await CreateService.criarSnippet(
      titulo: _tituloController.text.trim(),
      linguagem: _linguagemController.text.trim(),
      codigo: _codigoController.text.trim(),
      explicacao: _explicacaoController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Snippet criado com sucesso!')),
        );
        _formKey.currentState!.reset();
        _tituloController.clear();
        _codigoController.clear();
        _explicacaoController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar snippet. Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.5,
        title: const Text('Criar Publicação', style: TextStyle(fontWeight: FontWeight.bold, color: BlackTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título do Snippet'),
                validator: ValidationService.validarTitulo,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _linguagemController,
                decoration: const InputDecoration(labelText: 'Linguagem (ex: dart, python, js)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _explicacaoController,
                decoration: const InputDecoration(labelText: 'Explicação curta'),
                maxLines: 2,
                validator: ValidationService.validarConteudo,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código-fonte',
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                style: const TextStyle(fontFamily: 'monospace'),
                validator: ValidationService.validarCodigo,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: AppLayoutConfig.borderRadius),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading ? null : _salvarSnippet,
                child: _isLoading
                    ? const CircularProgressIndicator(color: WhiteTextColor)
                    : const Text('Publicar Snippet', style: TextStyle(color: WhiteTextColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}