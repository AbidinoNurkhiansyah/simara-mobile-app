class User {
  final int? idUser;
  final String? name;
  final String? email;
  final String? nohp;
  final String? domisili;

  User({this.idUser, this.name, this.email, this.nohp, this.domisili});

  factory User.fromJson(Map<String, dynamic> json) {
    print(
      '🔍 Raw id_user: ${json['id_user']} (${json['id_user'].runtimeType})',
    );
    return User(
      idUser:
          json['id_user'] != null
              ? int.parse(json['id_user'].toString())
              : null,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      nohp: json['nohp']?.toString(),
      domisili: json['domisili']?.toString(),
    );
  }
}
