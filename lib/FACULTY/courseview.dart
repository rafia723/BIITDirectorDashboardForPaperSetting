import 'package:flutter/material.dart';

import 'faculty.dart';

class CourseView extends StatefulWidget {
  final String courseName;
  final String ccode;
  const CourseView({Key? key, required this.courseName, required this.ccode})
      : super(key: key);

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Faculty(),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 30.0), // Adjust as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  widget.courseName,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Course Code: ${widget.ccode}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
           Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                             
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              minimumSize: const Size(250, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('View Topics',
                                style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () { 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              minimumSize: const Size(250, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('View CLOS',
                                style: TextStyle(color: Colors.black)),
                          ),
                            const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () { 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              minimumSize: const Size(250, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Paper Setting',
                                style: TextStyle(color: Colors.black)),
                          ),
                           const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () { 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              minimumSize: const Size(250, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Paper Status',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
