import 'package:atividade/classes/Emprestimo.dart';

class Usuario {
  int? id;
  final String nome;
  final String email;
  final String telefone;
  final DateTime dataCadastro;
  bool ativo;
  List<Emprestimo> emprestimos;
  Usuario({
    this.id,
    required this.nome,
    required this.email,
    this.telefone = "",
    DateTime? dataCadastro,
    this.ativo = true,
    List<Emprestimo>? emprestimos,
  })  : this.dataCadastro = dataCadastro ?? DateTime.now(),
        this.emprestimos = emprestimos ?? [];

  bool get temEmprestimosAtivos {
    return emprestimos.any((emprestimo) => emprestimo.ativo);
  }

  bool get temEmprestimosAtrasados {
    return emprestimos.any((emprestimo) => emprestimo.estaAtrasado);
  }
  
}
