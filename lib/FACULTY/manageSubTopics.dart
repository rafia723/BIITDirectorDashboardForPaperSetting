import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageSubTopics extends StatefulWidget {
  final String coursename;
  final int cid;
  final int tid;
  final String topicName;
  const ManageSubTopics({
    Key? key,
    required this.coursename,
    required this.cid,
    required this.tid,
    required this.topicName,
  }) : super(key: key);

  @override
  State<ManageSubTopics> createState() => _ManageSubTopicsState();
}

class _ManageSubTopicsState extends State<ManageSubTopics> {
  List<dynamic> topiclist = [];
  List<dynamic> subtopiclist = [];
  int? selectedtopicId;
  String? selectedtopicDD;
  TextEditingController subTopicController = TextEditingController();
  bool isUpdateMode = false;
  int? selectedSubTopicID; //in update mode

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

  Future<void> loadSubTopic(int tid) async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}SubTopic/getSubTopic/$tid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        subtopiclist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load sub-topics');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading sub-topics'),
          );
        },
      );
    }
  }

  Future<void> addSubTopic() async {
    try {
      // Get the topic text from the text field
      String subTopicText = subTopicController.text.trim();

      // Validate if topic text is not empty
      if (subTopicText.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Error'),
              content: Text('Please enter a  sub-topic.'),
            );
          },
        );
        return;
      }
      int code = await APIHandler().addSubTopic(subTopicText, selectedtopicId!);
      if (code == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Success'),
              content: Text('Sub-Topic added successfully.'),
            );
          },
        );
        // Clear the text field
        subTopicController.clear();
          setState(() {
         
          loadSubTopic(selectedtopicId!);
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Error'),
                content:
                    Text('Failed to add Sub-Topic. Please try again later.'),
              );
            });
      }
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add Sub-topic.'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    selectedtopicId = widget.tid;
    loadTopic(widget.cid);
    loadSubTopic(widget.tid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Sub-Topics',
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
                  Text(
                    '    ${widget.coursename}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Topic',
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
                          hint: Text(widget.topicName),
                          isExpanded: true,
                          elevation: 9,
                          value: selectedtopicDD,
                          items: topiclist.map((e) {
                            return DropdownMenuItem<String>(
                              value: e['t_id'].toString(),
                              onTap: () {
                                setState(() {
                                  selectedtopicId = e['t_id'];
                                  subTopicController.clear();
                                  isUpdateMode = false;
                                });
                              },
                              child: Text(
                                e['t_name'],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedtopicDD = newValue!;
                              loadSubTopic(selectedtopicId!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sub Topic',
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
                      controller: subTopicController,
                      maxLines: 1,
                    ),
                  ),
                  Center(
                      child: customElevatedButton(
                          onPressed: () async {
                            if (isUpdateMode == false) {
                              addSubTopic();
                            } else {
                              int stid = selectedSubTopicID!;
                              Map<String, dynamic> stData = {
                                "st_name": subTopicController.text,
                                "t_id": selectedtopicId,
                              };

                              int code = await APIHandler()
                                  .updateSubTopic(stid, stData);
                              if (code == 200) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text('Sub-topic updated'),
                                    );
                                  },
                                );
                                subTopicController.clear();
                                setState(() {
                                  loadSubTopic(selectedtopicId!);
                                  isUpdateMode = false;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text('Error updating Sub-topic'),
                                    );
                                  },
                                );
                              }
                            }
                          },
                          buttonText: isUpdateMode ? 'Update' : 'Add')),
                  Expanded(
                    child: ListView.builder(
                        itemCount: subtopiclist.length,
                        itemBuilder: (context, index) {
                          return Card(
                              // elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white.withOpacity(0.8),
                              // color: Colors.transparent,
                              child: ListTile(
                                  title: Text(
                                    subtopiclist[index]['st_name'],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            // Find the index of the item with matching t_id
                                            int indexx = topiclist.indexWhere(
                                                (e) =>
                                                    e['t_id'] ==
                                                    subtopiclist[index]
                                                        ['t_id']);
                                            setState(() {
                                              selectedSubTopicID =
                                                  subtopiclist[index]['st_id'];
                                            });
                                            if (indexx != -1) {
                                              // If item with matching c_id is found
                                              setState(() {
                                                // Set selectedCourseId
                                                selectedtopicId =
                                                    topiclist[indexx]['t_id'];
                                                // Set selectedCourse based on index
                                                // selectedCourse =
                                                //     clist[indexx]['c_code'];
                                                // Toggle the update mode
                                                isUpdateMode = true;
                                              });
                                            }
                                            // Set CLO text to desc TextFormField
                                            subTopicController.text =
                                                subtopiclist[index]['st_name'];

                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                          )),
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
