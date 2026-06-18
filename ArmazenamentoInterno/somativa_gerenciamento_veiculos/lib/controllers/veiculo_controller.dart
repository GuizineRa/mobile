import '../models/veiculo.dart';
import '../database/database_helper.dart';

class VeiculoController {

  final DatabaseHelper _database = DatabaseHelper();


  // Cadastrar veículo
  Future<int> cadastrarVeiculo(Veiculo veiculo) async {

    if (veiculo.marca.isEmpty ||
        veiculo.modelo.isEmpty ||
        veiculo.placa.isEmpty) {
      throw Exception("Preencha todos os campos obrigatórios.");
    }

    return await _database.insertVeiculo(veiculo);
  }


  // Buscar todos os veículos cadastrados
  Future<List<Veiculo>> listarVeiculos() async {

    return await _database.getVeiculos();

  }


  // Buscar um veículo pelo ID
  Future<Veiculo?> buscarVeiculo(int id) async {

    return await _database.getVeiculoById(id);

  }


  // Atualizar veículo
  Future<int> atualizarVeiculo(Veiculo veiculo) async {

    return await _database.updateVeiculo(veiculo);

  }


  // Excluir veículo
  Future<int> excluirVeiculo(int id) async {

    return await _database.deleteVeiculo(id);

  }

}