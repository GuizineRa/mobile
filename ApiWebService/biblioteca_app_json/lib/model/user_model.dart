class User Model {
    //atributos
    final String? id;
    final String? name;
    final String? email;

    //construtor
    UserModel({this.id, required this.name, this.email});

    // mérodos
    // toMap => OBJ => MAP
    Map<String, dynamic> toMap() => {"id": id, "name": name, "email": email};

    //fromMap => MAP => OBJ
    factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map["id"],
        name: map["name"],
        email: map["email"],
    );
}