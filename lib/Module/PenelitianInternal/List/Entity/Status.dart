import 'package:flutter/material.dart';

enum Status {
  tolak('tolak', "Tolak", Colors.red),
  tolak_pendanaan('tolak_pendanaan', "Tidak Di Danai", Colors.red),
  tolak_anggota('tolak_anggota', "Tolang Anggota", Colors.red),
  terima('terima', "Sudah Di Nilai", Colors.green),
  terima_pendanaan('terima_pendanaan', "Di Danai", Colors.green),
  menunggu_anggota(
      'menunggu_anggota', "Menunggu Verifikasi Anggota", Colors.orange),
  menunggu_review_fakultas(
      'menunggu_review_fakultas', "Menunggu Review Fakultas", Colors.orange),
  menunggu_review_lppm(
      'menunggu_review_lppm', "Menunggu Review LPPM", Colors.orange),
  menunggu_pilih_reviewer(
      'menunggu_pilih_reviewer', "Menunggu Pilih Reviewer", Colors.blue),
  menunggu_reviewer('menunggu_reviewer', "Menunggu Reviewer", Colors.purple),
  draf('draf', "Draf", Colors.grey);

  final String key;
  final String value;
  final Color color;

  const Status(this.key, this.value, this.color);

  static Status parse(String str) {
    return Status.values.firstWhere(
      (e) => e.key.toLowerCase() == str.toLowerCase(),
      orElse: () => Status.draf,
    );
  }
}
