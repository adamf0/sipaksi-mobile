class TypeSubmission {
  final String _judul;
  final String _img_assset;

  TypeSubmission({
    required String judul,
    required String img_asset,
  })  : _judul = judul,
        _img_assset = img_asset;

  // Getters
  String get judul => _judul;
  String get img_assset => _img_assset;

  // Setters
  // set tanggal(String value) {
  //   _tanggal = value;
  // }

  // set judulPenelitian(String value) {
  //   _judulPenelitian = value;
  // }
}
