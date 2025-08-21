import 'package:flutter/material.dart';
import 'package:atividade/screens/books_page.dart';
import 'package:provider/provider.dart';
import '../provider/BibliotecaProvider.dart';

class EstatisticasDashboardWidget extends StatelessWidget {
  const EstatisticasDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BibliotecaProvider>(
      builder: (context, provider, child) {
        final totalLivros = provider.livros.length;
        final livrosDisponiveis = provider.livros.where((l) => l.disponivel).length;
        final livrosEmprestados = totalLivros - livrosDisponiveis;
        final totalUsuarios = provider.usuarios.length;
        final usuariosAtivos = provider.usuarios.where((u) => u.ativo).length;
        final emprestimosAtivos = provider.emprestimos.where((e) => e.ativo).length;
        final emprestimosAtrasados = provider.emprestimos.where((e) => e.estaAtrasado).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do Dashboard
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard,
                    size: 32,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Dashboard da Biblioteca',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // Estatísticas principais em cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BooksPage()),
                      );
                    },
                    child: _buildStatCard(
                      title: 'Total de Livros',
                      value: totalLivros.toString(),
                      icon: Icons.library_books,
                      color: Colors.blue,
                      subtitle: '$livrosDisponiveis disponíveis',
                    ),
                  ),
                  _buildStatCard(
                    title: 'Empréstimos Ativos',
                    value: emprestimosAtivos.toString(),
                    icon: Icons.book_online,
                    color: Colors.orange,
                    subtitle: '$livrosEmprestados livros emprestados',
                  ),
                  _buildStatCard(
                    title: 'Total de Usuários',
                    value: totalUsuarios.toString(),
                    icon: Icons.people,
                    color: Colors.green,
                    subtitle: '$usuariosAtivos ativos',
                  ),
                  _buildStatCard(
                    title: 'Empréstimos Atrasados',
                    value: emprestimosAtrasados.toString(),
                    icon: Icons.warning,
                    color: Colors.red,
                    subtitle: emprestimosAtrasados > 0 ? 'Requer atenção!' : 'Tudo em dia!',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Seção de atividade recente
            if (provider.emprestimos.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Atividade Recente',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _buildAtividadeRecente(provider),
            ],

            const SizedBox(height: 24),

            // Seção de livros mais populares (se houver empréstimos)
            if (provider.emprestimos.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Livros Mais Emprestados',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _buildLivrosMaisPopulares(provider),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtividadeRecente(BibliotecaProvider provider) {
    // Pegar os 3 empréstimos mais recentes
    final emprestimosRecentes = provider.emprestimos
        .toList()
      ..sort((a, b) => b.dataEmprestimo.compareTo(a.dataEmprestimo));

    final emprestimosParaMostrar = emprestimosRecentes.take(3).toList();

    if (emprestimosParaMostrar.isEmpty) {
      return Container();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: emprestimosParaMostrar.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final emprestimo = emprestimosParaMostrar[index];
          final isAtrasado = emprestimo.estaAtrasado;

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: emprestimo.ativo
                  ? (isAtrasado ? Colors.red.shade100 : Colors.blue.shade100)
                  : Colors.green.shade100,
              child: Icon(
                emprestimo.ativo
                    ? (isAtrasado ? Icons.warning : Icons.book)
                    : Icons.check_circle,
                color: emprestimo.ativo
                    ? (isAtrasado ? Colors.red.shade700 : Colors.blue.shade700)
                    : Colors.green.shade700,
                size: 20,
              ),
            ),
            title: Text(
              emprestimo.livro.titulo,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emprestado para: ${emprestimo.nomeUsuario}'),
                Text(
                  emprestimo.ativo
                      ? 'Em ${_formatDate(emprestimo.dataEmprestimo)}${isAtrasado ? ' • Atrasado' : ''}'
                      : 'Devolvido em ${emprestimo.dataDevolucao != null ? _formatDate(emprestimo.dataDevolucao!) : 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isAtrasado ? Colors.red : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            trailing: emprestimo.ativo
                ? Chip(
              label: Text(
                isAtrasado
                    ? 'Atrasado'
                    : '${emprestimo.diasRestantes}d',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: isAtrasado
                  ? Colors.red.shade100
                  : Colors.blue.shade100,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
                : const Icon(Icons.check_circle, color: Colors.green),
          );
        },
      ),
    );
  }

  Widget _buildLivrosMaisPopulares(BibliotecaProvider provider) {
    // Contar empréstimos por livro
    final Map<int, int> contadorEmprestimos = {};
    final Map<int, String> titulosLivros = {};

    for (final emprestimo in provider.emprestimos) {
      contadorEmprestimos[emprestimo.livroId] =
          (contadorEmprestimos[emprestimo.livroId] ?? 0) + 1;
      titulosLivros[emprestimo.livroId] = emprestimo.livro.titulo;
    }

    // Ordenar por número de empréstimos
    final livrosOrdenados = contadorEmprestimos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Pegar os top 3
    final topLivros = livrosOrdenados.take(3).toList();

    if (topLivros.isEmpty) {
      return Container();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: topLivros.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final entry = topLivros[index];
          final livroId = entry.key;
          final numeroEmprestimos = entry.value;
          final titulo = titulosLivros[livroId] ?? 'Livro não encontrado';

          // Encontrar o livro para pegar mais detalhes
          final livro = provider.livros.firstWhere(
                (l) => l.id == livroId,
            orElse: () => provider.livros.first,
          );

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ),
            title: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('Por: ${livro.autor}'),
            trailing: Chip(
              label: Text(
                '$numeroEmprestimos empréstimo${numeroEmprestimos > 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.purple.shade100,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}