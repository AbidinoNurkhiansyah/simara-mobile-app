class Pemesanan {
  final int idPemesanan;
  final int idUser;
  final int idJadwal;

  Pemesanan({
    required this.idUser,
    required this.idJadwal,
    required this.idPemesanan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'id_jadwal': idJadwal,
      'id_pemesanan': idPemesanan,
    };
  }

  factory Pemesanan.fromJson(Map<String, dynamic> json) {
    return Pemesanan(
      idUser: int.parse(json['id_user'].toString()),
      idJadwal: int.parse(json['id_jadwal'].toString()),
      idPemesanan: int.parse(json['id_pemesanan'].toString()),
    );
  }
}
