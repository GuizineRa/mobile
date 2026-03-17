// tela para estudo dos widgets de exibição
//  text, image, icon entre outros

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      //configurações iniciais do App
      //router => rotas de navegação
      //home => pagina Inicial
      home: MyApp(),
      //themeApp => (Claro/Escuro)
    ),
  ); //gosto de colocar o MaterialApp no void main
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // estrutura da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //elemento principal da tela
      //appbar, drawer, bnBar, body, fabutton, snakebar
      appBar: AppBar(title: Text("Exemplos de Widget de Exibição")),

      //adicionar um elemento de Scroll

      body: SingleChildScrollView(
        //+ usado para scroll de Tela Inteira
        child: Padding(
          padding: EdgeInsets.all(16),
          //Widget de Text
          //adicionar um container
        
          child: Expanded(
            //+ usado para Scroll de Parte da Tela
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Explorando o Flutter",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                //dentro da column
                //adicionar uma image
                Image.network(
                  //Link URL daImagem
                  "https://media.istockphoto.com/id/2191817235/pt/foto/earth-under-alien-invasion.jpg?s=2048x2048&w=is&k=20&c=6kKGUhVzrNK4v0VA-2nIJUBDIjrcoPgDwJTFe2AN3Hk=",
                  height: 600,
                  fit: BoxFit.contain,),
                //adicionar imagem local
                Image.asset("assets/img/loucura.jpg",
                  height: 250,
                  fit: BoxFit.cover,)
                    
              ],
            ),
          ),
        ),
      ),

    );
  }
}
