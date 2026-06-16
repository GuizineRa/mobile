import 'package:sa_formativa_petshop_sqlite/service/database_helper.dart';

class PetController {
  // atributo para estabelecer conexão com o banco
  final _dbHelper = DatabaseHelper();

  // métododos dos controller
//   salvar pet
  Future<int> salvarPet(Pet pet) async => _dbHelper.insertPet(pet);

  //Listar Todos os pets
  Future<List<Pet>> listarTodos() async => _dbHelper.getPets();

  
}