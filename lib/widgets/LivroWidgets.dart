import 'package:atividade/models/Livro.dart';
import 'package:flutter/material.dart';

abstract class LivroWidget extends StatelessWidget {
  final Livro livro;
  final Function(Livro) onEditar;
  final Function(Livro) onRemover;
  final Function(Livro) onEmprestar;

  const LivroWidget({
    Key? key,
    required this.livro,
    required this.onEditar,
    required this.onRemover,
    required this.onEmprestar,
  }) : super(key: key);
// Método abstrato que deve ser implementado pelas classes derivadas
  Widget buildDetalhes(BuildContext context);
// Método abstrato para retornar o tipo específico de livro
  String getTipoLivro();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color:
              livro.disponivel ? Colors.green.shade200 : Colors.orange.shade200,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              livro.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(livro.autor),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "editar") {
                  onEditar(livro);
                } else if (value == "remover") {
                  onRemover(livro);
                } else if (value == "emprestar" && livro.disponivel) {
                  onEmprestar(livro);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "editar",
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text("Editar"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: "remover",
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18),
                      SizedBox(width: 8),
                      Text("Remover"),
                    ],
                  ),
                ),
                if (livro.disponivel)
                  const PopupMenuItem(
                    value: "emprestar",
                    child: Row(
                      children: [
                        Icon(Icons.book, size: 18),
                        SizedBox(width: 8),
                        Text("Emprestar"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
// Detalhes específicos implementados pelas classes derivadas
          buildDetalhes(context),
// Rodapé do card com informações comuns
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: livro.disponivel
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  label: Text(
                    livro.disponivel ? "Disponível" : "Emprestado",
                    style: TextStyle(
                      color: livro.disponivel
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                  avatar: Icon(
                    livro.disponivel
                        ? Icons.check_circle
                        : Icons.hourglass_empty,
                    size: 18,
                    color: livro.disponivel
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
                Text(
                  "Tipo: ${getTipoLivro()}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
