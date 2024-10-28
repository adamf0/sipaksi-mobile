class PengajuanModel {
  String _tanggal;
  String _judulPenelitian;
  String _tahun;
  String _jenis; // insentif/pkm, internal
  String? _skema;
  String _status;

  PengajuanModel({
    required String tanggal,
    required String judulPenelitian,
    required String tahun,
    required String jenis,
    String? skema,
    required String status,
  })  : _tanggal = tanggal,
        _judulPenelitian = judulPenelitian,
        _tahun = tahun,
        _jenis = jenis,
        _skema = skema,
        _status = status;

  // Getters
  String get tanggal => _tanggal;
  String get judulPenelitian => _judulPenelitian;
  String get tahun => _tahun;
  String get jenis => _jenis;
  String? get skema => _skema;
  String get status => _status;

  // Setters
  // set tanggal(String value) {
  //   _tanggal = value;
  // }

  // set judulPenelitian(String value) {
  //   _judulPenelitian = value;
  // }

  // set tahun(String value) {
  //   _tahun = value;
  // }

  // set jenis(String value) {
  //   _jenis = value;
  // }

  // set skema(String? value) {
  //   _skema = value;
  // }

  // set status(String value) {
  //   _status = value;
  // }

  // Factory constructor for JSON parsing
  factory PengajuanModel.fromJson(Map<String, dynamic> json) {
    return PengajuanModel(
      tanggal: json['tanggal'] as String,
      judulPenelitian: json['judul_penelitian'] as String,
      tahun: json['tahun'] as String,
      jenis: json['jenis'] as String,
      skema: json['skema'] as String?,
      status: json['status'] as String,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'tanggal': _tanggal,
      'judul_penelitian': _judulPenelitian,
      'tahun': _tahun,
      'jenis': _jenis,
      'skema': _skema,
      'status': _status,
    };
  }
}
