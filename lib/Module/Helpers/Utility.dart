import 'dart:convert';
import 'dart:math' as math;
import 'package:sipaksi/Module/Abstraction/JsonSerializable.dart';

String listToJson<T extends JsonSerializable>(List<T?> items) {
  final jsonList = items.whereType<T>().map((item) => item.toJson()).toList();
  return json.encode(jsonList);
}

double clampValue(double min, double middle, double max) {
  return math.min(max, math.max(min, middle));
}

/* 
double dpr = MediaQuery.of(context).devicePixelRatio;

    // Fungsi untuk mendapatkan font size berdasarkan DPR
    double getResponsiveFontSize() {
      if (dpr > 3.0) {
        // Layar sangat padat (misalnya, DPR tinggi pada ponsel flagship)
        return math.min(28, math.max(20, dpr * 7));
      } else if (dpr > 2.0) {
        // Layar padat (misalnya, tablet atau ponsel menengah)
        return math.min(24, math.max(16, dpr * 6));
      } else {
        // Layar rendah kepadatan (misalnya, layar standar atau ponsel murah)
        return math.min(18, math.max(12, dpr * 5));
      }
    }

    // Fungsi untuk mendapatkan padding berdasarkan DPR
    EdgeInsets getResponsivePadding() {
      if (dpr > 3.0) {
        return EdgeInsets.symmetric(horizontal: 40, vertical: 20);
      } else if (dpr > 2.0) {
        return EdgeInsets.symmetric(horizontal: 30, vertical: 15);
      } else {
        return EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      }
    }

    // Fungsi untuk mendapatkan margin berdasarkan DPR
    double getResponsiveMargin() {
      if (dpr > 3.0) {
        return 50;
      } else if (dpr > 2.0) {
        return 30;
      } else {
        return 15;
      }
    }
*/