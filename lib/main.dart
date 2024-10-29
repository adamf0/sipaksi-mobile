import 'package:flutter/material.dart';
import 'package:sipaksi/Module/ColorExtension.dart';
import 'package:sipaksi/Module/Login/LoginPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiMahasiswaPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiDosenPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/InternalResearchFormPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sipaksi',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: "#5120a1".toColor(),
          primary: "#5120a1".toColor(),
          primaryContainer: "#764bc7".toColor(),
          secondary: "#675687".toColor(),
          secondaryContainer: "#dfccff".toColor(),
          tertiary: "#7a0d62".toColor(),
          tertiaryContainer: "#a73989".toColor(),
          error: "#ba1a1a".toColor(),
          errorContainer: "#ffdad6".toColor(),
          surfaceDim: "#dfd7e3".toColor(),
          surface: "#fef7ff".toColor(),
          surfaceBright: "#fef7ff".toColor(),
          surfaceContainerLowest: "#ffffff".toColor(),
          surfaceContainerLow: "#f9f1fc".toColor(),
          surfaceContainer: "#f3ebf7".toColor(),
          surfaceContainerHigh: "#ede6f1".toColor(),
          surfaceContainerHighest: "#e7e0eb".toColor(),
          inverseSurface: "#322f37".toColor(),
          inversePrimary: "#d3bbff".toColor(),
          onInverseSurface: "#f6eef9".toColor(),
          onSurface: "#1d1a22".toColor(),
          onSurfaceVariant: "#4a4453".toColor(),
          outline: "#7b7484".toColor(),
          outlineVariant: "#ccc3d5".toColor(),
          scrim: "#000000".toColor(),
          shadow: "#000000".toColor(),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: "#d3bbff".toColor(),
          primary: "#d3bbff".toColor(),
          primaryContainer: "#5e30ae".toColor(),
          secondary: "#d1bdf5".toColor(),
          secondaryContainer: "#443463".toColor(),
          tertiary: "#ffade0".toColor(),
          tertiaryContainer: "#8a1f70".toColor(),
          error: "#ffb4ab".toColor(),
          errorContainer: "#93000a".toColor(),
          surfaceDim: "#15121a".toColor(),
          surface: "#15121a".toColor(),
          surfaceBright: "#3b3840".toColor(),
          surfaceContainerLowest: "#100d14".toColor(),
          surfaceContainerLow: "#1d1a22".toColor(),
          surfaceContainer: "#211e26".toColor(),
          surfaceContainerHigh: "#2c2931".toColor(),
          surfaceContainerHighest: "#37333c".toColor(),
          inverseSurface: "#e7e0eb".toColor(),
          inversePrimary: "#6f43c0".toColor(),
          onInverseSurface: "#322f37".toColor(),
          onSurface: "#1d1a22".toColor(),
          onSurfaceVariant: "#4a4453".toColor(),
          outline: "#7b7484".toColor(),
          outlineVariant: "#ccc3d5".toColor(),
          scrim: "#000000".toColor(),
          shadow: "#000000".toColor(),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const InternalResearchFormPage(),
    );
  }
}
