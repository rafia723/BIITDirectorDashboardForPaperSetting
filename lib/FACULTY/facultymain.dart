import 'package:biit_directors_dashbooard/FACULTY/faculty.dart';
import 'package:biit_directors_dashbooard/FACULTY/manageclos.dart';
import 'package:flutter/material.dart';

class FacultyMain extends StatefulWidget {
    final String facultyUsername;

  const FacultyMain({Key? key, required this.facultyUsername}) : super(key: key);

  @override
  State<FacultyMain> createState() => _FacultyMainState();
}

class _FacultyMainState extends State<FacultyMain> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Ensure the body is behind the app bar
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors
            .transparent, // Set the app bar background color to transparent
        elevation: 10, // Add app bar shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // Back arrow icon
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Faculty.png', // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
                 const SizedBox(height: 100),
                 Text(
                  'Welcome, ${widget.facultyUsername}!',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Faculty(),
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
                            child: const Text('View Courses',
                                style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              minimumSize: const Size(160, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Manage CLOS',
                                style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ManageClos()),
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
                            child: const Text('Manage Topics',
                                style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
