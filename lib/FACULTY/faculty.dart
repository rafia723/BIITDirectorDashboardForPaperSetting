import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/courseview.dart';
import 'package:biit_directors_dashbooard/FACULTY/notification.dart';
import 'package:biit_directors_dashbooard/FACULTY/paperStatusScreen.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class Faculty extends StatefulWidget {
  final String facultyname;
  final int fid;

  const Faculty({Key? key, required this.facultyname, required this.fid})
      : super(key: key);
  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  int overallCount = 0;
  int questionNotificationsCount = 0;
  int headerNotificationsCount = 0;
  List<dynamic> aclist = [];
  List<dynamic> list = [];
  List<dynamic> feedbackList = [];

  Future<void> loadAssignedCourses(int id) async {
    try {
      aclist = await APIHandler().loadAssignedCourses(id);
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadNotifications() async {
    try {
      list = await APIHandler().loadCommentsforQuestion(widget.fid);
      setState(() {
        for (int i = 0; i < list.length; i++) {
          questionNotificationsCount++;
          overallCount += questionNotificationsCount;
        }
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadFeedback() async {
    try {
      feedbackList =
          await APIHandler().loadCommentsForPaperHeaderOnlyifSenior(widget.fid);
      setState(() {
        for (int i = 0; i < feedbackList.length; i++) {
          headerNotificationsCount++;
          overallCount += headerNotificationsCount;
        }
      });
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Widget _buildCourseButton(Map<String, dynamic> course) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseView(
                  coursename: course['c_title'] ?? 'No Title Available',
                  ccode: course['c_code'] ?? 'No Title Available',
                  fname: widget.facultyname,
                  fid: widget.fid,
                  role: course['role'],
                  cid: course['c_id'],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: customButtonColor,
            fixedSize: const Size(170, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            course['c_title'] ?? 'No Title Available',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          course['c_code'] ?? 'No Title Available',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  @override
  void initState() {
    loadAssignedCourses(widget.fid);
    loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customAppBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Faculty Dashboard',
          style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: const Icon(Icons.logout),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(
                        facultyname: widget.facultyname,
                        fid: widget.fid,
                      ),
                    ),
                  );
                },
              ),
              if (overallCount > 0)
                Positioned(
                  right: 8,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 15,
                      minHeight: 15,
                    ),
                    child: Text(
                      '$overallCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            iconSize: 30.0,
            icon: const Icon(
              Icons.timer,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaperStatusScreen(
                    fid: widget.fid,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10),
                Text(
                  'Welcome, ${widget.facultyname}!',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 80),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.6, // Adjust the height as needed
                    child: ListView.builder(
                      itemCount: (aclist.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;

                        // Check if the second index is within the length of the list
                        bool hasSecond = secondIndex < aclist.length;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCourseButton(aclist[firstIndex]),
                            if (hasSecond)
                              _buildCourseButton(aclist[secondIndex]),
                          ],
                        );
                      },
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
