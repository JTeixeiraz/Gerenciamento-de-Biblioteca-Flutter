class Livro {
  int? id;
  final String titulo;
  final String autor;
  final String isbn;
  final int anoPublicacao;
  final String categoria;
  bool disponivel;
  final DateTime dataCadastro;
  final String descricao;

  Livro(
      {this.id,
      required this.titulo,
      required this.autor,
      required this.isbn,
      required this.anoPublicacao,
      required this.categoria,
      this.disponivel = true,
      DateTime? dataCadastro,
      this.descricao = ""})
      : this.dataCadastro = dataCadastro ?? DateTime.now();

  copyWith({
    int? id,
    String? titulo,
    String? autor,
    String? isbn,
    int? anoPublicacao,
    String? categoria,
    bool? disponivel,
    DateTime? dataCadastro,
    String? descricao,
  }) {
    return Livro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      isbn: isbn ?? this.isbn,
      anoPublicacao: anoPublicacao ?? this.anoPublicacao,
      categoria: categoria ?? this.categoria,
      disponivel: disponivel ?? this.disponivel,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      descricao: descricao ?? this.descricao,
    );
  }
}
