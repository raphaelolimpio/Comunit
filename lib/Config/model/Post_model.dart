class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  final String? fotoUrl;
  final String? bio;
  final int totalTermos;
  final int totalExplicacoes;
  final int totalSnippets;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
    this.bio,
    this.totalTermos = 0,
    this.totalExplicacoes = 0,
    this.totalSnippets = 0,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? 'Dev Anônimo',
      email: json['email'] ?? '',
      fotoUrl: json['foto_url'],
      bio: json['bio'],
      totalTermos: json['total_termos'] ?? 0,
      totalExplicacoes: json['total_explicacoes'] ?? 0,
      totalSnippets: json['total_snippets'] ?? 0,
    );
  }
}

class ExplicacaoModel {
  final int id;
  final int autorId;
  final String autorNome;
  final String? autorFoto;
  final String conteudo;
  final String nivel;
  int upvotes;
  final DateTime criadoEm;

  ExplicacaoModel({
    required this.id,
    required this.autorId,
    required this.autorNome,
    this.autorFoto,
    required this.conteudo,
    required this.nivel,
    required this.upvotes,
    required this.criadoEm,
  });

  factory ExplicacaoModel.fromJson(Map<String, dynamic> json) {
    return ExplicacaoModel(
      id: json['id'] ?? 0,
      autorId: json['autor_id'] ?? 0,
      autorNome: json['autor_nome'] ?? 'Dev',
      autorFoto: json['autor_foto'],
      conteudo: json['conteudo'] ?? '',
      nivel: json['nivel'] ?? 'Geral',
      upvotes: json['upvotes'] ?? 0,
      criadoEm: DateTime.tryParse(json['criado_em'] ?? '') ?? DateTime.now(),
    );
  }
}

class SnippetModel {
  final int id;
  final int autorId;
  final String autorNome;
  final String titulo;
  final String linguagem;
  final String codigo;
  final String explicacao;
  int upvotes;

  SnippetModel({
    required this.id,
    required this.autorId,
    required this.autorNome,
    required this.titulo,
    required this.linguagem,
    required this.codigo,
    required this.explicacao,
    required this.upvotes,
  });

  factory SnippetModel.fromJson(Map<String, dynamic> json) {
    return SnippetModel(
      id: json['id'] ?? 0,
      autorId: json['autor_id'] ?? 0,
      autorNome: json['autor_nome'] ?? 'Dev',
      titulo: json['titulo'] ?? '',
      linguagem: json['linguagem'] ?? 'dart',
      codigo: json['codigo'] ?? '',
      explicacao: json['explicacao'] ?? '',
      upvotes: json['upvotes'] ?? 0,
    );
  }
}

class TermoCompletoModel {
  final int id;
  final String titulo;
  final String categoria;
  final List<ExplicacaoModel> explicacoes;
  final List<SnippetModel> snippets;

  TermoCompletoModel({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.explicacoes,
    required this.snippets,
  });

  factory TermoCompletoModel.fromJson(Map<String, dynamic> json) {
    return TermoCompletoModel(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      categoria: json['categoria'] ?? 'Geral',
      explicacoes: (json['explicacoes'] as List? ?? [])
          .map((e) => ExplicacaoModel.fromJson(e))
          .toList(),
      snippets: (json['snippets'] as List? ?? [])
          .map((s) => SnippetModel.fromJson(s))
          .toList(),
    );
  }
}

class ComentarioModel {
  final int id;
  final int autorId;
  final String autorNome;
  final String? autorFoto;
  final String conteudo;
  final int? parentId;
  final DateTime criadoEm;
  final List<ComentarioModel> respostas;

  ComentarioModel({
    required this.id,
    required this.autorId,
    required this.autorNome,
    this.autorFoto,
    required this.conteudo,
    this.parentId,
    required this.criadoEm,
    required this.respostas,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      id: json['id'] ?? 0,
      autorId: json['autor_id'] ?? 0,
      autorNome: json['autor_nome'] ?? 'Dev',
      autorFoto: json['autor_foto'],
      conteudo: json['conteudo'] ?? '',
      parentId: json['parent_id'],
      criadoEm: DateTime.tryParse(json['criado_em'] ?? '') ?? DateTime.now(),
      respostas: (json['respostas'] as List? ?? [])
          .map((r) => ComentarioModel.fromJson(r))
          .toList(),
    );
  }
}