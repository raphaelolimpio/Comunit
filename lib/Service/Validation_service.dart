class ValidationService {
  static String? validarTitulo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O título é obrigatório.';
    }
    if (value.trim().length < 3) {
      return 'O título deve ter pelo menos 3 caracteres.';
    }
    return null;
  }

  static String? validarConteudo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O conteúdo da explicação não pode ficar em branco.';
    }
    if (value.trim().length < 10) {
      return 'Explique com mais detalhes (mínimo de 10 caracteres).';
    }
    return null;
  }

  static String? validarCodigo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Insira o trecho de código ou função.';
    }
    return null;
  }

  static String? validarCategoria(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Selecione ou insira uma categoria.';
    }
    return null;
  }
}