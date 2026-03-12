import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PerfilApp());
}

class PerfilApp extends StatelessWidget {
  const PerfilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PerfilPage(),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  Widget postImage() {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: const Icon(Icons.image, size: 40),
    );
  }

  Widget infoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[300],
      child: Text(text),
    );
  }

  Widget socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Icon(icon, size: 35),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Perfil do Usuário",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const Icon(Icons.camera_alt, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.menu, color: Colors.black),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER PERFIL
            Container(
              color: Colors.grey[700],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // FOTO PERFIL
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),

                      const SizedBox(width: 20),

                      // NOME E DESCRIÇÃO
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            SizedBox(height: 6),
                            Text(
                              "Descrição: ____________\n"
                              "_______________________\n"
                              "_______________________",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.settings, color: Colors.white)
                    ],
                  ),

                  const SizedBox(height: 15),

                  // SEGUINDO / POSTS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      infoBox("Seguindo: 0"),
                      infoBox("Posts: 0"),
                      infoBox("Seguidores: 0"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ATRIBUTOS
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lista de Atributos:",
                                style: TextStyle(color: Colors.white)),
                            Text("Skills: ___",
                                style: TextStyle(color: Colors.white)),
                            Text("Onde moro: ___",
                                style: TextStyle(color: Colors.white)),
                            Text("Empresa: ___",
                                style: TextStyle(color: Colors.white)),
                            Text("Hobbie: ___",
                                style: TextStyle(color: Colors.white)),
                            Text("Lazer: ___",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),

                      // REDES SOCIAIS
                     Column(
                        children: [
                          socialIcon(FontAwesomeIcons.facebook),
                          socialIcon(FontAwesomeIcons.whatsapp),
                          socialIcon(FontAwesomeIcons.tiktok),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // GRID DE IMAGENS
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                postImage(),
                postImage(),
                postImage(),
                postImage(),
                postImage(),
                postImage(),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}