import 'package:biit_directors_dashbooard/FACULTY/courseview.dart';
import 'package:biit_directors_dashbooard/FACULTY/notification.dart';
import 'package:flutter/material.dart';

class Faculty extends StatefulWidget {
  const Faculty({super.key});

  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Faculty Dashboard',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Add your notification icon or message box widget here
          IconButton(
            icon: const Icon(
                Icons.message,color: Colors.white,), // Replace with your icon or message box widget
            onPressed: () {
              // Handle the notification icon or message box click event
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
                Icons.timer,color: Colors.white,), // Replace with your icon or message box widget
            onPressed: () {
              // Handle the notification icon or message box click event
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const Notifications(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Faculty.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 100),
                const Text(
                  'Welcome Mr. Shahid!',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Container(height: 130),
                Column(
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const CourseView(
                                                courseName:
                                                    'Programming Fundamentals',
                                                ccode: 'CS-354'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: customColor,
                                        minimumSize: const Size(150, 80),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Text(
                                          'Programming \nFundamentals',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    const Text('CS-354',style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                                const SizedBox(width: 20),
                                 Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const CourseView(
                                                courseName:
                                                    'Ecommerce',
                                                ccode: 'CS-454'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: customColor,
                                        minimumSize: const Size(150, 80),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Text(
                                          'Ecommerce',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    const Text('CS-454',style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 20), // Adjust the spacing between rows
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const CourseView(
                                                courseName:
                                                    'Linear Algebra',
                                                ccode: 'CS-374'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: customColor,
                                        minimumSize: const Size(150, 80),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Text(
                                          'Linear Algebra',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    const Text('CS-374',style: TextStyle(color: Colors.white))
                                  ],
                                ),
                                const SizedBox(width: 20),
                                    Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const CourseView(
                                                courseName:
                                                    'Database',
                                                ccode: 'CS-324'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: customColor,
                                        minimumSize: const Size(150, 80),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                      ),
                                      child: const Text(
                                          'Database',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    const Text('CS-324',style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
