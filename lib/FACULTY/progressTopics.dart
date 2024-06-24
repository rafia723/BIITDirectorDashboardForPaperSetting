import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/commonTopics.dart';
import 'package:biit_directors_dashbooard/FACULTY/coveredTopics.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class ProgressTopicScreen extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int cid;
  final int fid;

  const ProgressTopicScreen({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
    required this.fid,
  }) : super(key: key);

  @override
  State<ProgressTopicScreen> createState() => _ProgressTopicScreenState();
}

class _ProgressTopicScreenState extends State<ProgressTopicScreen> {
  bool isPressedCovered = false;
  bool isPressedCommon = false;
  bool isPressedProgress = true;
  List<dynamic> topiclist = [];
  Map<int, List<dynamic>> subTopicMap =
      {}; // Map to store subtopics by topic ID
  Map<int, bool> topicCheckState = {}; // Map to store check state of topics
  Map<int, Map<int, bool>> subTopicCheckState =
      {}; // Map to store check state of subtopics
  Map<int, int?> topicTaughtidMap = {}; // Map to store ttid for topics
  Map<int, Map<int, int?>> subTopicTaughtidMap =
      {}; // Map to store ttid for subtopics
  List<dynamic> commonTopicList = [];

  Map<int, bool> commonSubTopicCheckState =
      {}; // Map to store check state of common subtopics
  List<dynamic> atlist = [];
  String? selectedFaculty; // Nullable initially

  Future<void> loadTopics(int cid) async {
    try {
      topiclist = await APIHandler().loadTopics(cid);
      setState(() {});
    } catch (e) {
      if (mounted) {
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
  }

  Future<void> loadSubTopic(int tid) async {
    try {
      subTopicMap[tid] = await APIHandler().loadSubTopic(tid);
      setState(() {});
    } catch (e) {
      if (mounted) {
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
  }

  Future<void> loadCommonSubTopicsTaught(int cid) async {
    try {
      commonTopicList = await APIHandler().loadCommonSubTopics(cid);
      // Update common check state
      for (var topic in commonTopicList) {
        int? stid = topic['st_id'];

        if (stid != null) {
          commonSubTopicCheckState[stid] = true;
        }
      }
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error loading common-topics'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> addTopicsTaught(int tid, int? stid, int fid) async {
    try {
      int ttid = await APIHandler().addTopicTaught(tid, stid, fid);
      setState(() {
        if (stid == null) {
          topicTaughtidMap[tid] = ttid;
        } else {
          subTopicTaughtidMap[tid] ??= {};
          subTopicTaughtidMap[tid]![stid] = ttid;
        }
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

  Future<void> deleteTopicTaught(int ttid) async {
    try {
      int code = await APIHandler().deleteTopicTaught(ttid);
      if (code == 200) {
        setState(() {
          // Update the UI after deletion
        });
      } else {
        throw Exception('Failed to delete topic');
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

  Future<void> loadTopicsTaught(int fid) async {
    try {
      List<dynamic> topicsTaught = await APIHandler().getTopicTaught(fid);
      topicCheckState.clear();
      subTopicCheckState.clear();
      topicTaughtidMap.clear();
      subTopicTaughtidMap.clear();

      for (var topic in topicsTaught) {
        int tid = topic['t_id'];
        int? stid = topic['st_id'];
        int ttId = topic['tt_id'];

        if (stid == null) {
          topicCheckState[tid] = true;
          topicTaughtidMap[tid] = ttId;
        } else {
          subTopicCheckState[tid] ??= {};
          subTopicCheckState[tid]![stid] = true;
          subTopicTaughtidMap[tid] ??= {};
          subTopicTaughtidMap[tid]![stid] = ttId;
        }
      }
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

  Future<void> loadCourseAssignedToFacultyNames(int cid) async {
    try {
      atlist = await APIHandler().loadCourseAssignedToFacultyNames(cid);
      setState(() {});
      if (atlist.isEmpty) {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error:'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadTopics(widget.cid);
    loadCommonSubTopicsTaught(widget.cid);
    loadCourseAssignedToFacultyNames(widget.cid);
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: customAppBar(context: context, title: 'Topics Progress'),
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
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                widget.coursename,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Course Code: ${widget.ccode}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    customButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoveredTopics(
                                    cid: widget.cid,
                                    ccode: widget.ccode,
                                    coursename: widget.coursename,
                                    fid: widget.fid)));
                      },
                      buttonText: 'Covered',
                      isPressed: isPressedCovered,
                    ),
                    const SizedBox(width: 10),
                    customButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommonTopicsScreen(
                                    cid: widget.cid,
                                    ccode: widget.ccode,
                                    coursename: widget.coursename,
                                    fid: widget.fid)));
                      },
                      buttonText: 'Common',
                      isPressed: isPressedCommon,
                    ),
                    const SizedBox(width: 10),
                    customButton(
                      onPressed: () {},
                      buttonText: 'Progress',
                      isPressed: isPressedProgress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Topics',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(26, 112, 106, 106),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                hint: const Text(' Select Teacher '),
                                isExpanded: true,
                                elevation: 9,
                                value: selectedFaculty,
                                items: atlist.map((e) {
                                  return DropdownMenuItem<String>(
                                    value: e['f_id'].toString(),
                                    onTap: () {
                                      setState(() {
                                        selectedFaculty = e['f_id'].toString();
                                      });
                                      loadTopicsTaught(e['f_id']);
                                    },
                                    child: Text(
                                      e['f_name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedFaculty = newValue;
                                  });
                                  loadTopicsTaught(int.parse(selectedFaculty!));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          for (var topic in topiclist)
                            ExpansionTile(
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: topicCheckState[topic['t_id']] ?? false,
                                      onChanged: null,
                                    ),
                                    Text(topic['t_name']),
                                  ],
                                ),
                              ),
                              initiallyExpanded: isPressedProgress,
                              onExpansionChanged: (bool expanded) {
                                if (expanded && subTopicMap[topic['t_id']] == null) {
                                  loadSubTopic(topic['t_id']);
                                }
                              },
                              children: [
                                if (subTopicMap[topic['t_id']] != null)
                                  for (var subTopic in subTopicMap[topic['t_id']]!)
                                    CheckboxListTile(
                                      title: Text(subTopic['st_name']),
                                      value: subTopicCheckState[topic['t_id']]?[subTopic['st_id']] ?? false,
                                      onChanged: null,
                                    ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}