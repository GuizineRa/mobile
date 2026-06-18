class Manutencao {
  int? id;
  int veiculoId;
  String tipoServico;
  String data;
  double quilometragem;
  double custo;
  String observacoes;

  Manutencao({
    this.id,
    required this.veiculoId,
    required this.tipoServico,
    required this.data,
    required this.quilometragem,
    required this.custo,
    required this.observacoes,
  });


  // Converter objeto Manutencao para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'veiculoId': veiculoId,
      'tipoServico': tipoServico,
      'data': data,
      'quilometragem': quilometragem,
      'custo': custo,
      'observacoes': observacoes,
    };
  }


  // Converter dados do SQLite para objeto Manutencao
  factory Manutencao.fromMap(Map<String, dynamic> map) {
    return Manutencao(
      id: map['id'],
      veiculoId: map['veiculoId'],
      tipoServico: map['tipoServico'],
      data: map['data'],
      quilometragem: map['quilometragem'],
      custo: map['custo'],
      observacoes: map['observacoes'],
    );
  }


  @override
  String toString() {
    return '$tipoServico - $data - R\$ $custo';
  }
}