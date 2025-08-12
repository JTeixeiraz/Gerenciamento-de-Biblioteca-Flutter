import 'dart:collection';

import 'package:atividade/widgets/FormLivroWidget.dart';
import 'package:atividade/widgets/FormularioWidget.dart';
import 'package:flutter/material.dart';
import 'package:atividade/classes/Livro.dart';
import 'package:atividade/widgets/LivroWidgets.dart';

class FormularioLivroWidget extends FormularioWidget {
  final Livro? livroParaEdicao;
  final Function(Livro) onSalvar;
  final VoidCallback? onCancelar;

  FormularioLivroWidget({
    Key? key,
    this.livroParaEdicao,
    required this.onSalvar,
    this.onCancelar,
  }) : super(key: key);

  @override
  FormularioLivroWidgetState createState() => FormularioLivroWidgetState();
}

class FormularioLivroWidgetState extends State<FormularioLivroWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _titulo;
  late String _autor;
  late String _isbn;
  late int _anoPublicacao;
  late String _categoria;
  late bool _disponivel;
  late String _descricao;
  bool _isProcessando = false;
  static HashMap<String, Livro>livros = HashMap<String, Livro>();

  @override
  void initState() {
    super.initState();
    _inicializarCampos();
  }

  void _inicializarCampos() {
    final livro = widget.livroParaEdicao;
    if (livro != null) {
      _titulo = livro.titulo;
      _autor = livro.autor;
      _isbn = livro.isbn;
      _anoPublicacao = livro.anoPublicacao;
      _categoria = livro.categoria;
      _disponivel = livro.disponivel;
      _descricao = livro.descricao;
    } else {
      _titulo = "";
      _autor = "";
      _isbn = "";
      _anoPublicacao = DateTime.now().year;
      _categoria = "";
      _disponivel = true;
      _descricao = "";
    }
  }

  @override
  bool validar() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void limpar() {
    setState(() {
      _inicializarCampos();
      _formKey.currentState?.reset();
    });
  }

  @override
  Future<void> salvar() async {
    if (!validar()) return;

    setState(() {
      _isProcessando = true;
    });

    // Simula operação assíncrona
    await Future.delayed(const Duration(seconds: 1));

    final livro = Livro(
      id: widget.livroParaEdicao?.id,
      titulo: _titulo,
      autor: _autor,
      isbn: _isbn,
      anoPublicacao: _anoPublicacao,
      categoria: _categoria,
      disponivel: _disponivel,
      dataCadastro: widget.livroParaEdicao?.dataCadastro,
      descricao: _descricao,
    );

    livros[_isbn] = livro;

    widget.onSalvar(livro);



    setState(() {
      _isProcessando = false;
    });

    if (widget.livroParaEdicao == null) {
      limpar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.livroParaEdicao == null ? "Cadastrar Novo Livro" : "Editar Livro",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Título
              TextFormField(
                initialValue: _titulo,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, informe o título";
                  }
                  return null;
                },
                onChanged: (value) => _titulo = value,
              ),
              const SizedBox(height: 16),

              // Autor
              TextFormField(
                initialValue: _autor,
                decoration: const InputDecoration(
                  labelText: "Autor",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, informe o autor";
                  }
                  return null;
                },
                onChanged: (value) => _autor = value,
              ),
              const SizedBox(height: 16),

              // ISBN e Ano de Publicação
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _isbn,
                      decoration: const InputDecoration(
                        labelText: "ISBN",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, informe o ISBN";
                        }
                        return null;
                      },
                      onChanged: (value) => _isbn = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _anoPublicacao.toString(),
                      decoration: const InputDecoration(
                        labelText: "Ano de Publicação",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Informe o ano";
                        }
                        final ano = int.tryParse(value);
                        if (ano == null || ano < 1000 || ano > 2100) {
                          return "Ano inválido";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final ano = int.tryParse(value);
                        if (ano != null) {
                          _anoPublicacao = ano;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<String>(
                value: _categoria.isNotEmpty ? _categoria : null,
                decoration: const InputDecoration(
                  labelText: "Categoria",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Ficção", child: Text("Ficção")),
                  DropdownMenuItem(value: "Não-ficção", child: Text("Não ficção")),
                  DropdownMenuItem(value: "Técnico", child: Text("Técnico")),
                  DropdownMenuItem(value: "Acadêmico", child: Text("Acadêmico")),
                  DropdownMenuItem(value: "Romance", child: Text("Romance")),
                  DropdownMenuItem(value: "Suspense", child: Text("Suspense")),
                  DropdownMenuItem(value: "Biografia", child: Text("Biografia")),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, selecione uma categoria";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoria = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Disponível
              SwitchListTile(
                title: const Text("Disponível para empréstimo"),
                value: _disponivel,
                onChanged: (value) {
                  setState(() {
                    _disponivel = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                initialValue: _descricao,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                onChanged: (value) => _descricao = value,
              ),
              const SizedBox(height: 24),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onCancelar != null)
                    TextButton(
                      onPressed: _isProcessando ? null : widget.onCancelar,
                      child: const Text("Cancelar"),
                    ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _isProcessando ? null : limpar,
                    child: const Text("Limpar"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isProcessando ? null : salvar,
                    child: _isProcessando
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text("Salvando..."),
                            ],
                          )
                        : Text(widget.livroParaEdicao == null ? "Cadastrar" : "Atualizar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
