import 'package:flutter/material.dart';

import '../controllers/manutencao_controller.dart';
import '../models/manutencao.dart';


class CadastroManutencaoView extends StatefulWidget {

  final int veiculoId;

  const CadastroManutencaoView({
    super.key,
    required this.veiculoId,
  });


  @override
  State<CadastroManutencaoView> createState() =>
      _CadastroManutencaoViewState();
}



class _CadastroManutencaoViewState 
    extends State<CadastroManutencaoView> {


  final _formKey = GlobalKey<FormState>();


  final tipoServicoController = TextEditingController();
  final dataController = TextEditingController();
  final quilometragemController = TextEditingController();
  final custoController = TextEditingController();
  final observacoesController = TextEditingController();


  final ManutencaoController controller =
      ManutencaoController();



  void salvar() async {


    if (_formKey.currentState!.validate()) {


      Manutencao manutencao = Manutencao(

        veiculoId: widget.veiculoId,

        tipoServico:
            tipoServicoController.text,

        data:
            dataController.text,

        quilometragem:
            double.parse(
              quilometragemController.text,
            ),

        custo:
            double.parse(
              custoController.text,
            ),

        observacoes:
            observacoesController.text,

      );


      await controller.cadastrarManutencao(manutencao);



      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content:
              Text(
                "Manutenção cadastrada com sucesso!",
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
        title: const Text(
          "Nova Manutenção",
        ),
      ),


      body: Padding(

        padding:
            const EdgeInsets.all(16),


        child: Form(

          key: _formKey,


          child: Column(

            children: [


              TextFormField(
                controller:
                    tipoServicoController,

                decoration:
                    const InputDecoration(
                      labelText:
                      "Tipo de Serviço",
                    ),

                validator: (value) {

                  if(value == null ||
                     value.isEmpty) {

                    return "Informe o serviço";

                  }

                  return null;

                },

              ),



              TextFormField(
                controller:
                    dataController,

                decoration:
                    const InputDecoration(
                      labelText:
                      "Data",
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
                      "Quilometragem",
                    ),

              ),



              TextFormField(

                controller:
                    custoController,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                      labelText:
                      "Custo",
                    ),

              ),



              TextFormField(

                controller:
                    observacoesController,

                decoration:
                    const InputDecoration(
                      labelText:
                      "Observações",
                    ),

              ),



              const SizedBox(
                height: 20,
              ),



              ElevatedButton(

                onPressed:
                    salvar,


                child:
                    const Text(
                      "Salvar Manutenção",
                    ),

              )


            ],

          ),

        ),

      ),

    );

  }

}