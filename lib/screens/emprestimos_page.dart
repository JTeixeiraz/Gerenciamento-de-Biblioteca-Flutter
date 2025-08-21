import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/BibliotecaProvider.dart';
import '../widgets/FormEmprestimoWidget.dart';
import '../classes/Emprestimo.dart';

class EmprestimosPage extends StatefulWidget {
  const EmprestimosPage({Key? key}) : super(key: key);

  @override
  State<EmprestimosPage> createState() => _EmprestimosPageState();
}

class _EmprestimosPageState extends State<EmprestimosPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Empréstimos'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.schedule),
              text: 'Ativos',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Histórico',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _mostrarFormularioEmprestimo(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmprestimosAtivos(),
          _buildHistoricoEmprestimos(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioEmprestimo(context),
        backgroundColor: Colors.orange.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmprestimosAtivos() {
    return Consumer<BibliotecaProvider>(
      builder: (context, provider, child) {
        final emprestimosAtivos = provider.emprestimos
            .where((e) => e.ativo)
            .toList();

        if (emprestimosAtivos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum empréstimo ativo',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Toque no botão + para registrar um empréstimo',
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
          itemCount: emprestimosAtivos.length,
          itemBuilder: (context, index) {
            final emprestimo = emprestimosAtivos[index];
            return _buildEmprestimoCard(context, emprestimo, provider, true);
          },
        );
      },
    );
  }

  Widget _buildHistoricoEmprestimos() {
    return Consumer<BibliotecaProvider>(
      builder: (context, provider, child) {
        final emprestimosConcluidos = provider.emprestimos
            .where((e) => !e.ativo)
            .toList()
          ..sort((a, b) => (b.dataDevolucao ?? DateTime.now())
              .compareTo(a.dataDevolucao ?? DateTime.now()));

        if (emprestimosConcluidos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum empréstimo concluído',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: emprestimosConcluidos.length,
          itemBuilder: (context, index) {
            final emprestimo = emprestimosConcluidos[index];
            return _buildEmprestimoCard(context, emprestimo, provider, false);
          },
        );
      },
    );
  }

  Widget _buildEmprestimoCard(BuildContext context, Emprestimo emprestimo,
      BibliotecaProvider provider, bool isAtivo) {
    final isAtrasado = emprestimo.estaAtrasado;
    final diasRestantes = emprestimo.diasRestantes;

    Color cardColor = Colors.white;
    Color borderColor = Colors.grey.shade300;

    if (isAtivo) {
      if (isAtrasado) {
        cardColor = Colors.red.shade50;
        borderColor = Colors.red.shade300;
      } else if (diasRestantes <= 3) {
        cardColor = Colors.orange.shade50;
        borderColor = Colors.orange.shade300;
      } else {
        cardColor = Colors.green.shade50;
        borderColor = Colors.green.shade300;
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com título do livro e status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emprestimo.livro.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Por: ${emprestimo.livro.autor}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isAtivo) ...[
                  if (isAtrasado)
                    Chip(
                      label: Text('${-diasRestantes} dias atrasado'),
                      backgroundColor: Colors.red.shade100,
                      avatar: const Icon(Icons.warning, size: 16, color: Colors.red),
                    )
                  else if (diasRestantes <= 3)
                    Chip(
                      label: Text('$diasRestantes dias restantes'),
                      backgroundColor: Colors.orange.shade100,
                      avatar: const Icon(Icons.schedule, size: 16, color: Colors.orange),
                    )
                  else
                    Chip(
                      label: Text('$diasRestantes dias restantes'),
                      backgroundColor: Colors.green.shade100,
                      avatar: const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    ),
                ] else
                  const Chip(
                    label: Text('Devolvido'),
                    backgroundColor: Colors.grey,
                    avatar: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Informações do usuário
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    emprestimo.nomeUsuario,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(emprestimo.emailUsuario),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Datas
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emprestado em:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _formatDate(emprestimo.dataEmprestimo),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAtivo ? 'Devolução prevista:' : 'Devolvido em:',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _formatDate(isAtivo
                            ? emprestimo.dataPrevistaDevolucao
                            : emprestimo.dataDevolucao!),
                        style: TextStyle(
                          fontSize: 14,
                          color: isAtivo && isAtrasado ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Observações se existirem
            if (emprestimo.observacoes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Observações:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emprestimo.observacoes,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            // Botão de devolução para empréstimos ativos
            if (isAtivo) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmarDevolucao(context, emprestimo, provider),
                  icon: const Icon(Icons.assignment_return),
                  label: const Text('Registrar Devolução'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _mostrarFormularioEmprestimo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxHeight: 700),
          child: FormEmprestimoWidget(
            onSalvar: (emprestimo) {
              final provider = Provider.of<BibliotecaProvider>(context, listen: false);
              provider.adicionarEmprestimo(emprestimo);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Empréstimo registrado com sucesso!'),
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

  void _confirmarDevolucao(BuildContext context, Emprestimo emprestimo, BibliotecaProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Devolução'),
        content: Text(
            'Confirma a devolução do livro "${emprestimo.livro.titulo}" por ${emprestimo.nomeUsuario}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.finalizarEmprestimo(emprestimo);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Devolução registrada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar Devolução'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}