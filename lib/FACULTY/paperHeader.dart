import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/paperSetting.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaperHeader extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  const PaperHeader(
      {super.key,
      required this.cid,
      required this.ccode,
      required this.coursename});

  @override
  State<PaperHeader> createState() => _PaperHeaderState();
}

class _PaperHeaderState extends State<PaperHeader> {
  TextEditingController durationController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController totalMarksController = TextEditingController();
  TextEditingController noOfQuestionsController = TextEditingController();
  String selectedSessionValue = '';
  String selectedtermValue = '';
  DateTime _dateTime = DateTime.now();
  String selectedDate = '';
  int _selectedYear = DateTime.now().year;
  List<dynamic> _teachers = [];
  dynamic status = 'pending';
  dynamic sid;

  @override
  void initState() {
    super.initState();
    loadSession();
    _loadTeachers();
    _loadPaperStatus();
  }

  void _loadPaperStatus() async {
    try {
      status = await APIHandler().loadPaperStatus(widget.cid!, sid);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadTeachers() async {
    try {
      List<dynamic> teachers =
          await APIHandler().loadTeachersByCourseId(widget.cid!);
      setState(() {
        _teachers = teachers;
      });
    } catch (e) {
      print('Error loading teachers: $e');
    }
  }

  Future<void> loadSession() async {
    try {
      Uri uri = Uri.parse("${APIHandler().apiUrl}Paper/getSession");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          // Assuming you only need the first session data if multiple are returned
          Map<String, dynamic> sessionData = responseData[0];
          sid = sessionData['s_id'];
          setState(() {});
        } else {
          print('Session data not found');
        }
      } else {
        print('Failed to load session: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('An error occurred. Please try again later.'),
          );
        },
      );
    }
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100))
        .then((value) => setState(() {
              // _dateTime = value!;
              //    selectedDate = '${DateTime(_dateTime.day, _dateTime.month, _dateTime.year)}';
              _dateTime = DateTime(value!.year, value.month, value.day);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(context: context, title: 'Paper Header'),
        body: Stack(children: [
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coursename,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Course Code: ${widget.ccode}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),

              //      const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '  Status: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    status == null ? 'Loading...' : '$status    ',
                    style: TextStyle(
                        fontSize: 16,
                        color: status == "approved" || status == "printed"
                            ? Colors.green
                            : status == "rejected"
                                ? Colors.red
                                : Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      '  Teacher: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _teachers.isEmpty
                          ? 'Loading...' // Display loading text
                          : _teachers
                              .map<String>(
                                  (teacher) => teacher['f_name'] as String)
                              .join(
                                  ', '), // Extract teacher names and join with commas
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       const Text(
              //         '  Course Title:',
              //         style:
              //             TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //       ),
              //       Text(
              //         '    ${widget.coursename}',
              //         style: const TextStyle(fontSize: 16),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     const Text(
              //       '  Course Code:',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       '    ${widget.ccode}',
              //       style: const TextStyle(fontSize: 16),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Row(
                children: [
                  const Text(
                    '  Date of Exam:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '    ${_dateTime.day}/${_dateTime.month}/${_dateTime.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                      onPressed: _showDatePicker,
                      icon: const Icon(Icons.calendar_month)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '  Duration:       ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                        maxLines: 1,
                        controller: durationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    '  Degree:         ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                        maxLines: 1,
                        controller: degreeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    '  Total Marks: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        controller: totalMarksController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '  Session:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Radio(
                      value: 'Fall',
                      groupValue: selectedSessionValue,
                      onChanged: (val) {
                        setState(() {
                          selectedSessionValue = val.toString();
                        });
                      }),
                  const Text('Fall'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: 'Spring',
                      groupValue: selectedSessionValue,
                      onChanged: (val) {
                        setState(() {
                          selectedSessionValue = val.toString();
                        });
                      }),
                  const Text('Spring'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: 'Summer',
                      groupValue: selectedSessionValue,
                      onChanged: (val) {
                        setState(() {
                          selectedSessionValue = val.toString();
                        });
                      }),
                  const Text('Summer'),
                ],
              ),
              const Text(
                '  Term:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Radio(
                      value: 'Mid',
                      groupValue: selectedtermValue,
                      onChanged: (val) {
                        setState(() {
                          selectedtermValue = val.toString();
                        });
                      }),
                  const Text('Mid'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: 'Final',
                      groupValue: selectedtermValue,
                      onChanged: (val) {
                        setState(() {
                          selectedtermValue = val.toString();
                        });
                      }),
                  const Text('Final'),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '  No. of Questions: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 35,
                    width: 50,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        controller: noOfQuestionsController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    '  Year: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<int>(
                    value: _selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                      });
                    },
                    items: List.generate(
                      2101 - 2000,
                      (index) => DropdownMenuItem<int>(
                        value: 2000 + index,
                        child: Text((2000 + index).toString()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                  child: customElevatedButton(
                      onPressed: () {
                        APIHandler()
                            .addPaperHeader(
                          durationController.text,
                          degreeController.text,
                          int.parse(totalMarksController.text),
                          selectedtermValue,
                          _selectedYear,
                          _dateTime,
                          selectedSessionValue,
                          widget.cid!,
                          sid,
                          status,
                        )
                            .then((code) {
                          if (code == 200) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog after 2 seconds
                                });
                                return const AlertDialog(
                                  title: Text('Added'),
                                );
                              },
                            );
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaperSetting(
                                  cid: widget.cid,
                                  ccode: widget.ccode,
                                  coursename: widget.coursename,
                                  teachers: _teachers,
                                  date: _dateTime,
                                  duration: durationController.text,
                                  degree: degreeController.text,
                                  tMarks: totalMarksController.text,
                                  session: selectedSessionValue,
                                  term: selectedtermValue,
                                  questions:
                                      int.parse(noOfQuestionsController.text),
                                  year: _selectedYear),
                            ));
                          } else if (code == 400) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog after 2 seconds
                                });
                                return const AlertDialog(
                                  title: Text(
                                      'Paper term already added for the course and session'),
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog after 2 seconds
                                });
                                return AlertDialog(
                                  title: Text('Error....$code'),
                                );
                              },
                            );
                          }
                        });
                      
                      },
                      buttonText: 'Continue'))
            ],
          ),
        ]));
  }
}
