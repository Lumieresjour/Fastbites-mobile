import 'package:flutter/material.dart';

class TombolPesan extends StatelessWidget {
  final VoidCallback? onPressed;

  const TombolPesan({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: MediaQuery.of(context).size.width - 2 * 24,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Color.fromARGB(255, 255, 89, 98), width: 3),
                borderRadius: BorderRadius.circular(6))),
        child: const Text(
          "Pesan",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 89, 98)),
        ),
      ),
    );
  }
}
