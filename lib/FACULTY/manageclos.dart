import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageClos extends StatefulWidget {
   final String coursename;
final String ccode;
final int? cid;
 const ManageClos(
      {Key? key,
      required this.coursename,
      required this.ccode,
      required this.cid,})
      : super(key: key);

  @override
  State<ManageClos> createState() => _ManageClosState();
}

class _ManageClosState extends State<ManageClos> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  List<dynamic> clist = [];
  List<dynamic> clolist = [];
  int count = 1;
  String? selectedCourse; // Nullable initially
  int? selectedCourseId;
  String? selectedCourseCode;
  TextEditingController desc = TextEditingController();
  bool isUpdateMode = false;
  int? selectedCloID;

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

  @override
  void initState() {
    super.initState();
    loadCoursesWithSeniorRole();
    selectedCourseId=widget.cid;
    loadClo(widget.cid!);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'CLOs',
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
                          hint:  Text(widget.coursename ?? ' Select Course'),
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
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                      controller: desc,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: customElevatedButton(
                            onPressed: () async {
                              if (isUpdateMode == false) {
                                int code = await APIHandler().addClo(
                                    desc.text, selectedCourseId!, 'enabled');
                                if (code == 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog after 1 second
                                      });
                                      return const AlertDialog(
                                        title: Text('Inserted'),
                                      );
                                    },
                                  );
                                  desc.clear();
                                  setState(() {
                                    selectedCourse = null;
                                    loadClo(selectedCourseId!);
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        title: Text('Error....'),
                                      );
                                    },
                                  );
                                }
                              } else {
                                int cloid =
                                    selectedCloID!; // Use the faculty ID provided in the widget
                                String status = 'enabled';
                                Map<String, dynamic> cloData = {
                                  "clo_text": desc.text,
                                  "c_id": selectedCourseId,
                                  "status": status,
                                };
                                int code = await APIHandler()
                                    .updateClo(cloid, cloData);
                                if (code == 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog after 1 second
                                      });
                                      return const AlertDialog(
                                        title: Text('updated'),
                                      );
                                    },
                                  );
                                  desc.clear();
                                  setState(() {
                                    selectedCourse = null;
                                    loadClo(selectedCourseId!);
                                     isUpdateMode = false;
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        title: Text('Error....'),
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            buttonText: isUpdateMode ? 'Update' : 'Add'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: clolist.length,
                        itemBuilder: (context, index) {
                          return Card(
                             // elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            //  color: Colors.white.withOpacity(0.8),
                             color: Colors.transparent,
                              child: ListTile(
                                  title: Text('Clo ${count + index}', style: const TextStyle(color: Colors.white),),
                                  subtitle: Text(clolist[index]['clo_text'], style: const TextStyle(color: Colors.white),),
                                  trailing: IconButton(
                                      onPressed: () {
                                        // Find the index of the item with matching c_id
                                        int indexx = clist.indexWhere((e) =>
                                            e['c_id'] ==
                                            clolist[index]['c_id']);
                                        setState(() {
                                          selectedCloID =
                                              clolist[index]['clo_id'];
                                        });
                                        if (indexx != -1) {
                                          // If item with matching c_id is found
                                          setState(() {
                                            // Set selectedCourseId
                                            selectedCourseId =
                                                clist[indexx]['c_id'];
                                            // Set selectedCourse based on index
                                            selectedCourse =
                                                clist[indexx]['c_code'];
                                            // Toggle the update mode
                                            isUpdateMode = true;
                                          });
                                        }
                                        // Set CLO text to desc TextFormField
                                        desc.text = clolist[index]['clo_text'];
                                      },
                                      icon: const Icon(Icons.edit,color: Colors.white))));
                        }),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
