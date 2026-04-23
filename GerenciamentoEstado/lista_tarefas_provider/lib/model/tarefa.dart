// Modelagem de Dados

class Tarefa {
  // Atributos
  String titulo;  //Armaxena o título da tarefa
  bool concluida;
  //Classe que armaezena informações sobre a data de criação da tarefa
  DateTime dataCriacao;

  //Construtor padrão
  // Tarefa(String titulo) {
   // this.titulo = titulo;
    //this.concluida = false;
    // this.dataCriacao = DateTime.now();
  //}


//Cnstrutor resumido
Tarefa({
  required this.titulo,
  this.concluida = false,
  DateTime? dataCriacao,}) : dataCriacao = dataCriacao ?? DateTime.now();
  //Se dataCriacao for Nulo, atrubui uma da DateTime.now() -> pega a data atual

// classe de modelagem de dados, toda tarefa criada é um obj da classe tarefa
// Toda tarefa tem um titulo, um status de conclusão e uma data de criação
}