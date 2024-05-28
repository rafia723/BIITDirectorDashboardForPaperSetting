import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/Director/AdditionalQuestions.dart';
import 'package:biit_directors_dashbooard/Director/ApprovedPapersList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class PaperApproval extends StatefulWidget {
  final int cid;
  final String coursename;
  final String ccode;
  final int pid;
  const PaperApproval({
    Key? key,
    required this.cid,
    required this.ccode,
    required this.coursename,
    required this.pid,
  }) : super(key: key);

  @override
  State<PaperApproval> createState() => _PaperApprovalState();
}

class _PaperApprovalState extends State<PaperApproval> {
  List<dynamic> plist = [];
  List<dynamic> qlist = [];
  dynamic paperId;
  String? duration;
  String? degree;
  String? tMarks;
  String? session;
  String? term;
  int? questions;
  int? year;
  DateTime? date;
  List<dynamic> teachers = [];
  dynamic sid;
  bool isChecked = false;
  bool acceptAllChecked = false; // State variable for "Accept All" checkbox
  Map<int, List<dynamic>> cloMap = {};
  TextEditingController commentController = TextEditingController();
  Map<int, String> statusMap = {};

  @override
  void initState() {
    super.initState();
    initializeData();
    loadQuestionsWithUploadedStatus(widget.pid);
  }

  Future<void> initializeData() async {
    await loadSession();
    setState(() {});
    loadTeachers();

    if (sid != null) {
      loadPaperHeaderData(widget.cid, sid!);
    }
  }

  Future<void> loadPaperHeaderData(int cid, int sid) async {
    try {
      plist = await APIHandler().loadPaperHeader(cid, sid);
      setState(() {
        if (plist.isNotEmpty) {
          paperId = plist[0]['p_id'];
          duration = plist[0]['duration'];
          degree = plist[0]['degree'];
          tMarks = plist[0]['t_marks'].toString();
          session = plist[0]['session'];
          term = plist[0]['term'];
          questions = plist[0]['NoOfQuestions'];
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

  Future<void> loadQuestionsWithUploadedStatus(int pid) async {
    try {
      qlist = await APIHandler().loadQuestionsWithUploadedStatus(pid);
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

  Future<void> updateQuestionStatus(int qid, String newStatus) async {
    try {
      dynamic code = await APIHandler()
          .updateQuestionStatusToApprovedOrRejected(qid, newStatus);
      if (mounted) {
        if (code == 200) {
          setState(() {
            statusMap[qid] = newStatus;
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
              title: const Text('Error changing status of question'),
              content: Text(e.toString()), // Optionally show the error message
            );
          },
        );
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

  Future<void> addFeedbackData(String feedbackText, int pid, int? qid) async {
    try {
      dynamic code = await APIHandler().addFeedback(feedbackText, pid, qid);
      setState(() {});
      if (code == 200) {
        if (mounted) {
          showSuccesDialog(context, 'Comment Posted....');
          commentController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, 'Error posting Comment');
      }
    }
  }

  Future<void> updateAllStatuses(String newStatus) async {
    try {
      for (var question in qlist) {
        int qid = question['q_id'];
        await updateQuestionStatus(qid, newStatus);
      }
      setState(() {
        for (var question in qlist) {
          int qid = question['q_id'];
          statusMap[qid] = newStatus;
        }
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error changing statuses of all questions'),
              content: Text(e.toString()), // Optionally show the error message
            );
          },
        );
      }
    }
  }

  Future<void> revertAllStatuses() async {
    try {
      for (var question in qlist) {
        int qid = question['q_id'];
        await updateQuestionStatus(qid, 'uploaded');
      }
      setState(() {
        for (var question in qlist) {
          int qid = question['q_id'];
          statusMap[qid] = 'uploaded';
        }
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error reverting statuses of all questions'),
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
      appBar: customAppBar(context: context, title: 'Paper Approval'),
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
                  'Barani Institute of Information Technology\n       PMAS Arid Agriculture University,\n                 Rawalpindi,Pakistan\n      ${session ?? 'Session'} ${year ?? 'Loading...'} : ${term ?? ''} Term Examination',
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
                            '${date?.day ?? ''}/${date?.month ?? ''}/${date?.year ?? 'Loading...'}',
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
                          duration ?? 'Loading...',
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
                          tMarks ?? 'Loading...',
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
          Row(
            children: [
              const SizedBox(
                width: 280,
              ),
              const Text('Accept All'),
              Checkbox(
                value: acceptAllChecked,
                onChanged: (value) {
                  setState(() {
                    acceptAllChecked = value ?? false;
                    if (acceptAllChecked) {
                      updateAllStatuses('approved');
                    } else {
                      revertAllStatuses(); // Reset or handle as needed
                    }
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: qlist.length,
              itemBuilder: (context, index) {
                final question = qlist[index];
                final imageUrl = question['q_image'];
                final fetchedTopicId = question['t_id'];
                final qid = question['q_id'];

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${question['q_difficulty']},'),
                              Text('${question['q_marks']},'),
                              Text(
                                  'CLOs: ${cloList.map((clo) => clo['clo_id']).join(',')}'),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 170,
                              ),
                              GestureDetector(
                                  child: const Text('Accept'),
                                  onTap: () => {
                                        setState(() {
                                          statusMap[qid] = 'approved';
                                        }),
                                        updateQuestionStatus(qid, 'approved')
                                      }),
                              Radio(
                                value: 'approved',
                                groupValue: statusMap[qid],
                                onChanged: (value) {
                                  setState(() {
                                    statusMap[qid] = value!;
                                  });
                                  updateQuestionStatus(qid, value!);
                                },
                              ),
                              GestureDetector(
                                  child: const Text('Reject'),
                                  onTap: () => {
                                        setState(() {
                                          statusMap[qid] = 'rejected';
                                        }),
                                        updateQuestionStatus(qid, 'rejected')
                                      }),
                              Radio(
                                  value: 'rejected',
                                  groupValue: statusMap[qid],
                                  onChanged: (value) {
                                    setState(() {
                                      statusMap[qid] = value!;
                                    });
                                    updateQuestionStatus(qid, value!);
                                  }),
                            ],
                          ),
                          statusMap[qid] == 'rejected'
                              ? Row(
                                  children: <Widget>[
                                    Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 100,
                                        maxWidth:
                                            260, // Maximum width constraint
                                      ),
                                      child: TextFormField(
                                        controller: commentController,
                                        decoration: const InputDecoration(
                                          labelText: 'Comment',
                                          labelStyle: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        addFeedbackData(commentController.text,
                                            widget.pid, qid);
                                      },
                                      icon: const Icon(Icons.send),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdditionlQuestions(
                                              pid: paperId,
                                              ccode: widget.ccode,
                                              cid: widget.cid,
                                              coursename: widget.coursename,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          await loadQuestionsWithUploadedStatus(
                                              widget.pid);
                                        }
                                      },
                                      icon:
                                          const Icon(Icons.find_replace_sharp),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          acceptAllChecked
              ? customElevatedButton(
                  onPressed: () {
                    updatePaperStatus(widget.pid);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DRTApprovedPapers()));
                  },
                  buttonText: 'Approve')
              : const SizedBox(),
        ]),
      ]),
    );
  }
}
