
import 'package:biit_directors_dashbooard/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
        theme: ThemeData(
        // Define your custom focus color here
        
        primaryColor: Colors.black, // Example: Blue color
        listTileTheme: const ListTileThemeData(
       //  tileColor: Colors.white,
          textColor: Colors.black,
          //dense: true
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Set your custom color here
          ),
          floatingLabelStyle: TextStyle(color: Colors.white)
        ),
      //  switchTheme: SwitchThemeData(
      //     overlayColor: MaterialStateProperty.all(Colors.grey),
      //     thumbColor: MaterialStateProperty.resolveWith((states) {
      //       if (states.contains(MaterialState.selected)) {
      //         return Colors.white; // Color when the switch is ON
      //       }
      //       return Colors.grey; // Color when the switch is OFF
      //     }),
      //     trackColor: Mat
      //erialStateProperty.resolveWith((states) {
      //       if (states.contains(MaterialState.selected)) {
      //         return Colors.green; // Color when the switch is ON
      //       }
      //       return Colors.grey; // Color when the switch is OFF
      //     }),
      //   ),
       switchTheme: SwitchThemeData(
          overlayColor: MaterialStateProperty.all(Colors.grey),
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white; // Color when the switch is ON
            }
            return null; // Default color when the switch is OFF
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.green; // Color when the switch is ON
            }
            return null; // Default color when the switch is OFF
          }),
        ),
          
        ),
      home:  const SplashScreen(),

      
    );
  }
}


