import 'dart:convert';
import 'dart:typed_data';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PaperSetting extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;

  const PaperSetting({
    super.key,
    required this.cid,
    required this.ccode,
    required this.coursename,
  });

  @override
  State<PaperSetting> createState() => _PaperSettingState();
}

class _PaperSettingState extends State<PaperSetting> {
  TextEditingController questionController = TextEditingController();
  TextEditingController marksController = TextEditingController();
  String dropdownValue = 'Easy';
  dynamic paperId;
  dynamic sid;
  DateTime? date;
  String? duration;
  String? degree;
  String? tMarks;
  String? session;
  String? term;
  int? questions;
  int? year;
  List<dynamic> list = [];
  List<dynamic> teachers = [];
  List<dynamic> qlist = [];
  //////////Question
  String? qtext;
  Uint8List? qimage;
  int? qmarks;
  String? qdifficulty;
  String? qstatus;
  int? tid;
  int? pid;
  int? fid;
  Uint8List? selectedImage;

  Future<void> initializeData() async {
    await loadSession();
    if (sid != null) {
      await loadPaperHeader(widget.cid!, sid, context);
      setState(() {});
    }
    if (paperId != null) {
      await loadQuestion(paperId, context);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadTeachers();
    initializeData();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() async {
        selectedImage = await pickedImage.readAsBytes();
      });
    }
  }

  Future<void> loadPaperHeader(int cid, int sid, context) async {
    try {
      Uri uri =
          Uri.parse("${APIHandler().apiUrl}Paper/getPaperHeader/$cid/$sid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          list = jsonDecode(response.body);
          if (list.isNotEmpty) {
            paperId = list[0]['p_id'];
            duration = list[0]['duration'];
            degree = list[0]['degree'];
            tMarks = list[0]['t_marks'].toString();
            session = list[0]['session'];
            term = list[0]['term'];
            questions = list[0]['NoOfQuestions'];
            year = list[0]['year'];
            date = DateTime.parse(list[0]['exam_date']);
          }
        });
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Data not found for the given id'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title:
                  Text('Failed to load paper header. Please try again later.'),
            );
          },
        );
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

  Future<void> loadQuestion(int pid, context) async {
    try {
      Uri uri = Uri.parse("${APIHandler().apiUrl}Question/getQuestion/$pid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          qlist = jsonDecode(response.body);
        });
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Data not found for the given id'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  'Failed to load paper Questions. Please try again later.'),
            );
          },
        );
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

  Future<void> loadTeachers() async {
    try {
      List<dynamic> teachersList =
          await APIHandler().loadTeachersByCourseId(widget.cid!);
      setState(() {
        teachers = teachersList;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Paper Setting'),
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 70, // Adjust the width of the circular logo
                      height: 70, // Adjust the height of the circular logo
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Adjust the border color
                          width: 1.0, // Adjust the border width
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/biit.png'), // Replace with the path to your logo image
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Text(
                      'Barani Institute of Information Technology\n       PMAS Arid Agriculture University,\n                 Rawalpindi,Pakistan\n      ${session ?? 'Session'} ${year ?? 0} : ${term ?? ''} Term Examination',
                      style: const TextStyle(
                          fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 70, // Adjust the width of the circular logo
                      height: 70, // Adjust the height of the circular logo
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Adjust the border color
                          width: 1.0, // Adjust the border width
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/biit.png'), // Replace with the path to your logo image
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black)),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Course Title: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                                child: Text(
                              widget.coursename,
                              //  overflow: TextOverflow.ellipsis, // Optionally, set overflow behavior
                              //      maxLines: 5,
                              style: const TextStyle(fontSize: 12),
                            )),
                            const Text(
                              'Course Code: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                                child: Text(
                              widget.ccode,
                              style: const TextStyle(fontSize: 12),
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Date of Exam: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                              child: Text(
                                '${date?.day ?? ''}/${date?.month ?? ''}/${date?.year ?? ''}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const Text(
                              'Duration: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                                child: Text(
                              duration ?? '',
                              style: const TextStyle(fontSize: 12),
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Degree Program: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                                child: Text(degree ?? '',
                                    style: const TextStyle(fontSize: 12))),
                            const Text(
                              'Total Marks: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                                child: Text(
                              tMarks ?? '',
                              style: const TextStyle(fontSize: 12),
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Teachers Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Expanded(
                              child: Text(
                                teachers.isEmpty
                                    ? 'Loading...' // Display loading text
                                    : teachers
                                        .map<String>((teacher) =>
                                            teacher['f_name'] as String)
                                        .join(', '),
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: questionController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 12.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)))),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _selectImage();
                        },
                        icon: const Icon(Icons.photo_library)),
                    IconButton(
                        onPressed: () {
                          dynamic code = APIHandler().addQuestion(
                              questionController.text,
                              qimage,
                              int.parse(marksController.text),
                              dropdownValue,
                              'pending',
                              0,
                              paperId ?? 0,
                              0);
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
                                        title: Text('Question Inserted'),
                                      );
                                    },
                                  );
                                  questionController.clear();
                                  marksController.clear();
                                 
                                  setState(() {
                                     dropdownValue='Easy';
                                   loadQuestion(paperId, context);
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
                          
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text('    Difficulty:  '),
                  DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Easy', 'Medium', 'Hard']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  const Text('Topic:  '),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 30),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Marks:  '),
                  SizedBox(
                    width: 50,
                    height: 35, // Set the width as needed
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      controller: marksController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: qlist.length,
                  itemBuilder: (context, index) {
                    final question = qlist[index];
                    final qImageBase64 = question['q_image'];
                    Uint8List? imageBytes;

                    if (qImageBase64 != null && qImageBase64.isNotEmpty) {
                      imageBytes = base64Decode(qImageBase64);
                    }

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                        title: Text(
                          'Question # ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question['q_text']),
                            if (imageBytes != null)
                              Center(
                                  child: Image.memory(
                                imageBytes,
                                height: 150,
                                width: 300,
                              )),
                          ],
                        ),

                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       onPressed: () {
                        //         // Handle edit
                        //         editCourseRecords(
                        //             clist[index]['c_id'], clist[index]);
                        //       },
                        //       icon: const Icon(Icons.edit),
                        //     ),
                        //     Switch(
                        //         value: clist[index]['status'] == 'enabled',
                        //         onChanged: (newValue) {
                        //           setState(() {
                        //             updateStatus(
                        //                 clist[index]['c_id'], newValue);
                        //           });
                        //         })
                        //   ],
                        // ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
