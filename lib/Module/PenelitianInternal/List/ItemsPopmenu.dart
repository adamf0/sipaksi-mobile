import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Status.dart';

class PopmenuItemsFactory {
  final List<PopupMenuItem<String>> list;

  PopmenuItemsFactory({required String type}) : list = _createMenuItems(type);

  static List<PopupMenuItem<String>> _createMenuItems(String type) {
    if (type == Status.draf.key ||
        type == Status.tolak.key ||
        type == Status.tolak_anggota.key) {
      return [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
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

  List<PopupMenuItem<String>> get getList => list;
}

//Status.menunggu_pilih_reviewer, Status.terima