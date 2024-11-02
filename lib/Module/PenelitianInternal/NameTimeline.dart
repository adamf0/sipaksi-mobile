enum NameTimeline {
  step1("Identitas Usulan Penelitian"),
  step1_1("Judul & Tahun Usulan Penelitian"),
  step1_2(
    "Skema Penelitian",
    "Pada tahap ini, anda harus menyetor data kategori skema, txt, dan kategori TKT yang ingin dicapai.",
  ),

  step2("Pemilihan Program Penelitian"),
  step2_1(
    "Prioritas Riset",
    "Pada tahap ini, anda harus menyetor data prioritas riset, bidang fokus penelitian, tema, dan topik.",
  ),
  step2_2(
    "Rumpun Ilmu & Lama Kegiatan",
    "Pada tahap ini, anda harus menyetor data rumpun ilmu 1-3 dan lama kegiatan.",
  ),

  step3("Anggota Peneliti"),
  step3_1(
    "Anggota Peneliti (Dosen)",
    "Pada tahap ini, anda harus menyetor data daftar dosen Unpak yang berkontribusi dalam penelitian ini.",
  ),
  step3_2("Anggota Peneliti (Mahasiswa)"),
  step3_2_1("Data Mahasiswa"),
  step3_2_2("Data MBKM"),
  step3_3(
    "Anggota Peneliti (Non Dosen)",
    "Pada tahap ini, anda harus menyetor data daftar dosen di luar Unpak atau bukan dosen yang berkontribusi dalam penelitian ini.",
  ),

  step4("Substansi"),
  step4_1(
    "Unggah Proposal Penelitian",
    "Pada tahap ini, anda harus unggah berkas proposal penelitian sesuai template yang telah disediakan.",
  ),
  step4_2(
    "Luaran Capaian Wajib",
    "Pada tahap ini, anda harus menyetor data luaran capaian dan ini sifatnya wajib.",
  ),
  step4_3(
    "Luaran Capaian Tambahan",
    "Pada tahap ini, anda harus menyetor data luaran capaian tambahan dan ini sifatnya opsional. Anda melengkapi ini akan mendapatkan poin lebih selama review LPMP dan reviewer.",
  ),

  step5("Rencana Anggaran Biaya"),
  step5_1(
    "Data RAB",
    "Pada tahap ini, anda harus memberitahu kami RAB secara menyeluruh dan lengkap.",
  ),

  step6("Dokumen Pendukung"),
  step6_1(
    "Unggah Dokumen Pendukung",
    "Pada tahap ini, anda harus unggah berkas dokumen pendukung dan ini sifatnya opsional.",
  ),

  step7("Dokumen Kontrak"),
  step7_1(
    "Unggah Dokumen Kontrak",
    "Pada tahap ini, anda harus unggah berkas dokumen kontrak dan ini sifatnya wajib.",
  ),

  none("error");

  final String title;
  final String? description;

  const NameTimeline(this.title, [this.description]);

  static NameTimeline parse(String str) {
    return NameTimeline.values.firstWhere(
      (e) => e.title.toLowerCase() == str.toLowerCase(),
      orElse: () => NameTimeline.none,
    );
  }
}
