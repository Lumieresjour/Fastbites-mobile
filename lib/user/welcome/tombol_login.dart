import 'package:flutter/material.dart';
import '../login/login_page.dart';

class TombolLogin extends StatelessWidget {
  const TombolLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width - 2 * 24,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Color.fromARGB(255, 255, 89, 98), width: 3),
                borderRadius: BorderRadius.circular(15))),
        child: const Text(
          "Login",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 89, 98)),
        ),
      ),
    );
  }
}
