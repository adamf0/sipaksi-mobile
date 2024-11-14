import 'package:sipaksi/Module/Abstraction/JsonSerializable.dart';

class Issue implements JsonSerializable {
  int id;
  String judul;
  String? spesifik;
  String tanggal_keterangan;

  Issue({
    required this.id,
    required this.judul,
    this.spesifik,
    required this.tanggal_keterangan,
  });

  static Issue fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      judul: json['title'],
      spesifik: json['url'],
      tanggal_keterangan: json['thumbnailUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'spesifik': spesifik,
      'tanggal_keterangan': tanggal_keterangan,
    };
  }
}
