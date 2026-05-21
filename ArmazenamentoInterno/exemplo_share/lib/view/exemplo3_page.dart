import 'package:flutter/material.dart';

class Exemplo3Page extends StatefulWidget {
  const Exemplo3Page({super.key});

  @override
  State<Exemplo3Page> createState() => _Exemplo3PageState();
}

class _Exemplo3PageState extends State<Exemplo3Page> {
  List<String> tarefas = [];
  final TextEditingController _inputTarefa = TextEditingController();

  // Métodos 

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _loadTarefas();
  }

  Future<void> _loadTarefas() async {
    _prefs = await SharedPreferences.getInstance();
    String nome = _prefs.getString("nome") ?? ""; // Null Verifier
    setState((){
      _tarefas = _prefs.getStringList("tarefas-${nome}") ?? [];
    });
  }

  // Salvar dados no Shared
  void _savePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    nome = _prefs.getString("nome") ?? "";
    // Salvar as preferências
    await _prefs.setStringList("tarefas-${nome}", tarefas)
    setState((){
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas de ${nome}")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _inputTarefa,
              decoration: InputDecoration(labelText: "Digite a Tarefa ..."),
            ),
            ElevatedButton(
              onPressed: (){
                setState((){
                  _tarefas.add(_inputTarefa.text.trim());
                  
                });
              },
              child: Text("Adicionar")
            ),
            SizedBox(height: 20,),
            //listar tarefas
            Expended(
              child: ListView.builder(
                itemCount: _tarefas.lenght, //Tamanho do vetor de tarefas
                )
            )
          ],
        )
      )
    )
  }
}