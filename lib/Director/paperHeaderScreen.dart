import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/Director/headerComment.dart';
import 'package:biit_directors_dashbooard/Director/paperApproval.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class PaperHeaderScreen extends StatefulWidget {
  final int cid;
  final String coursename;
  final String ccode;
  const PaperHeaderScreen({
    Key? key,
    required this.cid,
    required this.ccode,
    required this.coursename,
  }) : super(key: key);

  @override
  State<PaperHeaderScreen> createState() => _PaperHeaderScreenState();
}

class _PaperHeaderScreenState extends State<PaperHeaderScreen> {
  Widget customText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500, // Default font weight
        fontSize: 16.0, // Default font size
      ),
    );
  }

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

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await loadSession();
    setState(() {});
    loadTeachers();

    if (sid != null) {
      loadPaperHeaderData(widget.cid, sid!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(context: context, title: 'Paper Header'),
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
            padding: const EdgeInsets.only(left: 15.0), // Adjust as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  widget.coursename,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Course Code: ${widget.ccode}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HeaderComment(cid: widget.cid, ccode: widget.ccode, coursename: widget.coursename,pid: paperId,)));
                        },
                        icon: const Icon(
                          Icons.comment,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const Text(
                    'Paper Header',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Teachers :        '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(
                          teachers.isEmpty
                              ? 'Loading...' // Display loading text
                              : teachers
                                  .map<String>(
                                      (teacher) => teacher['f_name'] as String)
                                  .join(', '),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Course Title :   '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(widget.coursename),
                      ),
                    ],
                  ),
                   const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Course Code :  '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(widget.ccode),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Date of Exam : '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(
                            '${date?.day ?? ''}/${date?.month ?? ''}/${date?.year ?? 'Loading...'}'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Duration :         '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(duration ?? 'Loading...'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Degree :            '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(degree ?? 'Loading...'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Session :          '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(session ?? 'Loading...'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Term :               '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(term ?? 'Loading...'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Year :                '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText('${year ?? 'Loading...'}'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Total Marks :   '),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: customText(tMarks ?? 'Loading...'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      customText('Number Of \nQuestions :        '),
                      const SizedBox(
                        width: 20,
                      ),
                      customText('${questions ?? 'Loading...'}'),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  customElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperApproval(
                                    cid: widget.cid,
                                    ccode: widget.ccode,
                                    coursename: widget.coursename)));
                      },
                      buttonText: 'View Paper')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
