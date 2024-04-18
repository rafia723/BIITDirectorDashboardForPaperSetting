import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageTopics extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int? cid;
  const ManageTopics({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
  }) : super(key: key);

  @override
  State<ManageTopics> createState() => _ManageTopicsState();
}

class _ManageTopicsState extends State<ManageTopics> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  List<dynamic> clist = [];
  List<dynamic> clolist = [];
  List<dynamic> topiclist = [];
  String? selectedCourse; // Nullable initially
  int? selectedCourseId;
  String? selectedCourseCode;
  TextEditingController topicController = TextEditingController();
  bool isUpdateMode = false;
  List<bool> cloCheckBoxes = [];

  Future<void> loadCoursesWithSeniorRole() async {
    try {
      Uri uri =
          Uri.parse('${APIHandler().apiUrl}Course/getCoursesofSeniorTeacher');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load courses with senior role');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading courses with senior role'),
          );
        },
      );
    }
  }

  Future<void> loadClo(int cid) async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Clo/getClo/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clolist = jsonDecode(response.body);
        // Initialize cloCheckBoxes with false values
        cloCheckBoxes = List<bool>.filled(clolist.length, false);
        setState(() {});
      } else {
        throw Exception('Failed to load clos');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading clos'),
          );
        },
      );
    }
  }

    Future<void> loadTopic(int cid) async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Topic/getTopic/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        topiclist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load topics');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading topics'),
          );
        },
      );
    }
  }


  @override
  void initState() {
    super.initState();
    loadCoursesWithSeniorRole();
    selectedCourseId = widget.cid;
    loadClo(widget.cid!);
    loadTopic(widget.cid!);
  }

  Future<void> addTopicAndMapping() async {
    try {
      // Collect selected CLOs
      List<dynamic> selectedCloIds = [];
      for (int i = 0; i < clolist.length; i++) {
        if (cloCheckBoxes[i]) {
          selectedCloIds.add(clolist[i]['clo_id']);
        }
      }
      // Validate if at least one CLO is selected
      if (selectedCloIds.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Error'),
              content: Text('Please select at least one CLO.'),
            );
          },
        );
        return;
      }
      // Get the topic text from the text field
      String topicText = topicController.text.trim();

      // Validate if topic text is not empty
      if (topicText.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Error'),
              content: Text('Please enter a topic.'),
            );
          },
        );
        return;
      }
      int topicId = await APIHandler().addTopic(topicText, selectedCourseId!);
      int code = await APIHandler()
          .addMappingsofCloAndTopic(topicId, selectedCloIds);
      if (code == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Success'),
              content: Text('Topic and clo mapping added successfully.'),
            );
          },
        );
           // Clear the text field
    topicController.clear();

    // Clear the checkbox selections
    setState(() {
      cloCheckBoxes = List<bool>.filled(clolist.length, false);
      loadTopic(selectedCourseId!);
    });
      }else{
        // Mapping failed, revert addition of topic
        await APIHandler().deleteTopic(topicId);
         showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add topic mappings. Please try again later.'),
          );
        }
         );
      }
        } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add topic. Please try again later.'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Topics',
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
              'assets/images/Faculty.png',
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
                    'Course',
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
                          hint: Text(widget.coursename ?? ' Select Course'),
                          isExpanded: true,
                          elevation: 9,
                          value: selectedCourseCode,
                          items: clist.map((e) {
                            return DropdownMenuItem<String>(
                              value: e['c_code'],
                              onTap: () {
                                setState(() {
                                  //  selectedCourse = e['c_title'];
                                  selectedCourseId = e['c_id'];
                                });
                                loadClo(selectedCourseId!);
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
                              selectedCourseCode = newValue!;
                              loadClo(selectedCourseId!);
                               loadTopic(selectedCourseId!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Topic',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      controller: topicController,
                      maxLines: 1,
                    ),
                  ),
                  const Text(
                    'CLOs',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  // Display CLOs with checkboxes in a row
                  SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: (clolist.length / 2)
                          .ceil(), // Calculate the number of rows needed
                      itemBuilder: (context, rowIndex) {
                        final start = rowIndex * 2;
                        final end = (rowIndex * 2) + 2;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: clolist
                              .sublist(start,
                                  end < clolist.length ? end : clolist.length)
                              .map((clo) {
                            final cloIndex = clolist.indexOf(clo);
                            return Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Pop up the text of the corresponding CLO
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('CLO ${cloIndex + 1}'),
                                          content: Text(clo['clo_text']),
                                          actions: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.check))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'CLO ${cloIndex + 1}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: cloCheckBoxes[cloIndex],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      cloCheckBoxes[cloIndex] = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  Center(
                      child: customElevatedButton(
                          onPressed: addTopicAndMapping,
                          buttonText: 'Add Topic')),
                             Expanded(
                    child: ListView.builder(
                        itemCount: topiclist.length,
                        itemBuilder: (context, index) {
                          return Card(
                             // elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white.withOpacity(0.8),
                            // color: Colors.transparent,
                              child: ListTile(
                                  title: Text(topiclist[index]['t_name'],),
                                  trailing: Row(
                                     mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            // Find the index of the item with matching c_id
                                          },
                                          icon: const Icon(Icons.edit,)),
                                            IconButton(
                                          onPressed: () {
                                            // Find the index of the item with matching c_id
                                          },
                                          icon: const Icon(Icons.plus_one)),
                                    ],
                                  )));
                        }),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}