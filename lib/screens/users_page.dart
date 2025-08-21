import '../classes/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/BibliotecaProvider.dart';
import '../widgets/FormUsuarioWidget.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuários'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _mostrarFormularioUsuario(context),
          ),
        ],
      ),
      body: Consumer<BibliotecaProvider>(
        builder: (context, provider, child) {
          final usuarios = provider.usuarios;

          if (usuarios.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum usuário cadastrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no botão + para adicionar um usuário',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return _buildUserCard(context, usuario, provider);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioUsuario(context),
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Usuario usuario, BibliotecaProvider provider) {
    final emprestimosAtivos = provider.emprestimos
        .where((e) => e.emailUsuario == usuario.email && e.ativo)
        .length;

    final emprestimosAtrasados = provider.emprestimos
        .where((e) => e.emailUsuario == usuario.email && e.estaAtrasado)
        .length;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: usuario.ativo ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(
            Icons.person,
            color: usuario.ativo ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
        title: Text(
          usuario.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usuario.email),
            if (usuario.telefone.isNotEmpty)
              Text(usuario.telefone),
            const SizedBox(height: 4),
            Row(
              children: [
                if (emprestimosAtivos > 0) ...[
                  Chip(
                    label: Text('$emprestimosAtivos empréstimo(s)'),
                    backgroundColor: Colors.blue.shade100,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 4),
                ],
                if (emprestimosAtrasados > 0)
                  Chip(
                    label: Text('$emprestimosAtrasados atrasado(s)'),
                    backgroundColor: Colors.red.shade100,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              _mostrarFormularioUsuario(context, usuario);
            } else if (value == 'desativar') {
              _confirmarDesativarUsuario(context, usuario, provider);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'desativar',
              child: Row(
                children: [
                  Icon(
                    usuario.ativo ? Icons.block : Icons.check_circle,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(usuario.ativo ? 'Desativar' : 'Ativar'),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _mostrarFormularioUsuario(BuildContext context, [Usuario? usuario]) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxHeight: 600),
          child: FormUsuarioWidget(
            usuarioParaEdicao: usuario,
            onSalvar: (usuarioSalvo) {
              final provider = Provider.of<BibliotecaProvider>(context, listen: false);
              if (usuario == null) {
                provider.adicionarUsuario(usuarioSalvo);
              } else {
                provider.editarUsuario(usuarioSalvo);
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    usuario == null
                        ? 'Usuário cadastrado com sucesso!'
                        : 'Usuário atualizado com sucesso!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onCancelar: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  void _confirmarDesativarUsuario(BuildContext context, Usuario usuario, BibliotecaProvider provider) {
    final temEmprestimosAtivos = provider.emprestimos
        .any((e) => e.emailUsuario == usuario.email && e.ativo);

    if (temEmprestimosAtivos && usuario.ativo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não é possível desativar usuário com empréstimos ativos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${usuario.ativo ? 'Desativar' : 'Ativar'} usuário'),
        content: Text(
            'Tem certeza que deseja ${usuario.ativo ? 'desativar' : 'ativar'} o usuário ${usuario.nome}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.toggleUsuarioAtivo(usuario);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Usuário ${usuario.ativo ? 'desativado' : 'ativado'} com sucesso!'
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(usuario.ativo ? 'Desativar' : 'Ativar'),
          ),
        ],
      ),
    );
  }
}