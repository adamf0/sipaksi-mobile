import 'package:flutter/material.dart';
import 'package:sipaksi/Module/ColorExtension.dart';
import 'package:sipaksi/Module/Dashboard/DashboardPage.dart';
import 'package:sipaksi/Components/ArchCircle/ArcPainter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isShowPassword = false; // Move this outside the build method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: Container(
          child: Container(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: ArcPainter(100, "left", "#e6d3ff".toColor()),
                ),
              ),
            ),
            Positioned(
              top: -50,
              right: -50,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: ArcPainter(100, "right", "#efe3ff".toColor()),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'lib/assets/images/logo_unpak.png',
                        ),
                      ),
                      const Text(
                        "SIPAKSI",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Manrope',
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Sistem Informasi Penelitian, Abdimas dan PubliKaSI",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      fontFamily: 'Manrope',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "hai, masuk dulu sebelum melanjutkan",
                    style: TextStyle(
                      color: "#9799a2".toColor(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    // controller: widget.controller,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (value) => {},
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Masukkan NIDN / Username",
                      labelText: 'NIDN / Username',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1),
                      ),
                      // errorBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8),
                      //   borderSide:
                      //       const BorderSide(color: Colors.red, width: 1),
                      // ),
                      // focusedErrorBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8),
                      //   borderSide:
                      //       const BorderSide(color: Colors.red, width: 2),
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    // controller: widget.controller,
                    keyboardType: TextInputType.text,
                    obscureText: !isShowPassword, // Negate the value
                    onChanged: (value) => {},
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Password",
                      labelText: 'Password',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
                        icon: Icon(isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Theme.of(context).primaryColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1),
                      ),
                      // errorBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8),
                      //   borderSide:
                      //       const BorderSide(color: Colors.red, width: 1),
                      // ),
                      // focusedErrorBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8),
                      //   borderSide:
                      //       const BorderSide(color: Colors.red, width: 2),
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: Text('Masuk'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
