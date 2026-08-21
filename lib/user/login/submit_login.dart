import 'package:flutter/material.dart';
import '../main_page.dart';

class SubmitLogin extends StatelessWidget {
  const SubmitLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width - 2 * 24,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 89, 98),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text(
          "Login",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
