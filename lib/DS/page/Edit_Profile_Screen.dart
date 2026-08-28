import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String? initialRole;
  final String? initialAvatarUrl;

  const EditProfileScreen({
    Key? key,
    required this.initialName,
    this.initialRole,
    this.initialAvatarUrl,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _avatarUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os dados atuais do usuário
    _nameController = TextEditingController(text: widget.initialName);
    _roleController = TextEditingController(text: widget.initialRole ?? '');
    _avatarUrlController = TextEditingController(text: widget.initialAvatarUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  // Estilo reutilizável para os inputs no padrão Tech
  InputDecoration _techInputDecoration({required String labelText, String? hintText, IconData? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: techTextGray),
      hintText: hintText,
      hintStyle: const TextStyle(color: techTextGray),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: techTextGray) : null,
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
    );
  }

  Future<void> _salvarPerfil() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulando salvamento (substitua pela chamada ao seu AuthService ou Service de usuário)
      await Future.delayed(const Duration(seconds: 1));

      final novoNome = _nameController.text;
      final novoCargo = _roleController.text;
      final novaFoto = _avatarUrlController.text;

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pop(context, {
          'name': novoNome,
          'role': novoCargo,
          'avatarUrl': novaFoto,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
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
        title: const Text(
          'Editar Perfil',
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
              // ==========================================
              // PRÉ-VISUALIZAÇÃO DO AVATAR
              // ==========================================
              Center(
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _avatarUrlController,
                      builder: (context, TextEditingValue value, __) {
                        final url = value.text;
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: techSurface,
                          backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
                          child: url.isEmpty
                              ? Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: techTextWhite,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: techPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(color: techBackground, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ==========================================
              // CAMPOS DO FORMULÁRIO
              // ==========================================
              
              // Nome
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: techTextWhite),
                decoration: _techInputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome não pode estar vazio.';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}), // Atualiza a letra do avatar se faltar URL
              ),
              const SizedBox(height: 16),

              // Cargo / Função (Role)
              TextFormField(
                controller: _roleController,
                style: const TextStyle(color: techTextWhite),
                decoration: _techInputDecoration(
                  labelText: 'Cargo / Função (ex: Arquiteto Flutter)',
                  prefixIcon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 16),

              // URL da Foto de Perfil
              TextFormField(
                controller: _avatarUrlController,
                style: const TextStyle(color: techTextWhite),
                decoration: _techInputDecoration(
                  labelText: 'URL da Foto de Perfil',
                  hintText: 'https://exemplo.com/foto.jpg',
                  prefixIcon: Icons.link_outlined,
                ),
              ),
              const SizedBox(height: 32),

              // Botão de Salvar
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: techPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Salvar Alterações',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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