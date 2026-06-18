import 'package:flutter/material.dart';

import '../models/veiculo.dart';
import '../models/manutencao.dart';
import '../controllers/manutencao_controller.dart';
import 'cadastro_manutencao_view.dart';


class DetalhesVeiculoView extends StatefulWidget {

  final Veiculo veiculo;


  const DetalhesVeiculoView({
    super.key,
    required this.veiculo,
  });


  @override
  State<DetalhesVeiculoView> createState() =>
      _DetalhesVeiculoViewState();

}



class _DetalhesVeiculoViewState
    extends State<DetalhesVeiculoView> {


  final ManutencaoController controller =
      ManutencaoController();


  List<Manutencao> manutencoes = [];



  @override
  void initState() {

    super.initState();

    carregarManutencoes();

  }



  void carregarManutencoes() async {


    final resultado =
        await controller.listarManutencoesPorVeiculo(
          widget.veiculo.id!,
        );


    setState(() {

      manutencoes = resultado;

    });

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        Text(
          widget.veiculo.modelo,
        ),

      ),



      floatingActionButton:
      FloatingActionButton(

        child:
        const Icon(
          Icons.add,
        ),


        onPressed: () async {


          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (context) =>

              CadastroManutencaoView(

                veiculoId:
                widget.veiculo.id!,

              ),

            ),

          );


          carregarManutencoes();


        },

      ),



      body: Padding(

        padding:
        const EdgeInsets.all(16),



        child:
        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Text(

              "${widget.veiculo.marca} ${widget.veiculo.modelo}",

              style:
              const TextStyle(

                fontSize: 22,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(
              height: 10,
            ),



            Text(
              "Ano: ${widget.veiculo.ano}",
            ),


            Text(
              "Placa: ${widget.veiculo.placa}",
            ),


            Text(
              "Quilometragem inicial: ${widget.veiculo.quilometragemInicial} km",
            ),



            const Divider(),



            const Text(

              "Histórico de Manutenções",

              style:
              TextStyle(

                fontSize: 18,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            Expanded(

              child:

              manutencoes.isEmpty

              ?

              const Center(

                child:
                Text(
                  "Nenhuma manutenção registrada.",
                ),

              )


              :

              ListView.builder(

                itemCount:
                manutencoes.length,


                itemBuilder:
                (context, index) {


                  final manutencao =
                  manutencoes[index];


                  return Card(

                    child:
                    ListTile(

                      title:
                      Text(
                        manutencao.tipoServico,
                      ),


                      subtitle:
                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children: [


                          Text(
                            "Data: ${manutencao.data}",
                          ),


                          Text(
                            "KM: ${manutencao.quilometragem}",
                          ),


                          Text(
                            "Custo: R\$ ${manutencao.custo}",
                          ),


                          Text(
                            manutencao.observacoes,
                          ),

                        ],

                      ),

                    ),

                  );


                },

              ),

            ),

          ],

        ),

      ),

    );

  }

}