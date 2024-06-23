import 'package:biit_directors_dashbooard/DATACELL/datacell.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class LoginDatacell extends StatefulWidget {
  const LoginDatacell({super.key});

  @override
  State<LoginDatacell> createState() => _LoginDatacellState();
}
TextEditingController username =TextEditingController();
TextEditingController password =TextEditingController();
class _LoginDatacellState extends State<LoginDatacell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png', // Replace with the path to your background image
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80, // Adjust the width of the circular logo
                  height: 80, // Adjust the height of the circular logo
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Adjust the border color
                      width: 1.0, // Adjust the border width
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.png'), // Replace with the path to your logo image
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(

                  controller: username,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Username',
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                     floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                      if (username.text == 'datacell@biit.com' &&
                          password.text == '12345678') {
                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const Datacell(),
                      ),
                    );
                      } else {
                        if (username.text == '' || password.text == '') {
                          showErrorDialog(
                              context, 'Please enter username or password');
                        } else {
                          showErrorDialog(
                              context, 'Invalid username or password');
                        }
                      }
                   
                  },
                  style:  ButtonStyle(backgroundColor:MaterialStatePropertyAll(customButtonColor)),
                  child: const Text('Login',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}