import 'emprestimo.dart';

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
    this.telefone = '',
    DateTime? dataCadastro,
    this.ativo = true,
    List<Emprestimo>? emprestimos,
  }) : this.dataCadastro = dataCadastro ?? DateTime.now(),
        this.emprestimos = emprestimos ?? [];

  // Método para verificar se o usuário tem empréstimos ativos
  bool get temEmprestimosAtivos {
    return emprestimos.any((emprestimo) => emprestimo.ativo);
  }

  // Método para verificar se o usuário tem empréstimos atrasados
  bool get temEmprestimosAtrasados {
    return emprestimos.any((emprestimo) => emprestimo.estaAtrasado);
  }

  // Método para obter o número de empréstimos ativos
  int get numeroEmprestimosAtivos {
    return emprestimos.where((emprestimo) => emprestimo.ativo).length;
  }

  // Método para obter o número de empréstimos atrasados
  int get numeroEmprestimosAtrasados {
    return emprestimos.where((emprestimo) => emprestimo.estaAtrasado).length;
  }

  // Método copyWith para criar uma cópia com alterações
  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    DateTime? dataCadastro,
    bool? ativo,
    List<Emprestimo>? emprestimos,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      ativo: ativo ?? this.ativo,
      emprestimos: emprestimos ?? this.emprestimos,
    );
  }

  // Método toString para debug
  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email, ativo: $ativo}';
  }

  // Método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario &&
        other.id == id &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}