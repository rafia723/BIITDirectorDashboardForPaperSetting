
import 'dart:typed_data';
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PaperSetting extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  final int fid;

  const PaperSetting({
    super.key,
    required this.cid,
    required this.ccode,
    required this.coursename,
    required this.fid,
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
  int tMarks = 0;
  Map<int, String> facultyNames = {};
  dynamic fname;
  String? session;
  String? term;
  int? questions;
  int? year;
  List<dynamic> list = [];
  List<dynamic> teachers = [];
  List<dynamic> qlist = [];
  //////////Question
  String? qtext;
  int? qmarks;
  String? qdifficulty;
  String? qstatus;
  int? tid;
  int? pid;
  dynamic facultyId;
  Uint8List? selectedImage;
  List<dynamic> commonTopicList= [];
  List<bool> isCheckedList = [];
  int? selectedTopicId;
  Map<int, List<dynamic>> cloListsForQuestions = {};
   // Map<int, List<dynamic>> topicListsForQuestions = {};
  //Map<int, List<dynamic>> cloMap = {};
  List<int> selectedTopicIds = [];
 
  List<dynamic> cloList=[];

  @override
  void initState() {
    super.initState();
    loadTeachers();
    initializeData();
    loadCommonTopics();
    
  }

  Future<void> initializeData() async {
    await loadSession();
    if (sid != null) {
      await loadPaperHeader(widget.cid!, sid);
      if (mounted) {
        setState(() {});
      }
    }
    if (paperId != null) {
      await loadQuestion(paperId);
      if(qlist.isNotEmpty){
       
for (var marks in qlist) {
   int qid= marks['q_id'];
        tMarks += (marks['q_marks'] as int);
       loadCloListsForQuestions(qid);
        }
      } 
    }
  
if(mounted){
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text(
      'Please make sure to add at least one question of each difficulty level (Easy, Medium, Hard) for each topic.',
    ),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
      
      },
    ),
  ),
);
}
  }

  
  Future<void> checksFunction() async {
      if (paperId != null) {
      await loadQuestion(paperId);
    }
    }

  Future<void> loadFacultyName(int facultyid) async {
    try {
      fname = await APIHandler().loadFacultyName(facultyid);
      setState(() {
        facultyNames[facultyid] = fname;
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

Future<void> loadCloListsForQuestions(int qid) async {
  
    List<dynamic> cloListForQuestion = await APIHandler().loadClosofSpecificQuestion(qid);
    cloListsForQuestions[qid] = cloListForQuestion;
 if(mounted){
  setState(() {}); 
 }
}

// Future<void> loadTopicListsForQuestions() async {
//   for (var question in qlist) {
//     int qid = question['q_id'];
//     List<dynamic> topicListForQuestion = await APIHandler().loadTopicsDataMappedWithQuestion(qid);
//     topicListForQuestion[qid] = topicListForQuestion;
//   }
//  if(mounted){
//   setState(() {}); 
//  }
// }


  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        selectedImage = bytes;
      });
    }
  }

  Future<void> loadPaperHeader(int cid, int sid) async {
    try {
      list = await APIHandler().loadPaperHeaderIfTermMidAndApproved(cid, sid);
      setState(() {});
      if (list.isNotEmpty) {
        paperId = list[0]['p_id'];
        duration = list[0]['duration'];
        degree = list[0]['degree'];
        // tMarks = list[0]['t_marks'].toString();
        session = list[0]['session'];
        term = list[0]['term'];
        questions = list[0]['NoOfQuestions'];
        year = list[0]['year'];
        date = DateTime.parse(list[0]['exam_date']);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error..'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

 
    Future<void> loadCommonTopics() async {
    try {
      commonTopicList = await APIHandler().loadCommonTopics(widget.cid!);
      setState(() {
        if(commonTopicList.isNotEmpty){
 isCheckedList = List<bool>.filled(commonTopicList.length, false);
        }
      
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

 Future<void> loadQuestion(int pid) async {
  try {
    qlist = await APIHandler().loadQuestion(pid);
    List<dynamic> allCloLists = []; // List to store CLOs of all questions
   //  List<dynamic> allTopicLists = []; // List to store topic of all questions
    for (var question in qlist) {
      facultyId = question['f_id'];
      int qid = question['q_id'];
      List<dynamic> cloListForQuestion = await APIHandler().loadClosofSpecificQuestion(qid); // Load CLOs for each question
      allCloLists.add(cloListForQuestion); // Add CLOs to the list
      loadCloListsForQuestions(qid);

      //  List<dynamic> topicListForQuestion = await APIHandler().loadTopicsDataMappedWithQuestion(qid); // Load topics for each question
      // allTopicLists.add(topicListForQuestion); // Add topics to the list
      if (facultyId != null) {
        await loadFacultyName(facultyId!);
      }
    }
    setState(() {
      cloList = allCloLists; // Assign the list of CLOs to cloList
    });
  } catch (e) {
    if (mounted) {
      showErrorDialog(context, e.toString());
    }
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
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error..'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> loadSession() async {
    try {
      sid = await APIHandler().loadFirstSessionId();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
            );
          },
        );
      }
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
                             child: tMarks == 0
    ? const Text('Loading...')
    : Text(
        '$tMarks',
        style: const TextStyle(fontSize: 12),
      ),),
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
              ////////////////////////////////////// Add Questions Section////////////////////////////////////////
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
                      onPressed: () async {
                   //    initializeData();
                   checksFunction();
                        //2 selectedTopicIds.clear();
                        if (selectedTopicId == null ||
                            dropdownValue.isEmpty ||
                            marksController.text.isEmpty) {
                          showErrorDialog(context, 'Please select required information Topic,Difficulty and marks');
                        } else {
                          dynamic response = await APIHandler().addQuestion(
                            questionController.text,
                            selectedImage,
                            int.parse(marksController.text),
                            dropdownValue,
                            'pending',
                            selectedTopicId!,
                            paperId,
                            widget.fid,
                          );

                          if (response != null && response['status'] == 200) {
                            int qId = response['q_id'];
                            await APIHandler()
                                .addTopicOfQuestion(qId, selectedTopicIds);
                            tMarks += int.parse(marksController.text);
                            questionController.clear();
                            marksController.clear();
                            selectedImage = null;
                            selectedTopicId = null;
                            setState(() {
                              dropdownValue = 'Easy';
                              isCheckedList =
                                  List<bool>.filled(commonTopicList.length, false);
                                    selectedTopicIds.clear();
                              loadQuestion(paperId);

                            });
                          } else {
                            if (mounted) {
                              showErrorDialog(context, 'Error');
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(height: 10),
                  if (selectedImage != null)
                    Stack(
                      children: [
                        Image.memory(
                          selectedImage!,
                          width: 200,
                          height: 200,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImage =
                                    null; // Remove the selected image
                              });
                            },
                            child: Container(
                              color: Colors.red,
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            //to update the status within alertbox
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: const Text('Topics'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: commonTopicList.length,
                                    itemBuilder: (context, index) {
                                      final topic = commonTopicList[index];

                                      return CheckboxListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${index + 1}. ${topic['t_name']}'),
                                          ],
                                        ),
                                        value: isCheckedList[
                                            index], // Set the initial value of checkbox

                                        onChanged: (bool? value) {
                                          setState(() {
                                            isCheckedList[index] = value!;

                                            selectedTopicId = topic['t_id'];
                                            if (value == true) {
                                              selectedTopicIds
                                                  .add(topic['t_id']);
                                            } else {
                                              selectedTopicIds
                                                  .remove(topic['t_id']);
                                              print(selectedTopicId);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  Center(
                                      child: customElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            print(selectedTopicIds);
                                          },
                                          buttonText: 'Save'))
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
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
              ///////////////////////////////////////////////////Questions Display///////////////////////////////////////////////////////////////

 
 Expanded(
  child: ListView.builder(
    itemCount: qlist.length,
    itemBuilder: (context, index) {
      final question = qlist[index];
      final imageUrl = question['q_image'];
      facultyId = question['f_id'];
      final facultyName = facultyNames[facultyId] ?? 'Loading...';

      // Get CLOs for this question from the preloaded map
      List<dynamic> cloListForQuestion = cloListsForQuestions[question['q_id']] ?? [];
   print('CLOs for Question #${index + 1}: $cloListForQuestion'); // Debug print

  //    List<dynamic> topicListForQuestion = topicListsForQuestions[question['q_id']] ?? [];
  //  print('topic for Question #${index + 1}: $topicListForQuestion'); // Debug print
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white.withOpacity(0.8),
        child: ListTile(
          tileColor: Colors.white,
          title: Text(
            'Question # ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question['q_text']),
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  height: 150,
                  width: 300,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error loading image: $error');
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${question['q_difficulty']},'),
                  Text('${question['q_marks']},'),
                  Text('$facultyName,'),
                  Text(
                    'CLOs: ${cloListForQuestion.isEmpty ? 'Loading...' : cloListForQuestion.map((entry) => entry['clo_number'] as String).join(', ')}'
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  ),
),
// customElevatedButton(onPressed: (){
//   Navigator.pop(context);
// }, buttonText: 'Save')
            ],
          )
        ],
      ),
    );
  }
}
