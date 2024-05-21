import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/coveredTopics.dart';
import 'package:biit_directors_dashbooard/FACULTY/manageClos.dart';
import 'package:biit_directors_dashbooard/FACULTY/managePaper.dart';
import 'package:biit_directors_dashbooard/FACULTY/manageTopics.dart';
import 'package:biit_directors_dashbooard/FACULTY/paperHeader.dart';
import 'package:biit_directors_dashbooard/FACULTY/paperSetting.dart';
import 'package:biit_directors_dashbooard/FACULTY/viewClos.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class CourseView extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int cid;
  final String fname;
  final int fid;
  final String role;
  const CourseView(
      {Key? key,
      required this.coursename,
      required this.ccode,
      required this.cid,
      required this.fname,
      required this.fid,
      required this.role})
      : super(key: key);

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  dynamic sid;
  List<dynamic> list = [];
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    await loadSession();
    if (sid != null) {
      await loadPaperHeader(widget.cid, sid);
    }
    setState(() {
      isLoading=false;
    });
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

  Future<void> loadPaperHeader(int cid, int sid) async {
    try {
      list = await APIHandler().loadPaperHeader(cid, sid);
      setState(() {});
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

  Widget customButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: customButtonColor,
        minimumSize: const Size(250, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.black),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(context: context, title: 'Settings'),
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
          Center(
            child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  customButton(
                      text: 'Paper Settings',
                      onPressed: () {
                        setState(() {
                          
                        });
                        if (list.isEmpty&&widget.role == 'Senior') {
                      
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>
                           PaperHeader(cid: widget.cid, ccode: widget.ccode, 
                           coursename: widget.coursename, fid: widget.fid)));
                         
                        } else if(list.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperSetting(
                                      ccode: widget.ccode,
                                      coursename: widget.coursename,
                                      cid: widget.cid,
                                      fid: widget.fid,
                                    )));
                      }
                      else{
                        showDialog(context: context,
                         builder: (context){
                          return const AlertDialog(
                              title: Text('Missing'),
                              content: Text('The Paper header has not been created yet'),
                          );
                           
                        });
                      }}),
                  const SizedBox(height: 10),
                  customButton(
                      text: 'View Topics',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoveredTopics(
                                coursename: widget.coursename,
                                ccode: widget.ccode,
                                cid: widget.cid),
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  customButton(
                      text: 'View Clos',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewClos(
                                coursename: widget.coursename,
                                ccode: widget.ccode,
                                cid: widget.cid),
                          ),
                        );
                      }),
                  Column(
                    children: <Widget>[
                      if (widget.role == 'Senior') ...[
                        const SizedBox(height: 10),
                        customButton(
                            text: 'Manage Paper',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManagePaper(
                                      coursename: widget.coursename,
                                      ccode: widget.ccode,
                                      cid: widget.cid),
                                ),
                              );
                            }),
                        const SizedBox(height: 10),
                        customButton(
                            text: 'Manage Topics',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageTopics(
                                      coursename: widget.coursename,
                                      ccode: widget.ccode,
                                      cid: widget.cid),
                                ),
                              );
                            }),
                        const SizedBox(height: 10),
                        customButton(
                            text: 'Manage Clos',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageClos(
                                      coursename: widget.coursename,
                                      ccode: widget.ccode,
                                      cid: widget.cid),
                                ),
                              );
                            })
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
