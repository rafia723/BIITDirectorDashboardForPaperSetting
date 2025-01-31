import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/clogrid.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManagePaper extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  const ManagePaper({
    super.key,
    required this.cid,
    required this.ccode,
    required this.coursename,
  });

  @override
  State<ManagePaper> createState() => _ManagePaperState();
}

class _ManagePaperState extends State<ManagePaper> {
  List<dynamic> plist = [];
  List<dynamic> qlist = [];
  dynamic paperId;
  String? duration;
  String? degree;
  int tMarks = 0;
  String? session;
  String? term;
  int? noOfQuestions;
  int? year;
  DateTime? date;
  List<dynamic> teachers = [];
  dynamic sid;
  bool isChecked = false;
  Map<int, List<dynamic>> cloMap = {};
  dynamic counter;
  dynamic qNoCounter;
  dynamic fname;
  dynamic facultyid;
  Map<int, String> facultyNames = {}; // Store faculty names here
  int easyCount = 0;
  int mediumCount = 0;
  int hardCount = 0;
  dynamic difficulty;
  List<dynamic> difficultyList = [];
  List<dynamic> paperGridWeightageOfTerm = [];
  List<int> cloIdsShouldbeAddedList = [];
  List<dynamic> listOfClos = [];
  List<int> missingcloss = [];
  Map<int, List<dynamic>> cloListsForQuestions = {};
  List<int> cloWeightageCheck = [];
  Map<int, List<dynamic>> subQuestions = {};
  List<dynamic> subqlist = [];
  String? status;

  @override
  void initState() {
    super.initState();
    loadTeachers();
    initializeData();
  }

  Future<void> initializeData() async {
    await loadSession();
    if (sid != null) {
      await loadPaperHeaderData(widget.cid!, sid!);
    }
    if (paperId != null) {
      await loadQuestion(paperId!);
    }
    if (qlist.isNotEmpty) {
      for (var question in qlist) {
        if (question['q_status'] == 'uploaded') {
          int qMarks = question['q_marks'];
          if (mounted) {
            setState(() {
              tMarks += qMarks;
              if (qNoCounter != null) {
                qNoCounter--;
              }
              if (question['q_difficulty'] == 'Easy') {
                easyCount--;
              }
              if (question['q_difficulty'] == 'Medium') {
                mediumCount--;
              }
              if (question['q_difficulty'] == 'Hard') {
                hardCount--;
              }
            });
          }
        }
      }
      loadCloListsForQuestions();
      checksFunction();
    }

//checksFunction();
  }

  Future<void> checksFunction() async {
    // Collect all CLOs for selected questions
    List<List<String>> allCloLists = [];
    for (var question in qlist) {
      int qid = question['q_id'];
      List<String> cloListForQuestion = await loadClosofSpecificQuestion(qid);
      allCloLists.add(cloListForQuestion);
    }

    // Deduct marks for questions already marked as uploaded

    cloIdsShouldbeAddedList.clear();
    for (var item in paperGridWeightageOfTerm) {
      try {
        cloIdsShouldbeAddedList.add(int.parse(item['clonumber']));
      } catch (e) {
        print('Error parsing clonumber: ${item['clonumber']}');
      }
    }
    print(' CLOs should be added: $cloIdsShouldbeAddedList');

    List<int> selectedQuestionIds = qlist
        .where((question) => question['q_status'] == 'uploaded')
        .map<int>((question) => question['q_id'] as int)
        .toList();
    missingcloss =
        await findMissingCLOs(selectedQuestionIds, cloIdsShouldbeAddedList);

    print('Missing CLOs: $missingcloss');
  }

  Future<List<int>> findMissingCLOs(
      List<int> selectedQuestionIds, List<int> cloIdsShouldbeAddedList) async {
    Set<int> actualCLOs = {};

    for (int questionId in selectedQuestionIds) {
      List<String> cloStrings = await loadClosofSpecificQuestion(questionId);
      actualCLOs.addAll(cloStrings.map((clo) => int.parse(clo)));
    }
    Set<int> notInCloGridSpecificTerm =
        actualCLOs.difference(cloIdsShouldbeAddedList.toSet());
    cloWeightageCheck = notInCloGridSpecificTerm.toList();
    print('Dont have weightage in this term $notInCloGridSpecificTerm');
    print('Actual $actualCLOs');
    List<int> missingcloss =
        cloIdsShouldbeAddedList.toSet().difference(actualCLOs).toList();
    return missingcloss;
  }

  Future<void> loadCloListsForQuestions() async {
    for (var question in qlist) {
      int qid = question['q_id'];
      List<dynamic> cloListForQuestion =
          await APIHandler().loadClosofSpecificQuestion(qid);
      cloListsForQuestions[qid] = cloListForQuestion;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateStatus(int id, dynamic newStatus) async {
    try {
      dynamic code = await APIHandler()
          .updateQuestionStatusFromPendingToUploaded(id, newStatus);
      if (mounted) {
        if (code == 200) {
          loadQuestion(paperId);
        } else {
          throw Exception('Non-200 response code');
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadSubQuestionData(int qid) async {
    try {
      subqlist = await APIHandler().loadSubQuestionOfSpecificQid(qid);
      setState(() {
        subQuestions[qid] = subqlist;
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadPaperHeaderData(int cid, int sid) async {
    try {
      plist = await APIHandler().loadPaperHeaderIfTermMidAndApproved(cid, sid);
      setState(() {});
      if (plist.isNotEmpty) {
        paperId = plist[0]['p_id'];
        duration = plist[0]['duration'];
        degree = plist[0]['degree'];
        session = plist[0]['session'];
        term = plist[0]['term'];
        status=plist[0]['status'];
        await loadClosWeightageofSpecificCourseAndHeaderName(
            widget.cid!, term!);
        if (mounted) {
          setState(() {
            //  print(paperGridWeightageOfTerm);
          });
        }
        noOfQuestions = plist[0]['NoOfQuestions'];

        await loadDifficulty(noOfQuestions!);
        setState(() {
          //print(difficultyList);
        });
        qNoCounter = noOfQuestions;
        year = plist[0]['year'];
        date = DateTime.parse(plist[0]['exam_date']);
      }
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
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadDifficulty(int noOfQuest) async {
    try {
      difficultyList = await APIHandler().loadDifficulty(noOfQuest);
      setState(() {
        if (difficultyList.isNotEmpty) {
          easyCount = difficultyList[0]['Easy'];
          mediumCount = difficultyList[0]['Medium'];
          hardCount = difficultyList[0]['Hard'];
        }
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadFacultyName(int fid) async {
    try {
      fname = await APIHandler().loadFacultyName(fid);
      setState(() {
        facultyNames[fid] = fname;
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
      for (var question in qlist) {
        facultyid = question['f_id'];
        int qid = question['q_id'];
        await loadSubQuestionData(question['q_id']);
        List<dynamic> cloListForQuestion = await APIHandler()
            .loadClosofSpecificQuestion(qid); // Load CLOs for each question
        allCloLists.add(cloListForQuestion); // Add CLOs to the list
        if (facultyid != null) {
          await loadFacultyName(facultyid!);
        }
      }
      setState(() {
        listOfClos = allCloLists; // Assign the list of CLOs to cloList
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<List<String>> loadClosofSpecificQuestion(int qid) async {
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}QuestionTopic/getClosOfSpecificQuesestion/$qid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> cloData = jsonDecode(response.body);
        List<String> cloNumbers =
            cloData.map((data) => data['clo_number'].toString()).toList();
        return cloNumbers;
      } else {
        throw Exception('Error fetching CLOs for question');
      }
    } catch (e) {
      throw Exception('Failed to load CLOs mapped with question');
    }
  }

  Future<void> loadClosWeightageofSpecificCourseAndHeaderName(
      int cid, String term) async {
    try {
      List<dynamic> list = await APIHandler()
          .loadClosWeightageofSpecificCourseAndHeaderName(cid, term);
      if (list.isNotEmpty) {
        paperGridWeightageOfTerm = list;
      }
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<List<int>> loadTopicsMappedWithQuestion(int qid) async {
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}QuestionTopic/getTopicMappedWithQuestion/$qid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> topicIds = jsonDecode(response.body);
        return topicIds.cast<int>();
      } else {
        throw Exception('Error fetching topics for question');
      }
    } catch (e) {
      throw Exception('Failed to load topics mapped with question');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Manage Paper'),
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
        Column(children: [
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
                          '$tMarks',
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
//////////////////////////////////////////////////////////////Questions Display///////////////////////////////////////////////////////////
         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // const SizedBox(
                //   width: 10,
                // ),
                Column(
                  children: [
                    Text('Questions Remaining: $qNoCounter'),
                        Text(
                      '$status',
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Easy: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$easyCount'),
                    const Text(
                      '  Medium: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$mediumCount',
                    ),
                    const Text(
                      '  Hard: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$hardCount',
                    ),
                  ],
                ),

                //   Text('Marks Remaining: $counter'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: qlist.length,
                itemBuilder: (context, index) {
                  final question = qlist[index];
                  final imageUrl = question['q_image'];
                  int fid = question['f_id'];
                  final facultyName = facultyNames[fid] ?? 'Loading...';
                  List<dynamic> cloListForQuestion =
                      cloListsForQuestions[question['q_id']] ?? [];
                  List<dynamic> sqlist = subQuestions[question['q_id']] ?? [];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white.withOpacity(0.8),
                    child: GestureDetector(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Row(
                          children: [
                            Text(
                              'Question # ${index + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(
                              width: 190,
                            ),
                           Checkbox(
  value: question['q_status'] == 'uploaded',
  onChanged: (bool? newValue) async {
    if (newValue == true) {
      if (qNoCounter == 0) {
        if (mounted) {
          showErrorDialog(context,
              'You cannot add more questions because the total number of questions have reached their limit.');
        }
        return;
      }
      
      difficulty = question['q_difficulty'].toLowerCase();
      if (difficulty == 'easy' && easyCount == 0) {
        if (mounted) {
          showErrorDialog(context, 'You cannot add more Easy Questions');
        }
        return;
      } else if (difficulty == 'medium' && mediumCount == 0) {
        if (mounted) {
          showErrorDialog(context, 'You cannot add more Medium Questions');
        }
        return;
      } else if (difficulty == 'hard' && hardCount == 0) {
        if (mounted) {
          showErrorDialog(context, 'You cannot add more Hard Questions');
        }
        return;
      }

      await updateStatus(question['q_id'], newValue);

      setState(() {
        tMarks += question['q_marks'] as int;
        qNoCounter--;

        if (difficulty == 'easy') {
          easyCount--;
        } else if (difficulty == 'medium') {
          mediumCount--;
        } else if (difficulty == 'hard') {
          hardCount--;
        }
      });

    } else {
      await updateStatus(question['q_id'], newValue);

      setState(() {
        tMarks -= question['q_marks'] as int;
        qNoCounter++;

        difficulty = question['q_difficulty'].toLowerCase();
        if (difficulty == 'easy') {
          easyCount++;
        } else if (difficulty == 'medium') {
          mediumCount++;
        } else if (difficulty == 'hard') {
          hardCount++;
        }
      });
    }

    checksFunction();
  },
),
                          ],
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const CircularProgressIndicator();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Text('Error loading image: $error');
                                },
                              ),
                            if (sqlist.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...sqlist.asMap().entries.map((entry) {
                                    int idx = entry.key;
                                    var subQuestion = entry.value;
                                    return Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      '   ${String.fromCharCode(97 + idx)}.  ${subQuestion['sq_text']}'),
                                                ),
                                              ],
                                            ),
                                            if (subQuestion['sq_image'] != null)
                                              Image.network(
                                                subQuestion['sq_image'],
                                                height: 150,
                                                width: 300,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const CircularProgressIndicator();
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Text(
                                                      'Error loading image: $error');
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${question['q_difficulty']},'),
                                Text('${question['q_marks']},'),
                                Text('$facultyName,'),
                                Text(
                                    'CLOs: ${cloListForQuestion.isEmpty ? 'Loading...' : cloListForQuestion.map((entry) => entry['clo_number'] as String).join(', ')}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),

          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              customElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CLOGrid(
                            cid: widget.cid!,
                            ccode: widget.ccode,
                            coursename: widget.coursename),
                      ),
                    );
                  },
                  buttonText: 'Clo Grid'),
              const SizedBox(
                width: 170,
              ),
              customElevatedButton(
                  onPressed: () async {
                    if (qNoCounter == 0 &&
                        easyCount == 0 &&
                        mediumCount == 0 &&
                        hardCount == 0) {
                      if (missingcloss.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Missing CLOs'),
                              content: Text('CLO-$missingcloss is missing'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (cloWeightageCheck.isNotEmpty) {
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Clo Weightage Error'),
                                content: Text(
                                    'CLO-$cloWeightageCheck has no weightage in $term'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        int code = await APIHandler()
                            .updatePaperStatusToUploaded(paperId);
                        if (code == 200) {
                          if (mounted) {
                            Navigator.pop(context);
                            showSuccesDialog(context, 'Submitted');
                          }
                        }
                      }
                    } else {
                      showErrorDialog(context,
                          'Please ensure question and other counters are 0 before submitting.');
                    }
                  },
                  buttonText: 'Submit'),
            ],
          )
        ]),
      ]),
    );
  }
}
