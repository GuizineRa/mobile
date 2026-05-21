//modelagem de dados 

class Nota {
  //atributos
  final int? id; //permitir que a variavel seja nula
  // em um primeiro momento a váriavel é nula
  // somente quando cair no DB ira receber um valor para o ID
  final String titulo;
  final String conteudo;

  //construtor
  Nota({this.id, required this.titulo, required this.conteudo});

  // métodos de serialização de dados (toMap() fromMap())

  // toMap() => converter um OBJ da classe Nota para MAP de DB ( inserir dados no DB )
  Map<String,dynamic> toMap(){
    return{
      "id":id, //Mapeando as colunas do DB com os atributps da classe
      "titulo":titulo,
      "conteudo":conteudo
    };
  }
  // Conerter um MAP(Vindo do DB) => Obj de classe Nota
  //para fazer o from vamos usar um factory
  factory Nota.fromMap(Map<String,dynamic> map){
    return Nota(
      id: map["id"] as int, // se esta voltando do DB então já tem um ID
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String
    );
  }

  //Método para imprimir dados
  @override
  String toString(){
    return "Nota{id:$id, título: $titulo, conteúdo: $conteudo}";
  }
}