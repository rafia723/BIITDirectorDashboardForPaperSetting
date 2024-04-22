import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/HOD/hod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GridViewScreen extends StatefulWidget {
  const GridViewScreen({super.key});

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  List<dynamic> clist = [];
    String? selectedCourse; // Nullable initially
Future<void> loadCourse() async {
    try {
      Uri uri =
          Uri.parse('${APIHandler().apiUrl}Course/getCourseWithEnabledStatus');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist =jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load course');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading course'),
          );
        },
      );
    }
  }

 @override
  void initState() {
    super.initState();
    loadCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Grid View',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/HOD.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Course:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                       constraints: const BoxConstraints(maxWidth: 350),
                      decoration: BoxDecoration(
                        color: Colors.white, // Set background color to white
                        borderRadius: BorderRadius.circular(
                            5), // Optional: Add border radius
                      ),
                      child: DropdownButton<String>(
                        hint: const Text(' Select Course '),
                       isExpanded: true,
                        elevation: 9,
                        value: selectedCourse,
                        items: clist.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['c_code'],
                            onTap: () {
                              setState(() {
                                selectedCourse = e['c_title'];
                              });
                            },
                            child: Text(
                              e['c_title'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCourse = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  alignment:Alignment.topRight,
                  width: 250,
                  height: 40,
                  color: Colors.yellow,
                  child: const Center(child: Text('Assessments')),
                )
              ],
            )
            ),
        ],
        ),
    );
  }
}