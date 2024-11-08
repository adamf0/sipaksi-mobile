import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
            maxWidth: 80,
          ),
          padding: const EdgeInsets.only(right: 15),
          child: Image.asset('lib/assets/images/fast.png'),
        ),
        Expanded(
          child: Text(
            "Bagikan data penelitian anda sekarang untuk pemeriksanaan kualitas penelitian sebelum diterima LPPM. Ada 7 bagian harus dilengkapi secara lengkap, ada beberapa point yg opsional namun jika anda lengkapi menjadi nilai tambah dalam penilaian dalam menentukan penerimaan pendanaan.",
            style: TextStyle(
              height: 1.2,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
