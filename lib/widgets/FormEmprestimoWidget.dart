import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Emprestimo.dart';
import '../models/Livro.dart';
import '../models/Usuario.dart';
import '../provider/BibliotecaProvider.dart';

class FormEmprestimoWidget extends StatefulWidget {
  final Function(Emprestimo) onSalvar;
  final VoidCallback? onCancelar;

  const FormEmprestimoWidget({
    Key? key,
    required this.onSalvar,
    this.onCancelar,
  }) : super(key: key);

  @override
  FormEmprestimoWidgetState createState() => FormEmprestimoWidgetState();
}

class FormEmprestimoWidgetState extends State<FormEmprestimoWidget> {
  final _formKey = GlobalKey<FormState>();
  Usuario? _usuarioSelecionado;
  Livro? _livroSelecionado;
  late DateTime _dataPrevistaDevolucao;
  late String _observacoes;
  bool _isProcessando = false;

  @override
  void initState() {
    super.initState();
    _inicializarCampos();
  }

  void _inicializarCampos() {
    _usuarioSelecionado = null;
    _livroSelecionado = null;
    _dataPrevistaDevolucao = DateTime.now().add(const Duration(days: 14));
    _observacoes = '';
  }

  bool _validar() {
    if (_usuarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um usuário'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_livroSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um livro'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return _formKey.currentState?.validate() ?? false;
  }

  void _limpar() {
    setState(() {
      _inicializarCampos();
      _formKey.currentState?.reset();
    });
  }

  Future<void> _salvar() async {
    if (!_validar()) return;

    setState(() {
      _isProcessando = true;
    });

    // Simula operação assíncrona
    await Future.delayed(const Duration(seconds: 1));

    final emprestimo = Emprestimo(
      livroId: _livroSelecionado!.id!,
      livro: _livroSelecionado!,
      nomeUsuario: _usuarioSelecionado!.nome,
      emailUsuario: _usuarioSelecionado!.email,
      dataPrevistaDevolucao: _dataPrevistaDevolucao,
      observacoes: _observacoes.trim(),
    );

    widget.onSalvar(emprestimo);

    setState(() {
      _isProcessando = false;
    });

    _limpar();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Registrar Novo Empréstimo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Dropdown de Usuário
                Consumer<BibliotecaProvider>(
                  builder: (context, provider, child) {
                    final usuariosAtivos =
                        provider.usuarios.where((u) => u.ativo).toList();

                    if (usuariosAtivos.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Nenhum usuário ativo encontrado. Cadastre usuários primeiro.',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return DropdownButtonFormField<Usuario>(
                      value: _usuarioSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Selecionar Usuário',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: usuariosAtivos.map((usuario) {
                        final emprestimosAtivos = provider.emprestimos
                            .where((e) =>
                                e.emailUsuario == usuario.email && e.ativo)
                            .length;

                        return DropdownMenuItem(
                          value: usuario,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                usuario.nome,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                              ),
                              // Text(
                              //   usuario.email,
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     color: Colors.grey.shade600,
                              //   ),
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              // if (emprestimosAtivos > 0)
                              //   Text(
                              //     '$emprestimosAtivos empréstimo(s) ativo(s)',
                              //     style: TextStyle(
                              //       fontSize: 11,
                              //       color: Colors.blue.shade600,
                              //     ),
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (usuario) {
                        setState(() {
                          _usuarioSelecionado = usuario;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um usuário';
                        }
                        return null;
                      },
                      isExpanded: true,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown de Livro
                Consumer<BibliotecaProvider>(
                  builder: (context, provider, child) {
                    final livrosDisponiveis =
                        provider.livros.where((l) => l.disponivel).toList();

                    if (livrosDisponiveis.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Nenhum livro disponível para empréstimo.',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return DropdownButtonFormField<Livro>(
                      value: _livroSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Selecionar Livro',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                      items: livrosDisponiveis.map((livro) {
                        return DropdownMenuItem(
                          value: livro,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                livro.titulo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Text(
                              //   'Por: ${livro.autor}',
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     color: Colors.grey.shade600,
                              //   ),
                              // ),
                              // Text(
                              //   '${livro.categoria} • ${livro.anoPublicacao}',
                              //   style: TextStyle(
                              //     fontSize: 11,
                              //     color: Colors.grey.shade500,
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (livro) {
                        setState(() {
                          _livroSelecionado = livro;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um livro';
                        }
                        return null;
                      },
                      isExpanded: true,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Data de Devolução Prevista
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Data Prevista de Devolução',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: Icon(Icons.edit),
                  ),
                  controller: TextEditingController(
                    text: _formatDate(_dataPrevistaDevolucao),
                  ),
                  onTap: () async {
                    final data = await showDatePicker(
                      context: context,
                      initialDate: _dataPrevistaDevolucao,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      helpText: 'Selecionar data de devolução',
                      cancelText: 'Cancelar',
                      confirmText: 'OK',
                    );

                    if (data != null) {
                      setState(() {
                        _dataPrevistaDevolucao = data;
                      });
                    }
                  },
                  validator: (value) {
                    if (_dataPrevistaDevolucao.isBefore(DateTime.now())) {
                      return 'Data deve ser futura';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Observações
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Observações (opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  onChanged: (value) => _observacoes = value,
                  maxLength: 200,
                ),
                const SizedBox(height: 24),

                // Resumo do empréstimo (se ambos estiverem selecionados)
                if (_usuarioSelecionado != null &&
                    _livroSelecionado != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumo do Empréstimo:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('📚 Livro: ${_livroSelecionado!.titulo}'),
                        Text('👤 Usuário: ${_usuarioSelecionado!.nome}'),
                        Text(
                            '📅 Devolução: ${_formatDate(_dataPrevistaDevolucao)}'),
                        Text(
                            '⏰ Prazo: ${_dataPrevistaDevolucao.difference(DateTime.now()).inDays} dias'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Botões de ação
                // Botões de ação
                Wrap(
                  spacing: 8.0, // Espaçamento horizontal entre os botões
                  runSpacing:
                      8.0, // Espaçamento vertical entre as linhas de botões
                  alignment: WrapAlignment.center, // Alinha os botões à direita
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: _isProcessando ? null : _salvar,
                        child: _isProcessando
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Registrando...'),
                                ],
                              )
                            : const Text('Registrar Empréstimo'),
                      ),
                    ),

                    if (widget.onCancelar != null)
                      TextButton(
                        onPressed: _isProcessando ? null : widget.onCancelar,
                        child: const Text('Cancelar'),
                      ),
                    TextButton(
                      onPressed: _isProcessando ? null : _limpar,
                      child: const Text('Limpar'),
                    ),                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
