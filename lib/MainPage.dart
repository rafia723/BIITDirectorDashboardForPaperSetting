import 'package:biit_directors_dashbooard/DATACELL/datacell.dart';
import 'package:biit_directors_dashbooard/DATACELL/loginDatacell.dart';
import 'package:biit_directors_dashbooard/Director/LoginDirector.dart';
import 'package:biit_directors_dashbooard/Director/director.dart';
import 'package:biit_directors_dashbooard/FACULTY/faculty.dart';
import 'package:biit_directors_dashbooard/FACULTY/loginFaculty.dart';
import 'package:biit_directors_dashbooard/HOD/LoginHod.dart';
import 'package:biit_directors_dashbooard/HOD/hod.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
  children: [
    Expanded(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/MainApp.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       const SizedBox(height: 40,),
                        const Text("What's Your Role?",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 70,),
                     ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(150.0, 50.0)),),
                        onPressed: () { Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginDatacell()));},
                        child: const Text('Datacell',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(150.0, 50.0)),),
                        onPressed: () {
                           Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginHod()));
                        },
                        child: const Text('HOD',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
                        const SizedBox(height: 20,),
                       ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(150.0, 50.0)),),
                        onPressed: () {
                            Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginFaculty()));
                        },
                        child: const Text('Faculty',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
                        const SizedBox(height: 20,),
                      ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(150.0, 50.0)),),
                        onPressed: () {
                          Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginDirector()));
                        },
                        child: const Text('Director',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
                        const SizedBox(height: 120,),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Welcome to the Director Dashboard! The Director Dashboard is a powerful tool that provides you with valuable insights and control over your organization's operations. With this dashboard, you can easily monitor key performance indicators, track project progress, and make informed decisions to drive your team's success.",
                        style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                        )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      ],
      ),

    );
  }
}