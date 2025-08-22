import '../classes/Usuario.dart';
import 'package:flutter/material.dart';

class FormUsuarioWidget extends StatefulWidget {
  final Usuario? usuarioParaEdicao;
  final Function(Usuario) onSalvar;
  final VoidCallback? onCancelar;

  const FormUsuarioWidget({
    Key? key,
    this.usuarioParaEdicao,
    required this.onSalvar,
    this.onCancelar,
  }) : super(key: key);

  @override
  FormUsuarioWidgetState createState() => FormUsuarioWidgetState();
}

class FormUsuarioWidgetState extends State<FormUsuarioWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _email;
  late String _telefone;
  late bool _ativo;
  bool _isProcessando = false;

  @override
  void initState() {
    super.initState();
    _inicializarCampos();
  }

  void _inicializarCampos() {
    final usuario = widget.usuarioParaEdicao;
    if (usuario != null) {
      _nome = usuario.nome;
      _email = usuario.email;
      _telefone = usuario.telefone;
      _ativo = usuario.ativo;
    } else {
      _nome = '';
      _email = '';
      _telefone = '';
      _ativo = true;
    }
  }

  bool _validar() {
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

    final usuario = Usuario(
      id: widget.usuarioParaEdicao?.id,
      nome: _nome.trim(),
      email: _email.trim().toLowerCase(),
      telefone: _telefone.trim(),
      ativo: _ativo,
      dataCadastro: widget.usuarioParaEdicao?.dataCadastro,
      emprestimos: widget.usuarioParaEdicao?.emprestimos ?? [],
    );

    widget.onSalvar(usuario);

    setState(() {
      _isProcessando = false;
    });

    if (widget.usuarioParaEdicao == null) {
      _limpar();
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.usuarioParaEdicao == null
                    ? 'Cadastrar Novo Usuário'
                    : 'Editar Usuário',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Campo Nome
              TextFormField(
                initialValue: _nome,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o nome completo';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
                onChanged: (value) => _nome = value,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o email';
                  }
                  final emailRegExp = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegExp.hasMatch(value.trim())) {
                    return 'Por favor, informe um email válido';
                  }
                  return null;
                },
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 16),

              // Campo Telefone
              TextFormField(
                initialValue: _telefone,
                decoration: const InputDecoration(
                  labelText: 'Telefone (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: '(11) 99999-9999',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final phoneRegExp = RegExp(r'^\(\d{2}\)\s\d{4,5}-\d{4}$');
                    if (!phoneRegExp.hasMatch(value.trim())) {
                      return 'Formato: (11) 99999-9999';
                    }
                  }
                  return null;
                },
                onChanged: (value) => _telefone = value,
              ),
              const SizedBox(height: 16),

              // Switch para status ativo
              SwitchListTile(
                title: const Text('Usuário ativo'),
                value: _ativo,
                onChanged: (value) {
                  setState(() {
                    _ativo = value;
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(height: 18),

              Center(
                child: Text(
                  _ativo
                      ? 'Usuário pode realizar empréstimos'
                      : 'Usuário não pode realizar empréstimos',
                ),
              ),
              const SizedBox(height: 24),

              // Botão principal (Cadastrar/Atualizar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessando ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
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
                            Text('Salvando...'),
                          ],
                        )
                      : Text(
                          widget.usuarioParaEdicao == null
                              ? 'Cadastrar'
                              : 'Atualizar',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 8),

              // Botões secundários (Cancelar e Limpar)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onCancelar != null)
                    TextButton(
                      onPressed: _isProcessando ? null : widget.onCancelar,
                      child: const Text('Cancelar'),
                    ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _isProcessando ? null : _limpar,
                    child: const Text('Limpar'),
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
