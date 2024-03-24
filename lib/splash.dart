import 'dart:async';
import 'package:biit_directors_dashbooard/MainPage.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5), 
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  const MainPage()),
        );
      },
    ); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(''),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            Center(child: Image.asset('assets/images/splash.png',height: 200,width: 200,)), 
            const SizedBox(height: 20),
            const Text('BIIT Director Dashboard for Paper Setting'),
          ],
        ),
      ),
    );
  }
}
