import '../models/manutencao.dart';
import '../database/database_helper.dart';

class ManutencaoController {

  final DatabaseHelper _database = DatabaseHelper();


  // Cadastrar uma nova manutenção
  Future<int> cadastrarManutencao(Manutencao manutencao) async {

    if (manutencao.tipoServico.isEmpty ||
        manutencao.data.isEmpty) {
      throw Exception("Preencha todos os campos obrigatórios.");
    }

    return await _database.insertManutencao(manutencao);
  }


  // Listar todas as manutenções de um veículo
  Future<List<Manutencao>> listarManutencoesPorVeiculo(
      int veiculoId) async {

    return await _database.getManutencoesByVeiculo(veiculoId);

  }


  // Buscar uma manutenção pelo ID
  Future<Manutencao?> buscarManutencao(int id) async {

    return await _database.getManutencaoById(id);

  }


  // Atualizar uma manutenção
  Future<int> atualizarManutencao(
      Manutencao manutencao) async {

    return await _database.updateManutencao(manutencao);

  }


  // Excluir uma manutenção
  Future<int> excluirManutencao(int id) async {

    return await _database.deleteManutencao(id);

  }

}