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
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: techTextWhite),
        title: const Text('Criar Publicação', style: TextStyle(fontWeight: FontWeight.bold, color: techTextWhite)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                style: const TextStyle(color: techTextWhite),
                decoration: const InputDecoration(
                  labelText: 'Título do Snippet',
                  labelStyle: TextStyle(color: techTextGray),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: techBorderColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: techPrimary)),
                ),
                validator: ValidationService.validarTitulo,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _linguagemController,
                style: const TextStyle(color: techTextWhite),
                decoration: const InputDecoration(
                  labelText: 'Linguagem (ex: dart, python, js)',
                  labelStyle: TextStyle(color: techTextGray),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: techBorderColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: techPrimary)),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _explicacaoController,
                style: const TextStyle(color: techTextWhite),
                decoration: const InputDecoration(
                  labelText: 'Explicação curta',
                  labelStyle: TextStyle(color: techTextGray),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: techBorderColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: techPrimary)),
                ),
                maxLines: 2,
                validator: ValidationService.validarConteudo,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codigoController,
                style: const TextStyle(fontFamily: 'monospace', color: techTextWhite),
                decoration: const InputDecoration(
                  labelText: 'Código-fonte',
                  labelStyle: TextStyle(color: techTextGray),
                  alignLabelWithHint: true,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: techBorderColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: techPrimary)),
                ),
                maxLines: 6,
                validator: ValidationService.validarCodigo,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: techPrimary,
                  shape: RoundedRectangleBorder(borderRadius: AppLayoutConfig.borderRadius),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading ? null : _salvarSnippet,
                child: _isLoading
                    ? const CircularProgressIndicator(color: techBackground)
                    : const Text('Publicar Snippet', style: TextStyle(color: techBackground, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}