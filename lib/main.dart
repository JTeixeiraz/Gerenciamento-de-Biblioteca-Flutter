import 'package:atividade/screens/books_page.dart';
import 'package:atividade/screens/form_screen.dart';
import 'package:atividade/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: MyApp(),
      );
  }
}


class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MyApp> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    FormScreen(),
    BooksPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_align_center),
              label: 'Forms'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}