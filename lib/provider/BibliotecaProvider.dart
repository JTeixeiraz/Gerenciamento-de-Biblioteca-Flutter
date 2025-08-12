import 'dart:collection';

import 'package:atividade/classes/Livro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//pra poder acessar o hashmap em outros lugares do codigo com o mesmo valor sendo settado por outros lugares
class BibliotecaProvider with ChangeNotifier {
  final HashMap<String, Livro> _livros = HashMap<String, Livro>();

  HashMap<String, Livro> get livrosMap => HashMap<String, Livro>.from(_livros);

  int get quantidadeLivros => _livros.length;

  List<Livro> get livrosDisponiveis =>
      _livros.values.where((livro) => livro.disponivel).toList();

  List<Livro> get livrosEmprestados =>
      _livros.values.where((livro) => !livro.disponivel).toList();

  void adicionarOuAtualizar(Livro livro) {
    late bool adicionado;
    if (livro.id == null) {
      final novoId = _livros.length + 1;
      livro = livro.copyWith(id: novoId);
    }
    for (int i = 0; i <= _livros.length; i++) {
      if (_livros[i]?.isbn == livro.isbn) {
        adicionado = false;
        return;
      } else {
        _livros[livro.isbn] = livro;
      }
    }
    if (adicionado == true) {
      notifyListeners();
    }
  }

  Livro? buscaLivro(String isbn) {
    return _livros[isbn];
  }

  bool removeLivro(String isbn) {
    final remove = _livros.remove(isbn) != null;
    if (remove == true) {
      notifyListeners();
    }
    return remove;
  }

  List<Livro> filtrarLivro(
      String? categoria, String? termoBusca, bool? disponivel) {
    List<Livro> todosLivros = _livros.values.toList();
    if (categoria != null && categoria.isNotEmpty) {
      todosLivros = todosLivros
          .where((livro) =>
              livro.categoria.toUpperCase() == categoria.toUpperCase())
          .toList();
    }
    if (termoBusca != null && termoBusca.isNotEmpty) {
      todosLivros = todosLivros
          .where((livro) =>
              livro.titulo.toUpperCase().contains(termoBusca.toUpperCase()) ||
              livro.autor.toUpperCase().contains(termoBusca.toUpperCase()) ||
              livro.isbn.toUpperCase().contains(termoBusca.toUpperCase()))
          .toList();
    }
    if(disponivel != null){
      todosLivros = todosLivros.where((livro)=> livro.disponivel == disponivel).toList();
    }
    return todosLivros;
  }
}
