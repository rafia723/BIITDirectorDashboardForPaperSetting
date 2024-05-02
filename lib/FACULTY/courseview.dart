import 'package:biit_directors_dashbooard/FACULTY/coveredTopics.dart';
import 'package:biit_directors_dashbooard/FACULTY/manageClos.dart';
import 'package:biit_directors_dashbooard/FACULTY/manageTopics.dart';
import 'package:biit_directors_dashbooard/FACULTY/paperHeader.dart';
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  customButton(text: 'Paper Settings', onPressed: () {
                  }),
                  const SizedBox(height: 10),
                  customButton(text: 'View Topics', onPressed: () {
                       Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  CoveredTopics(
                                    coursename: widget.coursename, 
                                  ccode: widget.ccode, cid: widget.cid),
                                ),
                              );
                  }),
                  const SizedBox(height: 10),
                  customButton(text: 'View Clos', onPressed: () {
                     Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  ViewClos(coursename: widget.coursename, ccode: widget.ccode, cid: widget.cid),
                                ),
                              );
                  }),
                  Column(
                    children: <Widget>[
                      if (widget.role == 'Senior') ...[
                        const SizedBox(height: 10),
                        customButton(text: 'Manage Paper', onPressed: () {
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  PaperHeader(
                                    coursename: widget.coursename, 
                                  ccode: widget.ccode, cid: widget.cid),
                                ),
                              );
                        }),
                        const SizedBox(height: 10),
                        customButton(text: 'Manage Topics', onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  ManageTopics(coursename: widget.coursename,ccode: widget.ccode,cid:widget.cid),
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
                                  builder: (context) =>  ManageClos(coursename: widget.coursename,ccode: widget.ccode,cid:widget.cid),
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
