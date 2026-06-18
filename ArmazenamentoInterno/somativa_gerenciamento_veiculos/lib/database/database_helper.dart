import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/veiculo.dart';
import '../models/manutencao.dart';



class DatabaseHelper {


  static final DatabaseHelper _instance =
      DatabaseHelper._internal();


  factory DatabaseHelper() {
    return _instance;
  }


  DatabaseHelper._internal();



  static Database? _database;



  Future<Database> get database async {


    if (_database != null) {

      return _database!;

    }


    _database = await _initDatabase();


    return _database!;

  }




  // Criar banco
  Future<Database> _initDatabase() async {


    String path = join(

      await getDatabasesPath(),

      'controle_veiculos.db',

    );



    return await openDatabase(

      path,

      version: 1,


      onCreate: _createDatabase,

    );

  }





  // Criar tabelas
  Future<void> _createDatabase(Database db, int version) async {



    await db.execute('''

      CREATE TABLE veiculos (

        id INTEGER PRIMARY KEY AUTOINCREMENT,

        marca TEXT NOT NULL,

        modelo TEXT NOT NULL,

        ano INTEGER NOT NULL,

        placa TEXT NOT NULL,

        quilometragemInicial REAL NOT NULL

      )

    ''');



    await db.execute('''

      CREATE TABLE manutencoes (

        id INTEGER PRIMARY KEY AUTOINCREMENT,

        veiculoId INTEGER NOT NULL,

        tipoServico TEXT NOT NULL,

        data TEXT NOT NULL,

        quilometragem REAL NOT NULL,

        custo REAL NOT NULL,

        observacoes TEXT,

        FOREIGN KEY (veiculoId)

        REFERENCES veiculos(id)

      )

    ''');


  }





  // ==========================
  // VEÍCULOS
  // ==========================



  Future<int> insertVeiculo(Veiculo veiculo) async {


    final db = await database;


    return await db.insert(

      'veiculos',

      veiculo.toMap(),

    );

  }





  Future<List<Veiculo>> getVeiculos() async {


    final db = await database;


    final result = await db.query(

      'veiculos',

      orderBy: 'marca ASC',

    );



    return result
        .map(
          (map) => Veiculo.fromMap(map),
        )
        .toList();

  }





  Future<Veiculo?> getVeiculoById(int id) async {


    final db = await database;



    final result = await db.query(

      'veiculos',

      where: 'id = ?',

      whereArgs: [id],

    );



    if(result.isNotEmpty){

      return Veiculo.fromMap(
        result.first,
      );

    }


    return null;

  }





  Future<int> updateVeiculo(Veiculo veiculo) async {


    final db = await database;



    return await db.update(

      'veiculos',

      veiculo.toMap(),


      where: 'id = ?',


      whereArgs: [veiculo.id],

    );

  }





  Future<int> deleteVeiculo(int id) async {


    final db = await database;



    return await db.delete(

      'veiculos',


      where: 'id = ?',


      whereArgs: [id],

    );

  }






  // ==========================
  // MANUTENÇÕES
  // ==========================




  Future<int> insertManutencao(
      Manutencao manutencao
      ) async {



    final db = await database;



    return await db.insert(

      'manutencoes',

      manutencao.toMap(),

    );


  }





  Future<List<Manutencao>> getManutencoesByVeiculo(
      int veiculoId
      ) async {



    final db = await database;



    final result = await db.query(

      'manutencoes',


      where: 'veiculoId = ?',


      whereArgs: [veiculoId],


      orderBy: 'data DESC',

    );



    return result

        .map(

          (map) => Manutencao.fromMap(map),

        )

        .toList();

  }





  Future<Manutencao?> getManutencaoById(int id) async {



    final db = await database;



    final result = await db.query(

      'manutencoes',

      where: 'id = ?',

      whereArgs: [id],

    );



    if(result.isNotEmpty){

      return Manutencao.fromMap(
        result.first,
      );

    }


    return null;

  }





  Future<int> updateManutencao(
      Manutencao manutencao
      ) async {



    final db = await database;



    return await db.update(

      'manutencoes',

      manutencao.toMap(),


      where: 'id = ?',


      whereArgs: [manutencao.id],

    );

  }





  Future<int> deleteManutencao(int id) async {



    final db = await database;



    return await db.delete(

      'manutencoes',


      where: 'id = ?',


      whereArgs: [id],

    );

  }


}