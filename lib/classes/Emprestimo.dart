import 'package:atividade/classes/Livro.dart';

class Emprestimo {
  int? id;
  final int livroId;
  final Livro livro;
  final String nomeUsuario;
  final String emailUsuario;
  final DateTime dataEmprestimo;
  final DateTime dataPrevistaDevolucao;
  DateTime? dataDevolucao;
  bool ativo;
  final String observacoes;
  Emprestimo(
      {this.id,
      required this.livroId,
      required this.livro,
      required this.nomeUsuario,
      required this.emailUsuario,
      DateTime? dataEmprestimo,
      DateTime? dataPrevistaDevolucao,
      this.dataDevolucao,
      this.ativo = true,
      this.observacoes = ""})
      : this.dataEmprestimo = dataEmprestimo ?? DateTime.now(),
        this.dataPrevistaDevolucao =
            dataPrevistaDevolucao ?? DateTime.now().add(Duration(days: 14));

  bool get estaAtrasado {
    if (!ativo) return false;
    if (dataDevolucao != null) return false;
    return DateTime.now().isAfter(dataPrevistaDevolucao);
  }

  int get diasRestantes {
    if (!ativo || dataDevolucao != null) return 0;
    final diferenca = dataPrevistaDevolucao.difference(DateTime.now()).inDays;
    return diferenca;
  }
}
