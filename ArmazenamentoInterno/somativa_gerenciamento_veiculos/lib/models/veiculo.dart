class Veiculo {
  int? id;
  String marca;
  String modelo;
  int ano;
  String placa;
  double quilometragemInicial;

  Veiculo({
    this.id,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.quilometragemInicial,
  });

  // Converter objeto para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
      'quilometragemInicial': quilometragemInicial,
    };
  }

  // Converter dados do SQLite para objeto Veiculo
  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      id: map['id'],
      marca: map['marca'],
      modelo: map['modelo'],
      ano: map['ano'],
      placa: map['placa'],
      quilometragemInicial: map['quilometragemInicial'],
    );
  }

  @override
  String toString() {
    return '$marca $modelo - $ano - $placa';
  }
}