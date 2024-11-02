import 'package:flutter/material.dart';

class DialogFactory {
  //tambahkan startagy pattern untuk tampung
  final BuildContext context;
  final Widget content;

  DialogFactory({required this.content, required this.context});

  void showDialog(String type) {
    //, {VoidCallback? onConfirm}
    Widget title = const Text('Konfirmasi Hapus');
    Widget buildContent;

    if (type == "confirm_dialog") {
      buildContent = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content,
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[600],
                ),
                child: const Text(
                  'Ya',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text(
                  'Tidak',
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          )
        ],
      );
    } else {
      throw Exception("$type not implemented");
    }

    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: title,
              content: buildContent,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context, // Corrected context reference
      pageBuilder: (context, animation1, animation2) {
        return SizedBox.shrink();
      },
    );
  }
}
