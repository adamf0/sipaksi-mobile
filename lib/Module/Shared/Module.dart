enum Module {
  penelitian_internal('penelitian internal', "Hibah Penelitian Internal"),
  penelitian_nasional(
      'penelitian nasional', "Hibah Penelitian Kemendikbud Ristek"),
  pkm_internal('pkm internal', "PKM Internal"),
  pkm_nasional('pkm nasional', "PKM Kemendikbud ristek"),
  ppm('ppm', "Penelitian dan Pengabdian Masyarakat Lainnya / Internasional"),
  menunggu_anggota('menunggu_anggota', "Menunggu Verifikasi Anggota"),
  insentif('insentif', "Insentif"),
  notifikasi('notifikasi', "Notifikasi"),
  none('error', "error");

  final String key;
  final String value;

  const Module(this.key, this.value);

  static Module parse(String str) {
    return Module.values.firstWhere(
      (e) => e.key.toLowerCase() == str.toLowerCase(),
      orElse: () => Module.none,
    );
  }
}
