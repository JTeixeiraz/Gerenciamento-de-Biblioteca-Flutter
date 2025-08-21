import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/Livro.dart';
import '../provider/BibliotecaProvider.dart';
import '../widgets/FormLivroWidget.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Livros'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarFormularioLivro(context),
          ),
        ],
      ),
      body: Consumer<BibliotecaProvider>(
        builder: (context, provider, child) {
          final livros = provider.livros;

          if (livros.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum livro cadastrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no botão + para adicionar um livro',
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
            itemCount: livros.length,
            itemBuilder: (context, index) {
              final livro = livros[index];
              return _buildBookCard(context, livro, provider);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioLivro(context),
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Livro livro, BibliotecaProvider provider) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: livro.disponivel ? Colors.green.shade100 : Colors.orange.shade100,
          child: Icon(
            Icons.book,
            color: livro.disponivel ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
        title: Text(
          livro.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Autor: ${livro.autor}'),
            Text('Gênero: ${livro.categoria}'),
            const SizedBox(height: 4),
            Chip(
              label: Text(livro.disponivel ? 'Disponível' : 'Emprestado'),
              backgroundColor: livro.disponivel ? Colors.green.shade100 : Colors.orange.shade100,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              _mostrarFormularioLivro(context, livro);
            } else if (value == 'remover') {
              _confirmarRemoverLivro(context, livro, provider);
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
            const PopupMenuItem(
              value: 'remover',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18),
                  SizedBox(width: 8),
                  Text('Remover'),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _mostrarFormularioLivro(BuildContext context, [Livro? livro]) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxHeight: 600),
          child: FormularioLivroWidget(
            livroParaEdicao: livro,
            onSalvar: (livroSalvo) {
              final provider = Provider.of<BibliotecaProvider>(context, listen: false);
              if (livro == null) {
                provider.adicionarLivro(livroSalvo);
              } else {
                provider.editarLivro(livroSalvo);
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    livro == null
                        ? 'Livro cadastrado com sucesso!'
                        : 'Livro atualizado com sucesso!',
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

  void _confirmarRemoverLivro(BuildContext context, Livro livro, BibliotecaProvider provider) {
    if (!livro.disponivel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não é possível remover um livro que está emprestado.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Livro'),
        content: Text('Tem certeza que deseja remover o livro "${livro.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.removerLivro(livro.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livro removido com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}