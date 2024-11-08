import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Status.dart';

class StatusWithHistory extends StatelessWidget {
  const StatusWithHistory({
    super.key,
    required this.status,
  });

  final Status status;

  dynamic getValue(BuildContext context, String type, Status status) {
    if ([
      Status.tolak,
      Status.tolak_pendanaan,
      Status.tolak_anggota,
      Status.terima,
      Status.terima_pendanaan,
    ].contains(status)) {
      return type == "icon"
          ? Icons.close_rounded
          : Theme.of(context).colorScheme.error;
    } else if ([
      Status.menunggu_anggota,
      Status.menunggu_review_fakultas,
      Status.menunggu_review_lppm,
      Status.menunggu_pilih_reviewer,
      Status.menunggu_reviewer,
      Status.draf,
    ].contains(status)) {
      return type == "icon"
          ? Icons.timelapse
          : Theme.of(context).colorScheme.tertiary;
    }

    return type == "icon"
        ? Icons.timelapse
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Row(
                children: [
                  Icon(
                    getValue(context, "icon", status),
                    color: getValue(context, "color", status),
                    size: 18,
                  ),
                  Flexible(
                    child: Text(
                      status.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: status.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  children: [
                    const TextSpan(
                      text: "01/12/2024 - ditolak reviewer",
                    ),
                    TextSpan(
                      text: " Detail",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Detail clicked");
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
