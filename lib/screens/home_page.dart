import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/BibliotecaProvider.dart';
import '../widgets/EstatisticasDashboardWidget.dart';
import 'books_page.dart';
import 'users_page.dart';
import 'emprestimos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Inicializar dados de exemplo quando o app abre pela primeira vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BibliotecaProvider>(context, listen: false);
      if (provider.livros.isEmpty) {
        provider.inicializarDadosExemplo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Digital'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              final provider =
                  Provider.of<BibliotecaProvider>(context, listen: false);
              switch (value) {
                case 'reset':
                  _mostrarDialogoReset(context, provider);
                  break;
                case 'dados_exemplo':
                  provider.inicializarDadosExemplo();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dados de exemplo carregados!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'dados_exemplo',
                child: Row(
                  children: [
                    Icon(Icons.data_usage, size: 18),
                    SizedBox(width: 8),
                    Text('Carregar Dados de Exemplo'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text('Resetar Sistema'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Widget de Estatísticas do Dashboard
            const EstatisticasDashboardWidget(),

            const SizedBox(height: 24),

            // Seção de Ações Rápidas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ações Rápidas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12, // Espaçamento horizontal entre os cards
                    runSpacing:
                        12, // Espaçamento vertical entre as linhas de cards
                    alignment: WrapAlignment.start, // Alinha os cards ao início
                    children: [
                      _buildActionCard(
                        title: 'Gerenciar Livros',
                        subtitle: 'Adicionar, editar e visualizar livros',
                        icon: Icons.library_books,
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BooksPage()),
                        ),
                      ),
                      _buildActionCard(
                        title: 'Gerenciar Usuários',
                        subtitle: 'Cadastrar e editar usuários',
                        icon: Icons.people,
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UsersPage()),
                        ),
                      ),
                      _buildActionCard(
                        title: 'Empréstimos',
                        subtitle: 'Registrar e controlar empréstimos',
                        icon: Icons.book_online,
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmprestimosPage()),
                        ),
                      ),
                      _buildActionCard(
                        title: 'Empréstimos Atrasados',
                        subtitle: 'Verificar livros em atraso',
                        icon: Icons.warning,
                        color: Colors.red,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmprestimosPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Seção de Notificações/Alertas
            Consumer<BibliotecaProvider>(
              builder: (context, provider, child) {
                final emprestimosAtrasados = provider.emprestimosAtrasados;
                final emprestimosVencendoEm3Dias = provider.emprestimosAtivos
                    .where((e) => e.diasRestantes <= 3 && !e.estaAtrasado)
                    .toList();

                if (emprestimosAtrasados.isEmpty &&
                    emprestimosVencendoEm3Dias.isEmpty) {
                  return Container();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alertas e Notificações',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Alertas de empréstimos atrasados
                      if (emprestimosAtrasados.isNotEmpty)
                        Card(
                          color: Colors.red.shade50,
                          child: ListTile(
                            leading:
                                Icon(Icons.warning, color: Colors.red.shade700),
                            title: Text(
                              '${emprestimosAtrasados.length} empréstimo(s) atrasado(s)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            subtitle: const Text(
                                'Clique para verificar os empréstimos atrasados'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EmprestimosPage(),
                              ),
                            ),
                          ),
                        ),

                      // Alertas de empréstimos vencendo em breve
                      if (emprestimosVencendoEm3Dias.isNotEmpty)
                        Card(
                          color: Colors.orange.shade50,
                          child: ListTile(
                            leading: Icon(Icons.schedule,
                                color: Colors.orange.shade700),
                            title: Text(
                              '${emprestimosVencendoEm3Dias.length} empréstimo(s) vencendo em breve',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            subtitle: const Text(
                                'Empréstimos que vencem em até 3 dias'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EmprestimosPage(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmprestimosPage()),
        ),
        backgroundColor: Colors.indigo.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Novo Empréstimo',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
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
                      size: 32,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: color.withOpacity(0.7),
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoReset(BuildContext context, BibliotecaProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetar Sistema'),
        content: const Text(
          'Tem certeza que deseja resetar o sistema? Todos os dados serão perdidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.limparDados();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sistema resetado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }
}
