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
  bool isShowPassword = false;

  void togglePasswordVisibility() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth >= 540
              ? Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'lib/assets/images/ilustrasi1.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: SectionLogin(
                        isShowPassword: isShowPassword,
                        togglePasswordVisibility: togglePasswordVisibility,
                      ),
                    ),
                  ],
                )
              : SectionLogin(
                  isShowPassword: isShowPassword,
                  togglePasswordVisibility: togglePasswordVisibility,
                );
        },
      ),
    );
  }
}

class SectionLogin extends StatelessWidget {
  final bool isShowPassword;
  final VoidCallback togglePasswordVisibility;

  const SectionLogin({
    super.key,
    required this.isShowPassword,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30;
    const double margin = 12.0;

    TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.outline,
    );

    return Stack(
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
                    width: iconSize,
                    height: iconSize,
                    child: Image.asset('lib/assets/images/logo_unpak.png'),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "SIPAKSI",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Manrope',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),
              Text(
                "hai, masuk dulu sebelum melanjutkan",
                style: textStyle,
              ),
              const SizedBox(height: margin),
              _buildTextField(
                context,
                label: 'NIDN / Username',
                hint: 'Masukkan NIDN / Username',
                icon: Icons.person,
                obscureText: false,
              ),
              const SizedBox(height: margin),
              _buildTextField(
                context,
                label: 'Password',
                hint: 'Password',
                icon: Icons.lock,
                obscureText: !isShowPassword,
                suffixIcon: IconButton(
                  onPressed: togglePasswordVisibility,
                  icon: Icon(
                      isShowPassword ? Icons.visibility : Icons.visibility_off),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: margin),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Text('Masuk'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      onChanged: (value) => {},
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.outline),
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1),
        ),
      ),
    );
  }
}
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool isShowPassword = false;

//   void togglePasswordVisibility() {
//     setState(() {
//       isShowPassword = !isShowPassword;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth >= 540) {
//             // Tablet/Desktop layout
//             return Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: double.infinity,
//                     child: Image.asset(
//                       'lib/assets/images/ilustrasi1.png',
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SectionLogin(
//                     isShowPassword: isShowPassword,
//                     togglePasswordVisibility: togglePasswordVisibility,
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             // Mobile layout
//             return SectionLogin(
//               isShowPassword: isShowPassword,
//               togglePasswordVisibility: togglePasswordVisibility,
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class SectionLogin extends StatefulWidget {
//   final bool isShowPassword;
//   final VoidCallback togglePasswordVisibility;

//   const SectionLogin({
//     super.key,
//     required this.isShowPassword,
//     required this.togglePasswordVisibility,
//   });

//   @override
//   State<SectionLogin> createState() => _SectionLoginState();
// }

// class _SectionLoginState extends State<SectionLogin> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Container(
//         child: Stack(
//           children: [
//             Positioned(
//               top: -50,
//               left: -50,
//               child: SizedBox(
//                 width: 100,
//                 height: 100,
//                 child: CustomPaint(
//                   painter: ArcPainter(100, "left", "#e6d3ff".toColor()),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -50,
//               right: -50,
//               child: SizedBox(
//                 width: 100,
//                 height: 100,
//                 child: CustomPaint(
//                   painter: ArcPainter(100, "right", "#efe3ff".toColor()),
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 26.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 30,
//                         height: 30,
//                         child: Image.asset(
//                           'lib/assets/images/logo_unpak.png',
//                         ),
//                       ),
//                       const Text(
//                         "SIPAKSI",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w900,
//                           fontFamily: 'Manrope',
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   const Text(
//                     "Sistem Informasi Penelitian, Abdimas dan PubliKaSI",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w500,
//                       height: 1.3,
//                       fontFamily: 'Manrope',
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(
//                     height: 24,
//                   ),
//                   Text(
//                     "hai, masuk dulu sebelum melanjutkan",
//                     style: TextStyle(
//                       color: "#9799a2".toColor(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   TextField(
//                     // controller: widget.controller,
//                     keyboardType: TextInputType.text,
//                     obscureText: false,
//                     onChanged: (value) => {},
//                     textInputAction: TextInputAction.next,
//                     maxLines: 1,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "Masukkan NIDN / Username",
//                       labelText: 'NIDN / Username',
//                       hintStyle: TextStyle(
//                           color: Theme.of(context).colorScheme.outline),
//                       labelStyle:
//                           TextStyle(color: Theme.of(context).primaryColor),
//                       prefixIcon: Icon(
//                         Icons.person,
//                         color: Theme.of(context).colorScheme.outline,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.outline,
//                             width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).primaryColor, width: 2),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.outline,
//                             width: 1),
//                       ),
//                       // errorBorder: OutlineInputBorder(
//                       //   borderRadius: BorderRadius.circular(8),
//                       //   borderSide:
//                       //       const BorderSide(color: Colors.red, width: 1),
//                       // ),
//                       // focusedErrorBorder: OutlineInputBorder(
//                       //   borderRadius: BorderRadius.circular(8),
//                       //   borderSide:
//                       //       const BorderSide(color: Colors.red, width: 2),
//                       // ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   TextField(
//                     // controller: widget.controller,
//                     keyboardType: TextInputType.text,
//                     obscureText: !widget.isShowPassword, // Negate the value
//                     onChanged: (value) => {},
//                     textInputAction: TextInputAction.next,
//                     maxLines: 1,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       labelText: 'Password',
//                       hintStyle: TextStyle(
//                           color: Theme.of(context).colorScheme.outline),
//                       labelStyle:
//                           TextStyle(color: Theme.of(context).primaryColor),
//                       prefixIcon: Icon(
//                         Icons.lock,
//                         color: Theme.of(context).colorScheme.outline,
//                       ),
//                       suffixIcon: IconButton(
//                         onPressed: widget.togglePasswordVisibility,
//                         icon: Icon(widget.isShowPassword
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                           color: Theme.of(context).colorScheme.outline,
//                           width: 1,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                           color: Theme.of(context).primaryColor,
//                           width: 2,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                           color: Theme.of(context).colorScheme.outline,
//                           width: 1,
//                         ),
//                       ),
//                       // errorBorder: OutlineInputBorder(
//                       //   borderRadius: BorderRadius.circular(8),
//                       //   borderSide:
//                       //       const BorderSide(color: Colors.red, width: 1),
//                       // ),
//                       // focusedErrorBorder: OutlineInputBorder(
//                       //   borderRadius: BorderRadius.circular(8),
//                       //   borderSide:
//                       //       const BorderSide(color: Colors.red, width: 2),
//                       // ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const DashboardPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: Theme.of(context).primaryColor,
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 24.0, vertical: 12.0),
//                         child: Text('Masuk'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
