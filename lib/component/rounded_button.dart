import 'package:flutter/material.dart';



class RoundedButton extends StatelessWidget {

  const RoundedButton({Key? key, required this.text, required this.onPressed, required this.color}) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}