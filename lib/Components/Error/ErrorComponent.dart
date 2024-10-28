import 'package:flutter/material.dart';
import 'package:sipaksi/Module/ColorExtension.dart';

class ErrorComponent extends StatelessWidget {
  final double height;
  final String errorMessage;
  const ErrorComponent(
      {super.key, required this.height, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceDim,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: height * .3,
            child: Image.asset('lib/assets/images/error.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(
                Icons.run_circle,
                color: Theme.of(context).colorScheme.error,
                size: 80,
              ),
              const SizedBox(height: 5),
              Text(
                "Gagal Memuat",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Manrope',
                    color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Sepertinya ada yg salah dalam komunikasi ke server. refresh kembali untuk memuat kembali atau kirim error ini ke developer.",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Manrope',
                    color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Refresh',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        print(errorMessage);
                      },
                      child: const Text(
                        "Send Error",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
