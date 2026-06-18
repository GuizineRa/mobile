import 'package:flutter/material.dart';

import '../models/veiculo.dart';
import '../controllers/veiculo_controller.dart';
import 'cadastro_veiculo_view.dart';
import 'detalhes_veiculo_view.dart';


class HomeView extends StatefulWidget {

  const HomeView({
    super.key,
  });


  @override
  State<HomeView> createState() =>
      _HomeViewState();

}



class _HomeViewState extends State<HomeView> {


  final VeiculoController controller =
      VeiculoController();


  List<Veiculo> veiculos = [];



  @override
  void initState() {

    super.initState();

    carregarVeiculos();

  }



  void carregarVeiculos() async {


    final resultado =
        await controller.listarVeiculos();


    setState(() {

      veiculos = resultado;

    });

  }



  void abrirCadastro() async {


    await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) =>

        const CadastroVeiculoView(),

      ),

    );


    carregarVeiculos();

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Meus Veículos",
        ),

      ),



      floatingActionButton:

      FloatingActionButton(

        onPressed:
        abrirCadastro,


        child:
        const Icon(
          Icons.add,
        ),

      ),



      body:

      veiculos.isEmpty

      ?

      const Center(

        child:
        Text(
          "Nenhum veículo cadastrado.",
        ),

      )


      :

      ListView.builder(

        itemCount:
        veiculos.length,


        itemBuilder:
        (context, index) {


          final veiculo =
          veiculos[index];



          return Card(

            margin:
            const EdgeInsets.all(8),


            child:

            ListTile(

              leading:
              const Icon(
                Icons.directions_car,
              ),



              title:

              Text(

                "${veiculo.marca} ${veiculo.modelo}",

              ),



              subtitle:

              Text(

                "Ano: ${veiculo.ano} | Placa: ${veiculo.placa}",

              ),



              trailing:

              const Icon(
                Icons.arrow_forward_ios,
              ),



              onTap: () {


                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>

                    DetalhesVeiculoView(

                      veiculo:
                      veiculo,

                    ),

                  ),

                );


              },


            ),

          );


        },

      ),

    );

  }

}