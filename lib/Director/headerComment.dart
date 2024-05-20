import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class HeaderComment extends StatefulWidget {
  final int cid;
  final String coursename;
  final String ccode;
  final int pid;
   final int? qid;
   const HeaderComment({
    Key? key,
    required this.cid,
    required this.ccode,
    required this.coursename,
    required this.pid,
    this.qid
  }) : super(key: key);

  @override
  State<HeaderComment> createState() => _HeaderCommentState();
}

class _HeaderCommentState extends State<HeaderComment> {
  TextEditingController commentController = TextEditingController();

  Future<void> addFeedbackData(String feedbackText, int pid, int? qid) async {
    try {
      dynamic code = await APIHandler().addFeedback(feedbackText, pid, qid);
      setState(() {
        
      });
      if(code==200){
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop(); 
            });
            return const AlertDialog(
              title: Text('Comment Posted...'),
            );
          },
        );
        commentController.clear();
      }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error inserting feedback'),
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
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Comments'),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15.0), // Adjust as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
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
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 130,
                    ),
                    TextFormField(
                      maxLines: 6,
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              addFeedbackData(commentController.text, widget.pid, widget.qid);
                            }, icon: const Icon(Icons.send))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
