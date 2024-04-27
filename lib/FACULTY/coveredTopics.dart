import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoveredTopics extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int cid;

  const CoveredTopics({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
  }) : super(key: key);

  @override
  State<CoveredTopics> createState() => _CoveredTopicsState();
}

class _CoveredTopicsState extends State<CoveredTopics> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  bool isPressedCovered = false;
  bool isPressedCommon = false;
  bool isPressedProgress = false;
  List<dynamic> topiclist = [];
  Map<int, bool> topicCheckboxState = {}; // Track the state of topic checkboxes
  Map<int, bool> subtopicCheckboxState = {}; // Track the state of subtopic checkboxes
  bool isLoading = true; // Track whether data is loading or not

  Future<void> loadTopics(int cid) async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Topic/getTopic/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          topiclist = jsonDecode(response.body);
          isLoading = false; // Data loaded successfully, set isLoading to false
        });
      } else {
        throw Exception('Failed to load Topics');
      }
    } catch (e) {
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

  Future<List<dynamic>> loadSubTopic(int tid) async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}SubTopic/getSubTopic/$tid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> subtopics = jsonDecode(response.body);

        return subtopics;
      } else {
        throw Exception('Failed to load sub-topics');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading sub-topics'),
          );
        },
      );
      return [];
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Covered Topics',
          style: TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  image: AssetImage('assets/images/Faculty.png'),
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
                const SizedBox(height: 100),
                Text(
                  widget.coursename,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Course Code: ${widget.ccode}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
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
                const SizedBox(height: 20),
                const Text(
                  'Topics',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isLoading) // Show loading indicator if data is still loading
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                if (!isLoading) // Show list only if data has been loaded
                  Expanded(
                    child: isPressedCovered
                        ? ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      itemCount: topiclist.length,
                      itemBuilder: (context, index) {
                        // Initialize topic checkbox state
                        topicCheckboxState.putIfAbsent(index, () => false);

                        return FutureBuilder(
                          future: loadSubTopic(topiclist[index]['t_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(); // Return an empty container
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<dynamic> subtopics =
                                  snapshot.data as List<dynamic>;
                              return Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Colors.white10,
                                child: ListTile(
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                       
                                        Checkbox(
                                          value: topicCheckboxState[index],
                                          onChanged: (newValue) {
                                            setState(() {
                                              topicCheckboxState[index] =
                                                  newValue!;
                                              // When a topic checkbox is checked, update all subtopic checkboxes
                                              for (var i = 0;
                                                  i < subtopics.length;
                                                  i++) {
                                                subtopicCheckboxState[
                                                        index * 1000 +
                                                            i] =
                                                    newValue;
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          '${index + 1}. ${topiclist[index]['t_name']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0;
                                          i < subtopics.length;
                                          i++)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                               SizedBox(width: 10,),
                                              Checkbox(
                                                value:
                                                    subtopicCheckboxState[index * 1000 + i] ??
                                                        false,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    subtopicCheckboxState[
                                                            index * 1000 + i] =
                                                        newValue!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                '  ${index + 1}.${i + 1} ',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${subtopics[i]['st_name']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ) : const SizedBox(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}