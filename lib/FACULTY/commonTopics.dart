import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class CommonTopics extends StatefulWidget {
   final String coursename;
  final String ccode;
  final int cid;
  const CommonTopics(
      {Key? key,
      required this.coursename,
      required this.ccode,
      required this.cid})
      : super(key: key);

  @override
  State<CommonTopics> createState() => _CommonTopicsState();
}

class _CommonTopicsState extends State<CommonTopics> {
Color customColor = const Color.fromARGB(255, 78, 223, 180);
  bool isPressedCovered = false;
  bool isPressedCommon = false;
  bool isPressedProgress = false;

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
                color: Colors.white),
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
        body: Stack(children: [
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
            padding: const EdgeInsets.only(left: 30.0), // Adjust as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  widget.coursename,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'Course Code: ${widget.ccode}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    customButton(
                        onPressed: () {
                          setState(() {
                            isPressedCovered = true;
                            isPressedCommon=false;
                            isPressedProgress=false;
                          });
                        },
                        buttonText: 'Covered',
                        isPressed: isPressedCovered),
                    const SizedBox(
                      width: 10,
                    ),
                    customButton(
                        onPressed: () {
                          setState(() {
                             isPressedCovered = false;
                            isPressedCommon=true;
                            isPressedProgress=false;
                          });
                        },
                        buttonText: 'Common',
                        isPressed: isPressedCommon),
                    const SizedBox(
                      width: 10,
                    ),
                    customButton(
                        onPressed: () {
                          setState(() {
                             isPressedCovered = false;
                            isPressedCommon=false;
                            isPressedProgress=true;
                          });
                        },
                        buttonText: 'Progress',
                        isPressed: isPressedProgress),
                  ],
                ),
                const SizedBox(height: 20,),
                const Text(
            'Topics',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
              ],
            ),
          ),
        ]));
  }
}