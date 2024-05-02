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
  bool isPressedCovered = false;
  bool isPressedCommon = false;
  bool isPressedProgress = false;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: customAppBar(context: context, title: 'Covered Topics'),
        body: Stack(children: [
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
            ),
          ),
              ],
            ),
          ),
        ]));
  }
}