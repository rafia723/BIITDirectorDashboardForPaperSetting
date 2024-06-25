import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class PaperView extends StatefulWidget {
   final int cid;
  final String coursename;
  final String ccode;
  final int pid;

  const PaperView({
    Key? key,
    required this.cid,
    required this.ccode,
    required this.coursename,
    required this.pid,
  }) : super(key: key);


  @override
  State<PaperView> createState() => _PaperViewState();
}

class _PaperViewState extends State<PaperView> {
   List<dynamic> plist = [];
  List<dynamic> aplist = [];
  List<dynamic> qlist = [];
  dynamic paperId;
  String? duration;
  String? degree;
  int tMarks = 0;
  String? session;
  String? term;
  int? year;
  DateTime? date;
  List<dynamic> teachers = [];

  Map<int, String> statusMap = {};
  Map<int, List<dynamic>> cloListsForQuestions = {};
  List<dynamic> listOfClos = [];
  Map<int, List<dynamic>> subQuestions = {};
  List<dynamic> subqlist = [];

  @override
  void initState() {
    super.initState();
    initializeData();
    loadQuestionsWithUploadedAndApprovedStatus(widget.pid);
  }

  Future<void> initializeData() async {
   
    await loadTeachers();
    
     await loadPaperHeaderData();
    
    await loadQuestionsWithUploadedAndApprovedStatus(widget.pid);
    if (qlist.isNotEmpty) {
      for (var question in qlist) {
        if (question['q_status'] == 'approved') {
          int qMarks = question['q_marks'];
          if (mounted) {
            setState(() {
              tMarks += qMarks;
            });
          }
        }
      }
      loadCloListsForQuestions();
    }
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

  Future<void> loadPaperHeaderData() async {
    try {
      plist = await APIHandler().loadPaperHeaderOfSpecificPid(widget.pid);
      setState(() {
        if (plist.isNotEmpty) {
          paperId = plist[0]['p_id'];
          duration = plist[0]['duration'];
          degree = plist[0]['degree'];
          session = plist[0]['session'];
          term = plist[0]['term'];
          year = plist[0]['year'];
          date = DateTime.parse(plist[0]['exam_date']);
        }
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

  Future<void> loadTeachers() async {
    try {
      List<dynamic> teachersList =
          await APIHandler().loadTeachersByCourseId(widget.cid);
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

 

  Future<void> loadQuestionsWithUploadedAndApprovedStatus(int pid) async {
    try {
      qlist = await APIHandler().loadQuestionsWithUploadedStatus(pid);
      if (qlist.isNotEmpty) {
        await loadCloListsForQuestions();
      }
      List<dynamic> allCloLists = []; // List to store CLOs of all questions
      for (var question in qlist) {
        int qid = question['q_id'];

        await loadSubQuestionData(question['q_id']);
        List<dynamic> cloListForQuestion = await APIHandler()
            .loadClosofSpecificQuestion(qid); // Load CLOs for each question
        allCloLists.add(cloListForQuestion); // Add CLOs to the list
        statusMap[qid] = question['q_status'];
      }
      setState(() {
        listOfClos = allCloLists; // Assign the list of CLOs to listOfClos
      });
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

  Future<void> updatePaperStatus(int pid) async {
    try {
      dynamic code = await APIHandler().updatePaperStatusToApproved(pid);
      if (mounted) {
        if (code == 200) {
          setState(() {
            showSuccesDialog(context, 'Paper Approved');
          });
        } else {
          throw Exception('Non-200 response code code=$code');
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error changing status of paper'),
              content: Text(e.toString()), // Optionally show the error message
            );
          },
        );
      }
    }
  }

  Future<void> loadApprovedPapersData() async {
    try {
      aplist = await APIHandler().loadApprovedPapers();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error loading approved papers'),
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
      appBar: AppBar(
        backgroundColor: customAppBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 0, // No shadow
        title: const Text(
          'Paper',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Adjust icon color as needed
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                          image: AssetImage('assets/images/biit.png'),
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
                          image: AssetImage('assets/images/biit.png'),
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
                              '         Course Code: ',
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
                                child: Text(degree ?? 'Loading...',
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
              Expanded(
                child: ListView.builder(
                  itemCount: qlist.length,
                  itemBuilder: (context, index) {
                    final question = qlist[index];
                    final imageUrl = question['q_image'];
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
                          title: Text(
                            'Question # ${index + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          '   ${String.fromCharCode(97 + idx)}.  ${subQuestion['sq_text']}'),
                                                    ),
                                                  ],
                                                ),
                                                if (subQuestion['sq_image'] !=
                                                    null)
                                                  Image.network(
                                                    subQuestion['sq_image'],
                                                    height: 150,
                                                    width: 300,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return const CircularProgressIndicator();
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
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
                                  //  Text('${question['q_difficulty']},'),
                                  Text('Marks:${question['q_marks']},'),
                                  Text(
                                      'CLOs: ${cloListForQuestion.isEmpty ? 'Loading...' : cloListForQuestion.map((entry) => entry['clo_number'] as String).join(', ')}'),
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
            ],
          ),
        ],
      ),
    );
  }
}
