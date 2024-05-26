import 'package:biit_directors_dashbooard/API/api.dart';
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
  int? tMarks;
  String? session;
  String? term;
  int? questions;
  int? year;
  DateTime? date;
  List<dynamic> teachers = [];
  dynamic sid;
  bool isChecked = false;
  Map<int, List<dynamic>> cloMap = {};
  dynamic counter;
  dynamic qNoCounter;

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
      await loadQuestion(paperId);
      // Deduct marks for questions already marked as uploaded
      for (var question in qlist) {
        if (question['q_status'] == 'uploaded') {
          int qMarks = question['q_marks'];
          setState(() {
            counter = (counter! - qMarks);
            qNoCounter--;
          });
        }
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
        tMarks = plist[0]['t_marks'];
        counter = tMarks;
        session = plist[0]['session'];
        term = plist[0]['term'];
        questions = plist[0]['NoOfQuestions'];
        qNoCounter=questions;
        year = plist[0]['year'];
        date = DateTime.parse(plist[0]['exam_date']);
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
      sid = await APIHandler().loadSession();
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

  Future<void> loadQuestion(int pid) async {
    try {
      qlist = await APIHandler().loadQuestion(pid);
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

  Future<void> loadClosMappedWithTopicData(int tid) async {
    try {
      List<dynamic> list = await APIHandler().loadClosMappedWithTopic(tid);
      cloMap[tid] = list;
          setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error loading CLOs mapped with topic: $e'),
            );
          },
        );
      }
    }
  }

  Future<void> updateStatus(int id, dynamic newStatus) async {
    try {
      dynamic code = await APIHandler().updateQuestionStatusFromPendingToUploaded(id, newStatus);
      if (mounted) {
        if (code == 200) {
          loadQuestion(paperId);
        } else {
          throw Exception('Non-200 response code');
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error changing status of question'),
              content: Text(e.toString()), // Optionally show the error message
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
                 const SizedBox(width: 10,),
                 Text('Questions Remaining: $qNoCounter'),
                       const SizedBox(width: 40,),
                  Text('Marks Remaining: $counter'),
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
                                if(qNoCounter==0&&counter==0&&newValue==true){
                                  if(mounted){
                                    showErrorDialog(context, 'You cannot add more questions because the total marks and number of questions have reached their limit.');
                                  }
                                }else{
                                await updateStatus(question['q_id'], newValue);
                            
                                if (newValue == true) {
                                  int qMarks = question['q_marks'];
                                  setState(() {
                                    qNoCounter--;
                                    counter = (counter - qMarks);
                                
                                  });
                                } else if (newValue == false) {
                                  // If the checkbox is unchecked, add the qMarks back to tMarks
                                  int qMarks = question['q_marks'];
                                  setState(() {
                                    counter = (counter + qMarks);
                                    qNoCounter++;
                                    
                                  });
                                }
                                }
                              
                              }
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${question['q_difficulty']},'),
                              Text('${question['q_marks']},'),
                              Text(
                                  'CLOs: ${cloList.map((clo) => clo['clo_id']).join(',')}'),
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
                    Navigator.pop(context);
                  },
                  buttonText: 'Clo Grid'),
              const SizedBox(
                width: 170,
              ),
              customElevatedButton(
                  onPressed: () {
                    if(counter==0&&qNoCounter==0){
                          Navigator.pop(context);
                    }
                    else{
                      showErrorDialog(context, 'Please ensure both counters are 0 before submitting.');
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
