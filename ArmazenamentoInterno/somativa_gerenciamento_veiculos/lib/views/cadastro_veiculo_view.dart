import 'package:flutter/material.dart';

import '../controllers/veiculo_controller.dart';
import '../models/veiculo.dart';


class CadastroVeiculoView extends StatefulWidget {

  const CadastroVeiculoView({
    super.key,
  });


  @override
  State<CadastroVeiculoView> createState() =>
      _CadastroVeiculoViewState();

}



class _CadastroVeiculoViewState 
    extends State<CadastroVeiculoView> {


  final _formKey = GlobalKey<FormState>();


  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final anoController = TextEditingController();
  final placaController = TextEditingController();
  final quilometragemController = TextEditingController();



  final VeiculoController controller =
      VeiculoController();



  void salvar() async {


    if (_formKey.currentState!.validate()) {


      Veiculo veiculo = Veiculo(

        marca:
            marcaController.text,

        modelo:
            modeloController.text,


        ano:
            int.parse(
              anoController.text,
            ),


        placa:
            placaController.text,


        quilometragemInicial:
            double.parse(
              quilometragemController.text,
            ),

      );



      await controller.cadastrarVeiculo(
        veiculo,
      );



      ScaffoldMessenger.of(context)
          .showSnackBar(

            const SnackBar(

              content:
              Text(
                "Veículo cadastrado com sucesso!",
              ),

            ),

          );



      Navigator.pop(context);

    }

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Cadastrar Veículo",
        ),

      ),



      body: Padding(

        padding:
        const EdgeInsets.all(16),


        child: Form(

          key:
          _formKey,


          child:
          Column(

            children: [


              TextFormField(

                controller:
                marcaController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Marca",

                ),


                validator:
                (value) {

                  if(value == null ||
                      value.isEmpty) {

                    return
                    "Informe a marca";

                  }

                  return null;

                },

              ),



              TextFormField(

                controller:
                modeloController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Modelo",

                ),


              ),



              TextFormField(

                controller:
                anoController,


                keyboardType:
                TextInputType.number,


                decoration:
                const InputDecoration(

                  labelText:
                  "Ano",

                ),

              ),



              TextFormField(

                controller:
                placaController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Placa",

                ),

              ),



              TextFormField(

                controller:
                quilometragemController,


                keyboardType:
                TextInputType.number,


                decoration:
                const InputDecoration(

                  labelText:
                  "Quilometragem Inicial",

                ),

              ),



              const SizedBox(

                height:
                20,

              ),



              ElevatedButton(

                onPressed:
                salvar,


                child:
                const Text(

                  "Salvar Veículo",

                ),

              )


            ],

          ),

        ),

      ),

    );

  }

}