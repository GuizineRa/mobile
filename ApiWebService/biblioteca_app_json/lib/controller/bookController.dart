class BookController 

aimport 'package:biblioteca_app_json/Model/book_model.dart';
import 'package:biblioteca_app_json/service/api_service.dart';

class BookController {
  // Métodos
  // Ler
  Future<List<BookModel>> fetchAll() async {
    final list = await ApiService.getList("book");
    return list.map<BookModel>((item) => BookModel.fromMap(item)).toList();
  }

  //Ler um unico Livro
  Future<BookModel> fetchOne(String id) async {
    final book = await ApiService.getOne("book", id);
    return BookModel.fromMap(book);
  }

  // Criar
  Future<BookModel> create(BookModel b) async {
    final created = await ApiService.post("book", b.toMap());
    return BookModel.fromMap(created);
  }

  // Atualizar
  Future<BookModel> update(BookModel b) async {
    final updated = await ApiService.put("book", b.toMap(), b.id!);
    return BookModel.fromMap(updated);
  }

  Future<void> delete(String id) async {
    await ApiService.delete("book", id);
  }
}
