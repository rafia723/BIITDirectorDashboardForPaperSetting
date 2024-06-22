import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/Director/paperApproval.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class AdditionlQuestions extends StatefulWidget {
  final int cid;
  final String coursename;
  final String ccode;
  final int pid;
  final String qdifficulty;
  final int qid;
  const AdditionlQuestions({
    Key? key,
    required this.cid,
    required this.ccode,
    required this.coursename,
    required this.pid,
    required this.qdifficulty,
    required this.qid,
  }) : super(key: key);
  @override
  State<AdditionlQuestions> createState() => _AdditionlQuestionsState();
}

class _AdditionlQuestionsState extends State<AdditionlQuestions> {
  List<dynamic> qlist = [];
  dynamic paperId;
  Map<int, List<dynamic>> cloListsForQuestions = {};
  Map<int, List<dynamic>> subQuestions = {};
  List<dynamic> subqlist = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    loadQuestionsWithPendingStatus(widget.pid);
    if (qlist.isNotEmpty) {
      loadCloListsForQuestions();
    }
    setState(() {});
  }

  Future<void> loadQuestionsWithPendingStatus(int pid) async {
    try {
      qlist = await APIHandler().loadQuestionsWithPendingStatus(pid);

      setState(() {});
      if (qlist.isNotEmpty) {
        await loadCloListsForQuestions();
        for (var question in qlist) {
          await loadSubQuestionData(question['q_id']);
        }
      }
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

  Future<void> loadQuestionsWithUploadedStatus(int pid) async {
    try {
      qlist = await APIHandler().loadQuestionsWithUploadedStatus(pid);
      setState(() {});
      if (qlist.isNotEmpty) {
        loadCloListsForQuestions();
        for (var question in qlist) {
          await loadSubQuestionData(question['q_id']);
        }
      }
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

  Future<void> updateQuestionStatustoUploaded(int qid) async {
    try {
      dynamic code = await APIHandler().updateQuestionStatusToUploaded(qid);

      if (mounted) {
        if (code == 200) {
          setState(() {
            showSuccesDialog(context, 'Question Added');
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

  Future<void> updateQuestionStatustoRejected(int qid, String newStatus) async {
    try {
      dynamic code = await APIHandler()
          .updateQuestionStatusToApprovedOrRejected(qid, newStatus);
      if (mounted) {
        if (code == 200) {
          setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Additional Questions'),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: qlist.length,
                    itemBuilder: (context, index) {
                      final question = qlist[index];
                      final imageUrl = question['q_image'];
                      List<dynamic> cloListForQuestion =
                          cloListsForQuestions[question['q_id']] ?? [];
                      List<dynamic> sqlist =
                          subQuestions[question['q_id']] ?? [];

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
                                      return Text(
                                          'Error loading image: $error');
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
                                    Text('${question['q_difficulty']},'),
                                    Text('${question['q_marks']},'),
                                    Text(
                                        'CLOs: ${cloListForQuestion.isEmpty ? 'Loading...' : cloListForQuestion.map((entry) => entry['clo_number'] as String).join(', ')}'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  if (question['q_difficulty'] ==
                                      widget.qdifficulty) {
                                    await updateQuestionStatustoRejected(
                                        widget.qid, 'rejected');
                                    await updateQuestionStatustoUploaded(
                                        question['q_id']);
                                    await loadQuestionsWithUploadedStatus(
                                        widget.pid);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PaperApproval(
                                                  pid: widget.pid,
                                                  cid: widget.cid,
                                                  ccode: widget.ccode,
                                                  coursename: widget.coursename,
                                                  status: 'rejected',
                                                )));
                                    await loadQuestionsWithUploadedStatus(
                                        widget.pid);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  } else {
                                    showErrorDialog(context,
                                        'Difficulty level is not matching with the rejected question so you cant replace it,Difficulty level of rejected question was ${widget.qdifficulty}');
                                  }
                                },
                                icon: const Icon(Icons.check)),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
