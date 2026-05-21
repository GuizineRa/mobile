import 'package:exemplo_share/view/exemplo1_page.dart';
import 'package:exemplo_share/view/exemplo2_page.dart';
import 'package:exemplo_share/view/home_page.dart';
import 'package:flutter/material.dart';


void main(List<String> args) {
  runApp(MaterialApp(
    routes: {
     "/tela1": (context) => Exemplo1Page(),
     "/tela2": (context) => Exemplo2Page(),
      // "/tela3": (context) => Exemplo3Page()
    },
    home: HomePage(),
  )); //MeterialApp
}