import 'package:flutter/material.dart';
import '../registrasi/registrasi_page.dart';

class TombolRegistrasi extends StatelessWidget {
  const TombolRegistrasi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width - 2 * 24,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const RegisterPage()));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 89, 98),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text(
          "Registrasi",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
