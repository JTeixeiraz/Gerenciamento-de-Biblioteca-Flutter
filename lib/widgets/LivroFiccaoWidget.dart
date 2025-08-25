import 'package:atividade/models/Livro.dart';
import 'package:atividade/widgets/LivroWidgets.dart';
import 'package:flutter/material.dart';

class LivroFiccaoWidget extends LivroWidget {
  final String genero;
  final String? serieOuTrilogia;
  const LivroFiccaoWidget({
    Key? key,
    required Livro livro,
    required Function(Livro) onEditar,
    required Function(Livro) onRemover,
    required Function(Livro) onEmprestar,
    required this.genero,
    this.serieOuTrilogia,
  }) : super(
          key: key,
          livro: livro,
          onEditar: onEditar,
          onRemover: onRemover,
          onEmprestar: onEmprestar,
        );
  @override
  String getTipoLivro() => "Ficção";
  @override
  Widget buildDetalhes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Row(
            children: [
              const Icon(Icons.category, size: 16, color: Colors.purple),
              const SizedBox(width: 8),
              Text("Gênero: $genero"),
            ],
          ),
          const SizedBox(height: 8),
          if (serieOuTrilogia != null) ...[
            Row(
              children: [
                const Icon(Icons.collections_bookmark,
                    size: 16, color: Colors.purple),
                const SizedBox(width: 8),
                Text("Série/Trilogia: $serieOuTrilogia"),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text("Publicado em ${livro.anoPublicacao}"),
            ],
          ),
          const SizedBox(height: 8),
          if (livro.descricao.isNotEmpty) ...[
            const Text(
              "Sinopse:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              livro.descricao,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
