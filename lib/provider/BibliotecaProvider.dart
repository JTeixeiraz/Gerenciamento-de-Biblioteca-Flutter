import 'package:atividade/classes/Emprestimo.dart';
import 'package:atividade/classes/Livro.dart';
import 'package:atividade/classes/Usuario.dart';
import 'package:flutter/foundation.dart';

class BibliotecaProvider with ChangeNotifier {
  List<Livro> _livros = [];
  List<Usuario> _usuarios = [];
  List<Emprestimo> _emprestimos = [];

  // Getters
  List<Livro> get livros => List.unmodifiable(_livros);
  List<Usuario> get usuarios => List.unmodifiable(_usuarios);
  List<Emprestimo> get emprestimos => List.unmodifiable(_emprestimos);

  // Métodos para gerenciar Livros
  void adicionarLivro(Livro livro) {
    // Gerar ID único se não existir
    if (livro.id == null) {
      final novoId = _livros.isEmpty ? 1 : _livros.map((l) => l.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      livro = livro.copyWith(id: novoId);
    }
    _livros.add(livro);
    notifyListeners();
  }

  void editarLivro(Livro livroEditado) {
    final index = _livros.indexWhere((livro) => livro.id == livroEditado.id);
    if (index != -1) {
      _livros[index] = livroEditado;
      notifyListeners();
    }
  }

  void removerLivro(int? id) {
    // Verificar se o livro tem empréstimos ativos antes de remover
    final temEmprestimosAtivos = _emprestimos.any((e) => e.livroId == id && e.ativo);
    if (temEmprestimosAtivos) {
      throw Exception('Não é possível remover livro com empréstimos ativos');
    }

    _livros.removeWhere((livro) => livro.id == id);
    notifyListeners();
  }

  Livro? buscarLivroPorId(int id) {
    try {
      return _livros.firstWhere((livro) => livro.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Livro> buscarLivros(String termo) {
    if (termo.isEmpty) return _livros;

    final termoLower = termo.toLowerCase();
    return _livros.where((livro) =>
    livro.titulo.toLowerCase().contains(termoLower) ||
        livro.autor.toLowerCase().contains(termoLower) ||
        livro.categoria.toLowerCase().contains(termoLower)
    ).toList();
  }

  // Métodos para gerenciar Usuários
  void adicionarUsuario(Usuario usuario) {
    // Verificar se já existe usuário com o mesmo email
    final emailExiste = _usuarios.any((u) => u.email.toLowerCase() == usuario.email.toLowerCase());
    if (emailExiste) {
      throw Exception('Já existe um usuário cadastrado com este email');
    }

    // Gerar ID único se não existir
    if (usuario.id == null) {
      final novoId = _usuarios.isEmpty ? 1 : _usuarios.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      usuario = Usuario(
        id: novoId,
        nome: usuario.nome,
        email: usuario.email,
        telefone: usuario.telefone,
        ativo: usuario.ativo,
        dataCadastro: usuario.dataCadastro,
        emprestimos: usuario.emprestimos,
      );
    }

    _usuarios.add(usuario);
    notifyListeners();
  }

  void editarUsuario(Usuario usuarioEditado) {
    final index = _usuarios.indexWhere((usuario) => usuario.id == usuarioEditado.id);
    if (index != -1) {
      // Verificar se o email já está sendo usado por outro usuário
      final emailExiste = _usuarios.any((u) =>
      u.id != usuarioEditado.id &&
          u.email.toLowerCase() == usuarioEditado.email.toLowerCase()
      );
      if (emailExiste) {
        throw Exception('Já existe outro usuário cadastrado com este email');
      }

      _usuarios[index] = usuarioEditado;
      notifyListeners();
    }
  }

  void toggleUsuarioAtivo(Usuario usuario) {
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      final usuarioAtualizado = Usuario(
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
        telefone: usuario.telefone,
        ativo: !usuario.ativo,
        dataCadastro: usuario.dataCadastro,
        emprestimos: usuario.emprestimos,
      );
      _usuarios[index] = usuarioAtualizado;
      notifyListeners();
    }
  }

  Usuario? buscarUsuarioPorEmail(String email) {
    try {
      return _usuarios.firstWhere((usuario) => usuario.email.toLowerCase() == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  List<Usuario> buscarUsuarios(String termo) {
    if (termo.isEmpty) return _usuarios;

    final termoLower = termo.toLowerCase();
    return _usuarios.where((usuario) =>
    usuario.nome.toLowerCase().contains(termoLower) ||
        usuario.email.toLowerCase().contains(termoLower)
    ).toList();
  }

  // Métodos para gerenciar Empréstimos
  void adicionarEmprestimo(Emprestimo emprestimo) {
    // Verificar se o livro está disponível
    final livro = buscarLivroPorId(emprestimo.livroId);
    if (livro == null) {
      throw Exception('Livro não encontrado');
    }
    if (!livro.disponivel) {
      throw Exception('Livro não está disponível para empréstimo');
    }

    // Verificar se o usuário está ativo
    final usuario = buscarUsuarioPorEmail(emprestimo.emailUsuario);
    if (usuario == null) {
      throw Exception('Usuário não encontrado');
    }
    if (!usuario.ativo) {
      throw Exception('Usuário não está ativo');
    }

    // Gerar ID único se não existir
    if (emprestimo.id == null) {
      final novoId = _emprestimos.isEmpty ? 1 : _emprestimos.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      emprestimo = Emprestimo(
        id: novoId,
        livroId: emprestimo.livroId,
        livro: emprestimo.livro,
        nomeUsuario: emprestimo.nomeUsuario,
        emailUsuario: emprestimo.emailUsuario,
        dataEmprestimo: emprestimo.dataEmprestimo,
        dataPrevistaDevolucao: emprestimo.dataPrevistaDevolucao,
        observacoes: emprestimo.observacoes,
      );
    }

    // Adicionar o empréstimo
    _emprestimos.add(emprestimo);

    // Atualizar disponibilidade do livro
    _atualizarDisponibilidadeLivro(emprestimo.livroId, false);

    notifyListeners();
  }

  void finalizarEmprestimo(Emprestimo emprestimo) {
    final index = _emprestimos.indexWhere((e) => e.id == emprestimo.id);
    if (index != -1) {
      final emprestimoFinalizado = Emprestimo(
        id: emprestimo.id,
        livroId: emprestimo.livroId,
        livro: emprestimo.livro,
        nomeUsuario: emprestimo.nomeUsuario,
        emailUsuario: emprestimo.emailUsuario,
        dataEmprestimo: emprestimo.dataEmprestimo,
        dataPrevistaDevolucao: emprestimo.dataPrevistaDevolucao,
        dataDevolucao: DateTime.now(),
        ativo: false,
        observacoes: emprestimo.observacoes,
      );

      _emprestimos[index] = emprestimoFinalizado;

      // Atualizar disponibilidade do livro
      _atualizarDisponibilidadeLivro(emprestimo.livroId, true);

      notifyListeners();
    }
  }

  void _atualizarDisponibilidadeLivro(int livroId, bool disponivel) {
    final index = _livros.indexWhere((l) => l.id == livroId);
    if (index != -1) {
      _livros[index] = _livros[index].copyWith(disponivel: disponivel);
    }
  }

  List<Emprestimo> buscarEmprestimosPorUsuario(String email) {
    return _emprestimos.where((e) => e.emailUsuario.toLowerCase() == email.toLowerCase()).toList();
  }

  List<Emprestimo> buscarEmprestimosPorLivro(int livroId) {
    return _emprestimos.where((e) => e.livroId == livroId).toList();
  }

  List<Emprestimo> get emprestimosAtivos {
    return _emprestimos.where((e) => e.ativo).toList();
  }

  List<Emprestimo> get emprestimosAtrasados {
    return _emprestimos.where((e) => e.ativo && e.estaAtrasado).toList();
  }

  // Métodos para inicializar dados de exemplo (útil para testes)
  void inicializarDadosExemplo() {
    // Adicionar alguns livros de exemplo
    _livros = [
      Livro(
        id: 1,
        titulo: 'Dom Casmurro',
        autor: 'Machado de Assis',
        isbn: '978-8525406682',
        anoPublicacao: 1899,
        categoria: 'Ficção',
        descricao: 'Romance clássico da literatura brasileira que narra a história de Bentinho e Capitu.',
      ),
      Livro(
        id: 2,
        titulo: 'Clean Code',
        autor: 'Robert C. Martin',
        isbn: '978-0132350884',
        anoPublicacao: 2008,
        categoria: 'Técnico',
        descricao: 'Manual sobre como escrever código limpo e manutenível.',
      ),
      Livro(
        id: 3,
        titulo: '1984',
        autor: 'George Orwell',
        isbn: '978-0451524935',
        anoPublicacao: 1949,
        categoria: 'Ficção',
        descricao: 'Distopia sobre um mundo totalitário onde o governo controla todos os aspectos da vida.',
      ),
      Livro(
        id: 4,
        titulo: 'Flutter in Action',
        autor: 'Eric Windmill',
        isbn: '978-1617296147',
        anoPublicacao: 2019,
        categoria: 'Técnico',
        descricao: 'Guia completo para desenvolvimento de aplicações móveis com Flutter.',
        disponivel: false,
      ),
    ];

    // Adicionar alguns usuários de exemplo
    _usuarios = [
      Usuario(
        id: 1,
        nome: 'João Silva',
        email: 'joao@email.com',
        telefone: '(11) 99999-9999',
      ),
      Usuario(
        id: 2,
        nome: 'Maria Santos',
        email: 'maria@email.com',
        telefone: '(11) 88888-8888',
      ),
      Usuario(
        id: 3,
        nome: 'Pedro Oliveira',
        email: 'pedro@email.com',
        telefone: '(11) 77777-7777',
        ativo: false,
      ),
    ];

    // Adicionar alguns empréstimos de exemplo
    final livroFlutter = _livros.firstWhere((l) => l.id == 4);
    _emprestimos = [
      Emprestimo(
        id: 1,
        livroId: 4,
        livro: livroFlutter,
        nomeUsuario: 'João Silva',
        emailUsuario: 'joao@email.com',
        dataEmprestimo: DateTime.now().subtract(const Duration(days: 10)),
        dataPrevistaDevolucao: DateTime.now().add(const Duration(days: 4)),
        observacoes: 'Empréstimo para estudo de Flutter.',
      ),
    ];

    notifyListeners();
  }

  // Método para limpar todos os dados
  void limparDados() {
    _livros.clear();
    _usuarios.clear();
    _emprestimos.clear();
    notifyListeners();
  }
}