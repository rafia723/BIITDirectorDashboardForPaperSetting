import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required String labelText,
  required IconData prefixIcon,
  required bool obscureText
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14),
          labelText: labelText,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(prefixIcon),
        ),
      ),
    ),
  );
}

Widget customElevatedButton({
  required VoidCallback onPressed,
  required String buttonText,
  //Color? customColor,
    Color customColor = const Color.fromARGB(255, 78, 223, 180)
}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(customColor),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
    onPressed: onPressed,
    child: Text(buttonText),
  );
}
