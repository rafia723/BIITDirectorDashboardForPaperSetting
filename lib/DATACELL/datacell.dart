import 'package:biit_directors_dashbooard/DATACELL/approved.dart';
import 'package:biit_directors_dashbooard/DATACELL/courseList.dart';
import 'package:biit_directors_dashbooard/DATACELL/facultyList.dart';
import 'package:biit_directors_dashbooard/DATACELL/printed.dart';
import 'package:flutter/material.dart';

class Datacell extends StatefulWidget {
  const Datacell({super.key});

  @override
  State<Datacell> createState() => _DatacellState();
}

class _DatacellState extends State<Datacell> {
  @override
  Widget build(BuildContext context) {
    Color customColor = const Color.fromARGB(255, 78, 223, 180);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),),
        body: Stack(children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/datacell.png', // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome, Data Cell!', // Replace with the actual user's name
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  const SizedBox(height: 120),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FacultyDetails(),
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
                          child: const Text('Manage \nFaculty',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CourseDetail(),
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
                          child: const Text('Manage \nCourses',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Approved(),
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
                          child: const Text('Approved Papers',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Printed(),
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
                          child: const Text('Printed Papers',
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
