import 'package:flutter/material.dart';
import 'package:sewa_mobil_1/user/welcome/welcome_page.dart';

class SubmitRegistrasi extends StatelessWidget {
  const SubmitRegistrasi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width - 2 * 24,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomePage()),
              (route) => false);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 89, 98),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text(
          "Daftar",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
