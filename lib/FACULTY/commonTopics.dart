import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/coveredTopics.dart';
import 'package:biit_directors_dashbooard/FACULTY/progressTopics.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonTopicsScreen extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int cid;
  final int fid;
  const CommonTopicsScreen({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
    required this.fid,
  }) : super(key: key);

  @override
  State<CommonTopicsScreen> createState() => _CommonTopicsScreenState();
}

class _CommonTopicsScreenState extends State<CommonTopicsScreen> {
  bool isPressedCovered = false;
  bool isPressedCommon = true;
  bool isPressedProgress = false;
  List<dynamic> topiclist = [];
  Map<int, List<dynamic>> subTopicMap = {}; // Map to store subtopics by topic ID
  Map<int, bool> topicCheckState = {}; // Map to store check state of topics
  Map<int, Map<int, bool>> subTopicCheckState = {}; // Map to store check state of subtopics
  Map<int, int?> topicTaughtidMap = {}; // Map to store ttid for topics
  Map<int, Map<int, int?>> subTopicTaughtidMap = {}; // Map to store ttid for subtopics
  List<dynamic> commonTopicList = [];

  Map<int, bool> commonSubTopicCheckState = {}; // Map to store check state of common subtopics
  List<dynamic> atlist = [];
  String? selectedFaculty; // Nullable initially

  Future<void> loadTopics(int cid) async {
    try {
      topiclist = await APIHandler().loadTopics(cid);
      // Load subtopics for each topic
      for (var topic in topiclist) {
        await loadSubTopic(topic['t_id']);
      }
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
      appBar: customAppBar(context: context, title: 'Common Topics'),
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
                        
                        },
                        buttonText: 'Common',
                        isPressed: isPressedCommon,
                      ),
                      const SizedBox(width: 10),
                      customButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProgressTopicScreen(
                                      cid: widget.cid,
                                      ccode: widget.ccode,
                                      coursename: widget.coursename,
                                      fid: widget.fid)));
                        },
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
                  child: ListView.builder(
                    itemCount: topiclist.length,
                    itemBuilder: (context, index) {
                      int tid = topiclist[index]['t_id'];
                      bool allSubtopicsChecked =
                          true; // Flag to track if all subtopics are checked
                      if (subTopicMap[tid] != null) {
                        for (var subTopic in subTopicMap[tid]!) {
                          // If any subtopic is unchecked, set the flag to false
                          if (!(commonSubTopicCheckState[subTopic['st_id']] ??
                              false)) {
                            allSubtopicsChecked = false;
                            break;
                          }
                        }
                      }
                      return ExpansionTile(
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Checkbox(
                                value: allSubtopicsChecked,
                                onChanged: null, // Nullify the onChanged callback for common topics
                              ),
                              Text(topiclist[index]['t_name']),
                            ],
                          ),
                        ),
                        initiallyExpanded: isPressedCommon,
                        onExpansionChanged: (bool expanded) {
                          if (expanded && subTopicMap[tid] == null) {
                            loadSubTopic(tid);
                          }
                        },
                        children: [
                          if (subTopicMap[tid] != null)
                            for (var subTopic in subTopicMap[tid]!)
                              CheckboxListTile(
                                title: Text(subTopic['st_name']),
                                value: commonSubTopicCheckState[subTopic['st_id']] ?? false,
                                onChanged: null,
                              ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}