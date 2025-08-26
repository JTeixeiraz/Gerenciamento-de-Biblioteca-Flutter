# Sistema de Gerenciamento de Biblioteca Digital com Flutter

Este é um aplicativo Flutter completo que simula um sistema de gerenciamento para uma biblioteca digital. Ele permite o cadastro e a gestão de livros, usuários e empréstimos, apresentando uma interface de usuário clara e funcional.

O projeto foi desenvolvido para consolidar conhecimentos sobre os pilares do Flutter, incluindo a criação de classes, o uso de herança e o gerenciamento de estado com o pacote `provider`.

## ✨ Funcionalidades Principais

O aplicativo conta com as seguintes funcionalidades:

*   **Dashboard Interativo**: Uma tela inicial que apresenta estatísticas em tempo real sobre o estado da biblioteca, como número de livros, empréstimos ativos e usuários.
*   **Gerenciamento de Livros**:
    *   Cadastro de novos livros com informações detalhadas (título, autor, ISBN, categoria, etc.).
    *   Edição e remoção de livros existentes.
    *   Visualização da lista completa de livros, com status de "Disponível" ou "Emprestado".
*   **Gerenciamento de Usu��rios**:
    *   Cadastro e edição de usuários (leitores).
    *   Possibilidade de ativar ou desativar um usuário, controlando sua permissão para realizar empréstimos.
*   **Sistema de Empréstimos**:
    *   Registro de novos empréstimos, associando um livro disponível a um usuário ativo.
    *   Controle de disponibilidade dos livros (um livro emprestado não pode ser emprestado novamente).
    *   Visualização de empréstimos ativos e do histórico de empréstimos já finalizados.
    *   Destaque visual para empréstimos próximos do vencimento ou já atrasados.

## 🏛️ Arquitetura e Estrutura do Projeto

O código-fonte está organizado na pasta `lib` seguindo uma estrutura clara para facilitar a manutenção e a escalabilidade:

```
lib/
├── main.dart               # Ponto de entrada da aplicação
├── classes/                # Modelos de dados (entidades)
│   ├── Livro.dart
│   ├── Usuario.dart
│   └── Emprestimo.dart
├── provider/               # Gerenciamento de estado central
│   └── BibliotecaProvider.dart
├── screens/                # Widgets que representam as telas principais
│   ├── home_page.dart
│   ├── books_page.dart
│   ├── users_page.dart
│   └── emprestimos_page.dart
└── widgets/                # Widgets reutilizáveis
    ├── FormLivroWidget.dart
    ├── FormUsuarioWidget.dart
    ├── FormEmprestimoWidget.dart
    └── EstatisticasDashboardWidget.dart
```

### Classes de Modelo (`/classes`)

*   `Livro.dart`: Representa a entidade livro, com todas as suas propriedades.
*   `Usuario.dart`: Modela o usuário da biblioteca.
*   `Emprestimo.dart`: Modela a relação de empréstimo entre um livro e um usuário.

### Gerenciamento de Estado (`/provider`)

*   `BibliotecaProvider.dart`: É o cérebro da aplicação. Utiliza o padrão `ChangeNotifier` para gerenciar todas as listas (livros, usuários, empréstimos) e a lógica de negócios. Ele atua como a única fonte de verdade, e os widgets da interface reagem às suas alterações.

### Telas (`/screens`)

*   `home_page.dart`: A tela principal, que serve como um hub de navegação.
*   `books_page.dart`: Tela para listar, adicionar, editar e remover livros.
*   `users_page.dart`: Tela para gerenciar os usu��rios.
*   `emprestimos_page.dart`: Tela com abas para visualizar empréstimos ativos e o histórico.

### Widgets (`/widgets`)

*   **Formulários**: `FormLivroWidget`, `FormUsuarioWidget` e `FormEmprestimoWidget` são formulários completos, com validação e estado próprio, usados para adicionar e editar dados.
*   `EstatisticasDashboardWidget.dart`: O painel de estatísticas exibido na `HomePage`.

## 🚀 Como Executar o Projeto

Para executar este projeto, você precisa ter o Flutter SDK instalado e configurado em sua máquina.

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/JTeixeiraz/Gerenciamento-de-Biblioteca-Flutter
    ```

2.  **Navegue até o diretório do projeto:**
    ```bash
    cd Gerenciamento-de-Biblioteca-Flutter
    ```

3.  **Instale as dependências:**
    O projeto utiliza o pacote `provider`. O Flutter irá instalá-lo automaticamente ao executar o comando abaixo.
    ```bash
    flutter pub get
    ```

4.  **Execute o aplicativo:**
    Conecte um dispositivo ou inicie um emulador e execute o seguinte comando:
    ```bash
    flutter run
    ```

O aplicativo será compilado e iniciado no seu dispositivo/emulador. Ele começará com um conjunto de dados de exemplo para que você possa testar todas as funcionalidades imediatamente.
