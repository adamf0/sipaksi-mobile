import 'package:flutter/material.dart';
import 'package:sipaksi/Components/Notification/SmallCircleNotification.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Status.dart';
import 'package:sipaksi/Components/Popmenu/PopupMenuStrategy.dart';

class DefaultMenuStrategy implements PopupMenuStrategy {
  final String type;

  DefaultMenuStrategy({required this.type});

  @override
  List<PopupMenuItem<String>> getList() {
    if (type == Status.draf.key ||
        type == Status.tolak.key ||
        type == Status.tolak_anggota.key) {
      return [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
        PopupMenuItem(
          value: 'notifikasi',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notifikasi'),
              SmallCircleNotification(),
            ],
          ),
        ),
      ];
    } else if (type == Status.menunggu_anggota.key) {
      return [
        const PopupMenuItem(value: 'approve_member', child: Text('Approve')),
        const PopupMenuItem(value: 'reject_member', child: Text('Reject')),
        const PopupMenuItem(value: 'proposal', child: Text('Detail Proposal')),
      ];
    } else if (type == Status.menunggu_review_fakultas.key ||
        type == Status.menunggu_review_lppm.key) {
      return [
        const PopupMenuItem(
            value: 'show_administration', child: Text('Show Administration')),
      ];
    } else if (type == Status.menunggu_reviewer.key) {
      return [
        const PopupMenuItem(
            value: 'show_substance', child: Text('Show Substance')),
      ];
    } else if (type == Status.terima.key ||
        type == Status.terima_pendanaan.key) {
      return [
        const PopupMenuItem(value: 'add_logbook', child: Text('Add Logbook')),
        const PopupMenuItem(
            value: 'add_progress_report', child: Text('Add Progress Report')),
        const PopupMenuItem(
            value: 'add_final_report', child: Text('Add Final Report')),
      ];
    } else {
      // Default case
      return [];
    }
  }
}
