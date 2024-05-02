
import 'package:flutter/material.dart';

 Color customButtonColor = const Color.fromARGB(255, 78, 223, 180);
  
    Color customAppBarColor =const Color.fromRGBO(0, 233, 206, 1);
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
          hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87, 
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(prefixIcon, color: Colors.black),
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


void showConfirmationDialog(BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onConfirm(); // Call onConfirm function
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Yes'),
          ),
            TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

Widget customButton(  //for topics
      {required VoidCallback onPressed,
      required String buttonText,
      required bool isPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: isPressed ? customButtonColor : Colors.white.withOpacity(0.8),
      ),
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }


Widget customTextFieldWithoutLabelAndHint({
  required TextEditingController controller,
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
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: Icon(prefixIcon, color: Colors.black),
        ),
      ),
    ),
  );
}

PreferredSizeWidget customAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: customAppBarColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    elevation: 0, // No shadow
    title: Text(
      title,
      style: const TextStyle(fontSize: 21,fontWeight: FontWeight.bold),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back), // Adjust icon color as needed
      onPressed: (){
        Navigator.pop(context);
      },
    ),
  );
}