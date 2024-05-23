import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class CoveredTopics extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int cid;
  final int fid;

  const CoveredTopics({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
    required this.fid,
  }) : super(key: key);

  @override
  State<CoveredTopics> createState() => _CoveredTopicsState();
}

class _CoveredTopicsState extends State<CoveredTopics> {
  bool isPressedCovered = false;
  bool isPressedCommon = false;
  bool isPressedProgress = false;
  List<dynamic> topiclist = [];
  Map<int, List<dynamic>> subTopicMap = {}; // Map to store subtopics by topic ID
  Map<int, bool> topicCheckState = {}; // Map to store check state of topics
  Map<int, Map<int, bool>> subTopicCheckState = {}; // Map to store check state of subtopics
  Map<int, int?> topicTaughtidMap = {}; // Map to store ttid for topics
  Map<int, Map<int, int?>> subTopicTaughtidMap = {}; // Map to store ttid for subtopics

  Future<void> loadTopics(int cid) async {
    try {
      topiclist = await APIHandler().loadTopics(cid);
      await loadTopicsTaught();
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

  Future<void> loadTopicsTaught() async {
    try {
      List<dynamic> topicsTaught = await APIHandler().getTopicTaught(widget.fid);
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

  @override
  void initState() {
    super.initState();
    loadTopics(widget.cid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Covered Topics'),
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
                          setState(() {
                            isPressedCovered = true;
                            isPressedCommon = false;
                            isPressedProgress = false;
                          });
                        },
                        buttonText: 'Covered',
                        isPressed: isPressedCovered,
                      ),
                      const SizedBox(width: 10),
                      customButton(
                        onPressed: () {
                          setState(() {
                            isPressedCovered = false;
                            isPressedCommon = true;
                            isPressedProgress = false;
                          });
                        },
                        buttonText: 'Common',
                        isPressed: isPressedCommon,
                      ),
                      const SizedBox(width: 10),
                      customButton(
                        onPressed: () {
                          setState(() {
                            isPressedCovered = false;
                            isPressedCommon = false;
                            isPressedProgress = true;
                          });
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
                      return ExpansionTile(
                        title: Row(
                          children: [
                            Checkbox(
                              value: topicCheckState[topiclist[index]['t_id']] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  int tid = topiclist[index]['t_id'];
                                  topicCheckState[tid] = value ?? false;

                                  // Check/uncheck all subtopics
                                  if (value == true) {
                                    addTopicsTaught(tid, null, widget.fid);
                                    if (subTopicMap[tid] != null) {
                                      for (var subTopic in subTopicMap[tid]!) {
                                        subTopicCheckState[tid] ??= {};
                                        subTopicCheckState[tid]![subTopic['st_id']] = true;
                                        addTopicsTaught(tid, subTopic['st_id'], widget.fid);
                                      }
                                    }
                                  } else {
                                    if (topicTaughtidMap[tid] != null) {
                                      deleteTopicTaught(topicTaughtidMap[tid]!);
                                      topicTaughtidMap[tid] = null;
                                    }
                                    if (subTopicTaughtidMap[tid] != null) {
                                      for (var ttid in subTopicTaughtidMap[tid]!.values) {
                                        if (ttid != null) {
                                          deleteTopicTaught(ttid);
                                        }
                                      }
                                      subTopicTaughtidMap[tid] = {};
                                    }
                                    subTopicCheckState[tid]?.updateAll((key, value) => false);
                                  }
                                });
                              },
                            ),
                            Text(topiclist[index]['t_name']),
                          ],
                        ),
                        onExpansionChanged: (bool expanded) {
                          if (expanded && subTopicMap[topiclist[index]['t_id']] == null) {
                            loadSubTopic(topiclist[index]['t_id']);
                          }
                        },
                        children: [
                          if (subTopicMap[topiclist[index]['t_id']] != null)
                            for (var subTopic in subTopicMap[topiclist[index]['t_id']]!)
                              CheckboxListTile(
                                title: Text(subTopic['st_name']),
                                value: subTopicCheckState[topiclist[index]['t_id']]?[subTopic['st_id']] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    int tid = topiclist[index]['t_id'];
                                    int stid = subTopic['st_id'];
                                    subTopicCheckState[tid] ??= {};
                                    subTopicCheckState[tid]![stid] = value ?? false;
                                    if (value == true) {
                                      addTopicsTaught(tid, stid, widget.fid);
                                    } else {
                                      if (subTopicTaughtidMap[tid]?[stid] != null) {
                                        deleteTopicTaught(subTopicTaughtidMap[tid]![stid]!);
                                        subTopicTaughtidMap[tid]![stid] = null;
                                      }
                                    }
                                  });
                                },
                              ),
                        ],
                      );
                    },
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