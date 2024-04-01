import 'package:biit_directors_dashbooard/Director/DRT_SCREEN_2.dart';
import 'package:biit_directors_dashbooard/Director/DRT_SCREEN_3.dart';
import 'package:biit_directors_dashbooard/MainPage.dart';
import 'package:flutter/material.dart';

class Director extends StatefulWidget {
  const Director({super.key});

  @override
  State<Director> createState() => _DirectorState();
}

class _DirectorState extends State<Director> {
  @override
  Widget build(BuildContext context) {
     Color customColor = const Color.fromARGB(255, 78, 223, 180);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        elevation: 10,
          title: const Text('Director Dashboard',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MainPage()));
          },
        ),
      //  backgroundColor: Colors.black.withOpacity(0.9),),
        ),
        body: Stack(children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/director.png', // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 100),
                  const Text(
                    'Welcome, Dr. Jameel Sawar!', // Replace with the actual user's name
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  const SizedBox(height: 120),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                           Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DRTApprovedPapers(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Approved \n   Papers',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DRTUploadedPapers(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Uploaded \n   Papers',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}