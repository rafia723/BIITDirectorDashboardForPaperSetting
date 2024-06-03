import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/clogrid.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

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
  dynamic fid;
  Map<int, String> facultyNames = {}; // Store faculty names here
  int easyCount = 0;
  int mediumCount = 0;
  int hardCount = 0;
  dynamic difficulty;
  List<dynamic> difficultyList = [];
  List<dynamic> paperGridWeightageOfTerm = [];
  List<int> cloIdsShouldbeAddedList = [];
  List<int> cloIdzInQuestions = []; // Updated to List<int>
  Set<int> missingCLOs = {};
  Set<int> missingCLOsOnCheckOrUnchecked = {};
  Map<int, Set<int>> selectedCLOs = {};

  @override
  void initState() {
    super.initState();
    loadTeachers();
    initializeData();
  }
// // When a question is selected (checkbox checked), add its CLO ID(s) to the list
// void addToSelectedCLOs(int questionId, int topicId) async {
//   try {
//     // Fetch CLOs mapped with the associated topic
//     List<dynamic> cloList = await APIHandler().loadClosMappedWithTopic(topicId);
//     if (cloList.isNotEmpty) {
//       selectedCLOs[questionId] = (selectedCLOs[questionId] ?? {})..addAll(cloList.map((clo) => clo['clo_id']));
//     }
//   } catch (e) {
//     print('Error fetching CLOs: $e');
//   }
// }

// // When a question is deselected (checkbox unchecked), remove its CLO ID(s) from the list
// void removeFromSelectedCLOs(int questionId) {
//   selectedCLOs.remove(questionId);
// }

  void addToSelectedCLOs(int questionId, int topicId) async {
    try {
      // Fetch CLOs mapped with the associated topic
      List<dynamic> cloList =
          await APIHandler().loadClosMappedWithTopic(topicId);
      if (cloList.isNotEmpty) {
        selectedCLOs[questionId] = (selectedCLOs[questionId] ?? {})
          ..addAll(cloList.map((clo) => clo['clo_id']));
        // Update missing CLOs after adding to selected CLOs
      }
    } catch (e) {
      print('Error fetching CLOs: $e');
    }
  }

// When a question is deselected (checkbox unchecked), remove its CLO ID(s) from the list
  void removeFromSelectedCLOs(int questionId) {
    selectedCLOs.remove(questionId);
    // Update missing CLOs after removing from selected CLOs
  }

  Future<void> initializeData() async {
    await loadSession();
    if (sid != null) {
      await loadPaperHeaderData(widget.cid!, sid!);
    }
    if (paperId != null) {
      //  await loadClosDataForQuestions();
      await loadQuestion(paperId);

      // Deduct marks for questions already marked as uploaded
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
      cloIdsShouldbeAddedList.clear();
      for (var item in paperGridWeightageOfTerm) {
        cloIdsShouldbeAddedList.add(item['clo_id']);
      }
      print('clo idx should be included$cloIdsShouldbeAddedList');

      // Initialize cloIdzInQuestions for each selected question
      for (var question in qlist) {
        if (question['q_status'] == 'uploaded') {
          question['cloIdzInQuestions'] = [];
        }
      }

      // Collect CLO IDs only for selected questions
      for (var question in qlist) {
        if (question['q_status'] == 'uploaded') {
          final fetchedTopicId = question['t_id'];
          if (cloMap.containsKey(fetchedTopicId)) {
            for (var clo in cloMap[fetchedTopicId]!) {
              question['cloIdzInQuestions'].add(clo['clo_id']);
            }
          }
        }
      }
      cloIdzInQuestions.clear();
      // Collect all unique CLO IDs in selected questions
      for (var question in qlist) {
        if (question['q_status'] == 'uploaded') {
          cloIdzInQuestions.addAll(
              (question['cloIdzInQuestions'] as List<dynamic>).cast<int>());
        }
      }

      // Remove duplicates from cloIdzInQuestions
      cloIdzInQuestions = cloIdzInQuestions.toSet().toList();
      print('cloidzod selected questions $cloIdzInQuestions');

      missingCLOs.clear();
      // Check for missing CLOs
      missingCLOs =
          cloIdsShouldbeAddedList.toSet().difference(cloIdzInQuestions.toSet());
    }
  }

  Future<void> loadClosDataForQuestions() async {
    if (paperId != null) {
      for (var question in qlist) {
        final fetchedTopicId = question['t_id'];
        await loadClosMappedWithTopicData(fetchedTopicId);
        setState(() {});
      }
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

  Future<void> loadPaperHeaderData(int cid, int sid) async {
    try {
      plist = await APIHandler().loadPaperHeader(cid, sid);
      setState(() {});
      if (plist.isNotEmpty) {
        paperId = plist[0]['p_id'];
        duration = plist[0]['duration'];
        degree = plist[0]['degree'];
        session = plist[0]['session'];
        term = plist[0]['term'];
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
      for (var question in qlist) {
        fid = question['f_id'];
        if (fid != null) {
          await loadFacultyName(fid);
        }
      }
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadClosMappedWithTopicData(int tid) async {
    try {
      List<dynamic> list = await APIHandler().loadClosMappedWithTopic(tid);
      if (list.isNotEmpty) {
        cloMap[tid] = list;
      }
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
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
                Text('Questions Remaining: $qNoCounter'),
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
                final fetchedTopicId = question['t_id'];
                fid = question['f_id'];
                final facultyName = facultyNames[fid] ?? 'Loading...';

                // Fetch CLOs for the current topic if not already fetched
                if (!cloMap.containsKey(fetchedTopicId)) {
                  loadClosMappedWithTopicData(fetchedTopicId);
                }
                final cloList = cloMap[fetchedTopicId] ?? [];
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
                                if (qNoCounter == 0 && newValue == true) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'You cannot add more questions because the total number of questions have reached their limit.');
                                  }
                                } else {
                                  await updateStatus(
                                      question['q_id'], newValue);

                                  if (newValue == true) {
                                    //   int qMarks = question['q_marks'];
                                    setState(() {
                                      tMarks += question['q_marks'] as int;
                                      qNoCounter--;

                                      difficulty = question['q_difficulty'];
                                      if (difficulty.toLowerCase() == 'easy') {
                                        easyCount--;
                                        print('easy $easyCount');
                                      } else if (difficulty.toLowerCase() ==
                                          'medium') {
                                        mediumCount--;
                                        print('medium $mediumCount');
                                      } else if (difficulty.toLowerCase() ==
                                          'hard') {
                                        hardCount--;
                                        print('hard $hardCount');
                                      }
//  addToSelectedCLOs(
//               question['q_id'],
//               question['t_id']
//           );
                                      setState(() {
                                        initializeData();
                                      });
                                      //   counter = (counter - qMarks);
                                    });
                                  } else if (newValue == false) {
                                    // If the checkbox is unchecked, add the qMarks back to tMarks
                                    //  int qMarks = question['q_marks'];
                                    setState(() {
                                      //   counter = (counter + qMarks);
                                      tMarks -= question['q_marks'] as int;
                                      qNoCounter++;

                                      difficulty = question['q_difficulty'];
                                      if (difficulty.toLowerCase() == 'easy') {
                                        easyCount++;
                                        print('easy $easyCount');
                                      } else if (difficulty.toLowerCase() ==
                                          'medium') {
                                        mediumCount++;
                                        print('medium $mediumCount');
                                      } else if (difficulty.toLowerCase() ==
                                          'hard') {
                                        hardCount++;
                                        print('hard $hardCount');
                                      }
                                      //                               removeFromSelectedCLOs(
                                      //     question['q_id']
                                      // );
                                      setState(() {
                                        initializeData();
                                      });
                                    });
                                  }
                                }
                              }),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${question['q_difficulty']},'),
                              Text('${question['q_marks']},'),
                              Text('$facultyName,'),
                              FutureBuilder<List<int>>(
                                future: APIHandler()
                                    .loadCloNumberOfSpecificCloids(cloList
                                        .map((clo) => clo['clo_id'])
                                        .toList()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                        'Error loading CLO numbers');
                                  } else {
                                    final cloNumbers = snapshot.data ?? [];
                                    return Text(
                                        'CLOs: ${cloNumbers.join(', ')}');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
                    //   if(counter==0&&qNoCounter==0){
                    if (qNoCounter == 0 &&
                        easyCount == 0 &&
                        mediumCount == 0 &&
                        hardCount == 0) {
                      initializeData();
                      if (missingCLOs.isNotEmpty) {
                        // print('Missing $missingCLOs');
                        //   print('Missing /hhjj $missingCLOsOnCheckOrUnchecked');
                        //Display missing clo
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Missing CLOs'),
                              content:
                                  // Text(
                                  //     'Some CLOs are missing $missingCLOs'),
                                  const Text('Some CLOs are missing'),
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