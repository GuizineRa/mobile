import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0; //indice de navegação entre páginas


// lista de páginas 
final List<Widget> _pages = []
    const BookListView(),
    const



  @override
  Widget build(BuildContext context) {
    return Scaffold();
    
  }
}
