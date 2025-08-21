
Checklist de Verificação

✅ Conceitos Básicos
Sei criar uma classe com propriedades: ok
Entendo construtores com parâmetros nomeados: ok
Sei usar required em parâmetros obrigatórios: ok
Consigo criar métodos em classes: ok

✅ Herança
Entendo o conceito de classe abstrata
Sei usar extends para herdar de uma classe
Consigo implementar métodos abstratos
Sei usar super() em construtores
Entendo quando usar @override

✅ Widgets Flutter
Sei a diferença entre StatelessWidget e StatefulWidget
Consigo criar um StatelessWidget simples
Sei implementar o método build()
Entendo quando usar cada tipo de widget

✅ Gerenciamento de Estado
Sei criar um StatefulWidget
Entendo o que é o State de um widget
Consigo usar setState() corretamente
Sei quando usar setState

✅ Formulários
Sei usar o widget Form
Entendo como funciona GlobalKey
Consigo criar TextFormField com validação
Sei usar controladores de texto
Entendo como validar formulários

✅ Navegação
Sei navegar entre telas com Navigator.push
Consigo voltar para tela anterior com Navigator.pop
Entendo como passar dados entre telas
Sei usar rotas nomeadas

✅ Organização
Entendo a estrutura de pastas recomendada
Sei separar widgets em arquivos diferentes
Consigo organizar models, screens e widgets
Entendo a importância da organização

---------------------

| Tela                                 | Função Principal                                        |
| ------------------------------------ | ------------------------------------------------------- |
| **DashboardScreen**                  | Visão geral e estatísticas                              |
| **GerenciarLivrosScreen**            | Listar, adicionar, editar e visualizar livros           |
| **GerenciarEmprestimosScreen**       | Gerenciar empréstimos e ver histórico                   |
| **FormularioLivroScreen**            | Adicionar/editar livro (com validação e estado)         |
| **FormularioEmprestimoScreen**       | Registrar empréstimos (com controle de disponibilidade) |
| **DetalhesLivroScreen** *(opcional)* | Exibir detalhes específicos do livro (ficção/técnico)   |


------


Atividade Prática - Sistema de Biblioteca
Digital com Flutter

Modalidade: Individual ou em dupla

Tema: Classes, Herança e Gerenciamento de Estado no Flutter

Contextualização
Esta atividade prática foi desenvolvida para consolidar os conhecimentos sobre classes,
herança e gerenciamento de estado no Flutter. Vocês vão desenvolver um sistema completo
de biblioteca digital que demonstra na prática todos os conceitos abordados em aula.
O projeto simula um ambiente real de desenvolvimento, onde múltiplas classes e widgets
precisam se relacionar de forma eficiente, utilizando as melhores práticas de organização de
código e arquitetura de software. Através desta atividade, vocês vão experienciar situações
comuns no desenvolvimento de aplicações mobile modernas, preparando-os para desafios
profissionais futuros.

Objetivos de Aprendizagem
Objetivos Gerais
Ao final desta atividade, você será capaz de desenvolver aplicações Flutter complexas
utilizando classes, herança e gerenciamento de estado de forma eficiente.

Objetivos Específicos
• Implementar classes base e derivadas utilizando herança
• Criar widgets personalizados que herdam de StatelessWidget e StatefulWidget

• Aplicar construtores com parâmetros nomeados e uso de super
• Implementar métodos abstratos e sobrescritos

• Organizar código seguindo boas práticas de estruturação de projetos Flutter
• Criar componentes reutilizáveis que demonstrem componentização eficiente
• Implementar gerenciamento de estado local com setState
• Gerenciar estado entre múltiplos widgets de forma consistente

Especificação do Projeto
Visão Geral
Você irá desenvolver um Sistema de Biblioteca Digital que permite gerenciar livros, autores e
empréstimos. O sistema deve demonstrar todos os conceitos de classes, herança e
gerenciamento de estado estudados nas aulas.
Funcionalidades Principais
. Gerenciamento de Livros
• Cadastro de novos livros com informações completas
• Listagem de livros com filtros e ordenação
• Edição e remoção de livros existentes
• Visualização detalhada de cada livro

. Sistema de Empréstimos
• Registro de empréstimos com data e usuário

• Controle de disponibilidade dos livros
• Histórico de empréstimos por livro
• Notificações de prazos de devolução
. Interface Interativa

• Dashboard com estatísticas em tempo real

• Componentes de carregamento com animações

• Formulários com validação em tempo real

• Notificações de sucesso e erro

️ Arquitetura e Classes
Estrutura de Pastas Obrigatória
biblioteca_digital/
├── lib/
│ ├── main.dart
│ ├── screens/
│ │ ├── dashboard_screen.dart
│ │ ├── gerenciar_livros_screen.dart
│ │ └── gerenciar_emprestimos_screen.dart
│ ├── widgets/
│ │ ├── formularios/
│ │ │ ├── formulario_livro_widget.dart
│ │ │ └── formulario_emprestimo_widget.dart
│ │ ├── cards/
│ │ │ ├── card_livro_widget.dart
│ │ │ └── card_emprestimo_widget.dart
│ │ ├── listas/
│ │ │ ├── lista_livros_widget.dart
│ │ │ └── lista_emprestimos_widget.dart
│ │ └── componentes/
│ │ ├── componente_carregamento_widget.dart
│ │ └── estatisticas_dashboard_widget.dart
│ ├── models/
│ │ ├── livro.dart
│ │ ├── emprestimo.dart
│ │ └── usuario.dart
│ └── services/
│ ├── biblioteca_service.dart
│ └── notificacao_service.dart
└── assets/
└── images/
└── book_cover_placeholder.png

Classes e Widgets Detalhados
. LivroWidget (classe base abstrata)
• Responsabilidade: Definir a estrutura base para exibição de livros

• Herança: Herda de StatelessWidget
• Métodos abstratos: buildDetalhes() , getTipoLivro()
. LivroFiccaoWidget (classe derivada)
• Responsabilidade: Exibir livros de ficção com estilo específico

• Herança: Herda de LivroWidget
• Propriedades específicas: genero , serieOuTrilogia
. LivroTecnicoWidget (classe derivada)
• Responsabilidade: Exibir livros técnicos com estilo específico

• Herança: Herda de LivroWidget
• Propriedades específicas: area , nivelComplexidade
. FormularioWidget (classe base abstrata)
• Responsabilidade: Definir a estrutura base para formulários
• Herança: Herda de StatefulWidget
• Métodos abstratos: salvar() , limpar() , validar()
. FormularioLivroWidget (classe derivada)
• Responsabilidade: Capturar dados de novos livros ou edição

• Herança: Herda de FormularioWidget

• Gerenciamento de estado: Implementa setState para controle de formulário
. ComponenteCarregamentoWidget
• Responsabilidade: Exibir animação de carregamento
• Herança: Herda de StatefulWidget
• Animações: Implementa animações com AnimationController

Modelos de Dados
Classe Livro
class Livro {
int? id;
final String titulo;
final String autor;
final String isbn;
final int anoPublicacao;
final String categoria;
bool disponivel;
final DateTime dataCadastro;
final String descricao;
Livro({
this.id,
required this.titulo,
required this.autor,
required this.isbn,
required this.anoPublicacao,
required this.categoria,
this.disponivel = true,
DateTime? dataCadastro,
this.descricao = &#39;&#39;,
}) : this.dataCadastro = dataCadastro ?? DateTime.now();
// Método para criar uma cópia do livro com alterações Livro copyWith({
int? id,
String? titulo,
String? autor,
String? isbn,
int? anoPublicacao,
String? categoria,
bool? disponivel,
DateTime? dataCadastro,
String? descricao,
}) {

return Livro(
id: id ?? this.id,
titulo: titulo ?? this.titulo,
autor: autor ?? this.autor,
isbn: isbn ?? this.isbn,
anoPublicacao: anoPublicacao ?? this.anoPublicacao, categoria: categoria
?? this.categoria, disponivel: disponivel ?? this.disponivel, dataCadastro:
dataCadastro ?? this.dataCadastro, descricao: descricao ?? this.descricao,
);
}
}

Classe Emprestimo
class Emprestimo {
int? id;
final int livroId;
final Livro livro;
final String nomeUsuario;
final String emailUsuario;
final DateTime dataEmprestimo;
final DateTime dataPrevistaDevolucao;
DateTime? dataDevolucao;
bool ativo;
final String observacoes;
Emprestimo({
this.id,
required this.livroId,
required this.livro,
required this.nomeUsuario,
required this.emailUsuario,
DateTime? dataEmprestimo,
DateTime? dataPrevistaDevolucao,
this.dataDevolucao,
this.ativo = true,
this.observacoes = &#39;&#39;,
}) : this.dataEmprestimo = dataEmprestimo ?? DateTime.now(),
this.dataPrevistaDevolucao = dataPrevistaDevolucao ??
DateTime.now().add(Duration(days: 14));
// Método para verificar se o empréstimo está atrasado bool get
estaAtrasado {
if (!ativo) return false;
if (dataDevolucao != null) return false;
return DateTime.now().isAfter(dataPrevistaDevolucao); }
// Método para calcular dias restantes ou dias de atraso int get diasRestantes
{
if (!ativo || dataDevolucao != null) return 0;
final diferenca =

dataPrevistaDevolucao.difference(DateTime.now()).inDays; return
diferenca;
}
}

Classe Usuario
class Usuario {
int? id;
final String nome;
final String email;
final String telefone;
final DateTime dataCadastro;
bool ativo;
List&lt;Emprestimo&gt; emprestimos;
Usuario({
this.id,
required this.nome,
required this.email,
this.telefone = &#39;&#39;,
DateTime? dataCadastro,
this.ativo = true,
List&lt;Emprestimo&gt;? emprestimos,
}) : this.dataCadastro = dataCadastro ?? DateTime.now(), this.emprestimos =
emprestimos ?? [];
// Método para verificar se o usuário tem empréstimos ativos bool get
temEmprestimosAtivos {
return emprestimos.any((emprestimo) =&gt; emprestimo.ativo); }
// Método para verificar se o usuário tem empréstimos atrasados bool get
temEmprestimosAtrasados {
return emprestimos.any((emprestimo) =&gt; emprestimo.estaAtrasado); }
}

Implementação dos Widgets
. LivroWidget (classe base abstrata)
import &#39;package:flutter/material.dart&#39;;
import &#39;../models/livro.dart&#39;;
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
// Método abstrato que deve ser implementado pelas classes derivadas Widget
buildDetalhes(BuildContext context);
// Método abstrato para retornar o tipo específico de livro String getTipoLivro();
@override
Widget build(BuildContext context) {
return Card(
elevation: 4.0,
margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), shape:
RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12.0),
side: BorderSide(
color: livro.disponivel ? Colors.green.shade200 : Colors.orange.shade200,
width: 1.0,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Cabeçalho do card com título e menu de opções ListTile(
title: Text(
livro.titulo,
style: const TextStyle(fontWeight: FontWeight.bold), ),
subtitle: Text(livro.autor),
trailing: PopupMenuButton&lt;String&gt;(
onSelected: (value) {
if (value == &#39;editar&#39;) {
onEditar(livro);
} else if (value == &#39;remover&#39;) {
onRemover(livro);
} else if (value == &#39;emprestar&#39; &amp;&amp; livro.disponivel) { onEmprestar(livro);
}
},
itemBuilder: (context) =&gt; [
const PopupMenuItem(
value: &#39;editar&#39;,
child: Row(
children: [
Icon(Icons.edit, size: 18),

SizedBox(width: 8),
Text(&#39;Editar&#39;),

],
),
),
const PopupMenuItem(

value: &#39;remover&#39;,
child: Row(
children: [
Icon(Icons.delete, size: 18),

SizedBox(width: 8),
Text(&#39;Remover&#39;),

],
),
),
if (livro.disponivel)
const PopupMenuItem(
value: &#39;emprestar&#39;,
child: Row(
children: [
Icon(Icons.book, size: 18),

SizedBox(width: 8),
Text(&#39;Emprestar&#39;),

],
),
),
],
),
),
// Detalhes específicos implementados pelas classes derivadas buildDetalhes(context),
// Rodapé do card com informações comuns
Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
Chip(
backgroundColor: livro.disponivel ? Colors.green.shade100 : Colors.orange.shade100,
label: Text(
livro.disponivel ? &#39;Disponível&#39; : &#39;Emprestado&#39;, style: TextStyle(
color: livro.disponivel ? Colors.green.shade800 : Colors.orange.shade800,
),
),
avatar: Icon(
livro.disponivel ? Icons.check_circle : Icons.hourglass_empty,
size: 18,
color: livro.disponivel ? Colors.green.shade800 : Colors.orange.shade800,
),
),
Text(
&#39;Tipo: ${getTipoLivro()}&#39;,
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

. LivroFiccaoWidget (classe derivada)
import &#39;package:flutter/material.dart&#39;;
import &#39;../models/livro.dart&#39;;
import &#39;livro_widget.dart&#39;;
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
String getTipoLivro() =&gt; &#39;Ficção&#39;;
@override
Widget buildDetalhes(BuildContext context) {
return Padding(
padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Divider(),
Row(
children: [
const Icon(Icons.category, size: 16, color: Colors.purple), const SizedBox(width: 8),
Text(&#39;Gênero: $genero&#39;),
],
),
const SizedBox(height: 8),
if (serieOuTrilogia != null) ...[

Row(
children: [
const Icon(Icons.collections_bookmark, size: 16, color: Colors.purple),
const SizedBox(width: 8),
Text(&#39;Série/Trilogia: $serieOuTrilogia&#39;), ],
),
const SizedBox(height: 8),
],
Row(
children: [
const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8),
Text(&#39;Publicado em ${livro.anoPublicacao}&#39;), ],
),
const SizedBox(height: 8),
if (livro.descricao.isNotEmpty) ...[
const Text(
&#39;Sinopse:&#39;,
style: TextStyle(fontWeight: FontWeight.bold), ),
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

. FormularioLivroWidget (classe derivada)
import &#39;package:flutter/material.dart&#39;;
import &#39;../models/livro.dart&#39;;
import &#39;formulario_widget.dart&#39;;
class FormularioLivroWidget extends FormularioWidget {
final Livro? livroParaEdicao;
final Function(Livro) onSalvar;
final VoidCallback? onCancelar;
const FormularioLivroWidget({
Key? key,
this.livroParaEdicao,
required this.onSalvar,

this.onCancelar,
}) : super(key: key);
@override
FormularioLivroWidgetState createState() =&gt; FormularioLivroWidgetState(); }
class FormularioLivroWidgetState extends
FormularioWidgetState&lt;FormularioLivroWidget&gt; {
final _formKey = GlobalKey&lt;FormState&gt;();
late String _titulo;
late String _autor;
late String _isbn;
late int _anoPublicacao;
late String _categoria;
late bool _disponivel;
late String _descricao;
bool _isProcessando = false;
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
_anoPublicacao = livro.anoPublicacao; _categoria =
livro.categoria;
_disponivel = livro.disponivel;
_descricao = livro.descricao;
} else {
_titulo = &#39;&#39;;
_autor = &#39;&#39;;
_isbn = &#39;&#39;;
_anoPublicacao = DateTime.now().year; _categoria = &#39;&#39;;
_disponivel = true;
_descricao = &#39;&#39;;
}
}
@override
bool validar() {
return _formKey.currentState?.validate() ?? false; }
@override
void limpar() {
setState(() {

_inicializarCampos();
_formKey.currentState?.reset();
});
}
@override
Future&lt;void&gt; salvar() async {
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
dataCadastro: widget.livroParaEdicao?.dataCadastro, descricao:
_descricao,
);
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
widget.livroParaEdicao == null ? &#39;Cadastrar Novo Livro&#39; : &#39;Editar Livro&#39;,
style: Theme.of(context).textTheme.titleLarge, ),

const SizedBox(height: 16),
TextFormField(
initialValue: _titulo,
decoration: const InputDecoration(
labelText: &#39;Título&#39;,
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null || value.isEmpty) { return &#39;Por favor, informe o título&#39;; }
return null;
},
onChanged: (value) =&gt; _titulo = value,
),
const SizedBox(height: 16),
TextFormField(
initialValue: _autor,
decoration: const InputDecoration(
labelText: &#39;Autor&#39;,
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null || value.isEmpty) { return &#39;Por favor, informe o autor&#39;; }
return null;
},
onChanged: (value) =&gt; _autor = value,
),
const SizedBox(height: 16),
Row(
children: [
Expanded(
child: TextFormField(
initialValue: _isbn,

decoration: const InputDecoration(

labelText: &#39;ISBN&#39;,

border: OutlineInputBorder(),

),

validator: (value) {

if (value == null || value.isEmpty) { return &#39;Por favor, informe o ISBN&#39;; }

return null;

},

onChanged: (value) =&gt; _isbn = value,

),
),
const SizedBox(width: 16),
Expanded(
child: TextFormField(
initialValue: _anoPublicacao.toString(), decoration: const InputDecoration(
labelText: &#39;Ano de Publicação&#39;, border: OutlineInputBorder(),
),

keyboardType: TextInputType.number,

validator: (value) {
if (value == null || value.isEmpty) { return &#39;Informe o ano&#39;;
}

final ano = int.tryParse(value);
if (ano == null || ano &lt; 1000 || ano &gt; 2100) {

return &#39;Ano inválido&#39;;
}

return null;

},

onChanged: (value) {
final ano = int.tryParse(value); if (ano != null) {

_anoPublicacao = ano;
}
},
),
),
],
),
const SizedBox(height: 16),
DropdownButtonFormField&lt;String&gt;(
value: _categoria.isNotEmpty ? _categoria : null, decoration: const InputDecoration(
labelText: &#39;Categoria&#39;,
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(value: &#39;Ficção&#39;, child: Text(&#39;Ficção&#39;)), DropdownMenuItem(value: &#39;Não-ficção&#39;,
child: Text(&#39;Não ficção&#39;)),
DropdownMenuItem(value: &#39;Técnico&#39;, child: Text(&#39;Técnico&#39;)), DropdownMenuItem(value: &#39;Acadêmico&#39;,
child: Text(&#39;Acadêmico&#39;)),
DropdownMenuItem(value: &#39;Romance&#39;, child: Text(&#39;Romance&#39;)), DropdownMenuItem(value: &#39;Suspense&#39;,
child: Text(&#39;Suspense&#39;)),
DropdownMenuItem(value: &#39;Biografia&#39;, child: Text(&#39;Biografia&#39;)),
],
validator: (value) {
if (value == null || value.isEmpty) {
return &#39;Por favor, selecione uma categoria&#39;; }
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
SwitchListTile(
title: const Text(&#39;Disponível para empréstimo&#39;), value: _disponivel,
onChanged: (value) {
setState(() {

_disponivel = value;
});
},
),
const SizedBox(height: 16),
TextFormField(
initialValue: _descricao,
decoration: const InputDecoration(
labelText: &#39;Descrição&#39;,
border: OutlineInputBorder(),
alignLabelWithHint: true,
),
maxLines: 3,
onChanged: (value) =&gt; _descricao = value,
),
const SizedBox(height: 24),
Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
if (widget.onCancelar != null)
TextButton(
onPressed: _isProcessando ? null : widget.onCancelar, child: const Text(&#39;Cancelar&#39;),
),
const SizedBox(width: 16),
TextButton(
onPressed: _isProcessando ? null : limpar, child: const Text(&#39;Limpar&#39;),
),
const SizedBox(width: 16),
ElevatedButton(
onPressed: _isProcessando ? null : salvar, child: _isProcessando
? const Row(

mainAxisSize: MainAxisSize.min, children: [

SizedBox(
width: 16,

height: 16,
child: CircularProgressIndicator(

strokeWidth: 2,
),
),

SizedBox(width: 8),
Text(&#39;Salvando...&#39;),

],
)
: Text(widget.livroParaEdicao == null ? &#39;Cadastrar&#39; : &#39;Atualizar&#39;),
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
Entregáveis
. Código-fonte completo do aplicativo (.zip ou link para repositório)

• Todos os arquivos conforme a estrutura de pastas definida
• Implementação completa das classes e widgets especificados
• Código bem organizado e comentado
. Relatório técnico (PDF, máximo páginas) contendo:
• Diagrama da hierarquia de classes criadas
• Explicação das decisões de design tomadas
• Descrição de como você implementou a herança e o gerenciamento de estado
• Desafios encontrados e como foram superados
. Screenshots do aplicativo (pelo menos ) mostrando:
• Tela principal com a lista de livros
• Tela de cadastro/edição de livro
• Tela de empréstimo ou detalhes do livro

Critérios de Avaliação (Rubricas)
. Implementação de Classes e Herança
Pontuação Critério
Implementação completa e correta das classes base abstratas e classes, derivadas
com herança adequada.
Uso correto de construtores com super .

Implementação das classes base e derivadas com pequenos erros ou inconsistências na
herança. Construtores implementados corretamente.
Implementação básica de classes com herança, mas com erros significativos ou falta de
compreensão do conceito.
Não implementou herança ou implementou de forma incorreta.

Gerenciamento de Estado

Pontuação Critério
Implementação correta de StatefulWidget com gerenciamento de estado adequado. Uso

eficiente de setState e atualização da interface.

Implementação funcional de StatefulWidget com pequenos problemas no gerenciamento

de estado.

Implementação de StatefulWidget com problemas significativos no gerenciamento de

estado.

Não implementou StatefulWidget corretamente ou não demonstrou entendimento do

gerenciamento de estado.

. Interface e Funcionalidades
Pontuação Critério
Interface bem estruturada com todas as funcionalidades implementadas corretamente.

Uso adequado de widgets e propriedades do Flutter.

Interface funcional com a maioria das funcionalidades implementadas. Uso básico de

widgets e propriedades.

Interface com problemas de usabilidade ou funcionalidades incompletas.
Interface mal implementada ou não funcional.

Documentação e Relatório
Pontuação Critério
Código bem documentado com comentários claros. Relatório completo com diagrama

correto da hierarquia de classes e explicações detalhadas.
Código com documentação adequada. Relatório com diagrama e explicações

satisfatórias.

Documentação mínima no código. Relatório incompleto ou com explicações

superficiais.

Ausência de documentação significativa ou relatório não entregue.

Dicas para o Desenvolvimento
. Comece criando as classes base abstratas e teste-as antes de implementar as classes
derivadas.
. Utilize a documentação oficial do Flutter para entender os conceitos de herança e
gerenciamento de estado.
. Planeje a hierarquia de classes antes de começar a codificar.
. Teste seu aplicativo em diferentes tamanhos de tela para garantir que a interface seja
responsiva.
. Utilize o IDE para explorar as propriedades disponíveis através do autocomplete.
. Considere implementar funcionalidades extras como filtros por categoria ou ordenação por
data para demonstrar seu domínio dos conceitos.

Prazo de Entrega
• Data: 15/08/25