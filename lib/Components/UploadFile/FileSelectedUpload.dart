import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileSelectedUpload extends StatelessWidget {
  final PlatformFile file;
  final double progress;
  final bool isUploading;
  final VoidCallback onDelete;

  const FileSelectedUpload({
    super.key,
    required this.file,
    required this.progress,
    required this.isUploading,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      file.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    IconButton(
                      iconSize: 14,
                      onPressed: onDelete,
                      icon: Icon(Icons.close,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                isUploading
                    ? Column(
                        children: [
                          LinearProgressIndicator(value: progress),
                          Text(
                              'Mengunggah: ${(progress * 100).toStringAsFixed(0)}%'),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
