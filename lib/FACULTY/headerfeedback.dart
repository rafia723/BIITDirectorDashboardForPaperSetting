

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/forwardrdBack.dart';
import 'package:biit_directors_dashbooard/FACULTY/headerEdit.dart';
import 'package:biit_directors_dashbooard/FACULTY/notification.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class HeaderFeedback extends StatefulWidget {
  final String facultyname;
  final int fid;

  const HeaderFeedback({Key? key, required this.facultyname, required this.fid})
      : super(key: key);


  @override
  State<HeaderFeedback> createState() => _HeaderFeedbackState();
}

class _HeaderFeedbackState extends State<HeaderFeedback> {

   bool isHeaderPressed=true;
   bool isCommentPressed=false;
     List<dynamic> feedbackList = [];

       @override
  void initState() {
    super.initState();
    loadFeedback();
    
  }

 Future<void> loadFeedback() async {
    try {
      feedbackList = await APIHandler().loadCommentsForPaperHeaderOnlyifSenior(widget.fid);
      setState(() {
      });
    } catch (e) {
      if(mounted){
  showErrorDialog(context, e.toString());
      }
   
    }
  }

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Notifications'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 190,
                          height: 50,
                          child: customButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Notifications(fid: widget.fid, facultyname: widget.facultyname),
                                ),
                              );
                            },
                            buttonText: 'Question Comments',
                            isPressed: isCommentPressed,
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          height: 50,
                          child: customButton(
                            onPressed: () {
                              setState(() {
                                isHeaderPressed = true;
                                isCommentPressed = false;
                              });
                            },
                            buttonText: 'Header Comments',
                            isPressed: isHeaderPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return GestureDetector(
                        onTap: (){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeaderEdit(fid: widget.fid,cid: feedback['c_id'],ccode: feedback['c_code'],coursename: feedback['c_title'],),
                                ),
                              );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          // decoration: BoxDecoration(
                          //   border: const Border(
                          //     top: BorderSide(width: 1.0),
                          //     bottom: BorderSide(color: Colors.black, width: 1.0),
                          //   ),
                          //   borderRadius: BorderRadius.circular(0.0),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('${feedback['c_code']} | ', style: const TextStyle(fontSize: 15)),
                                    Text(feedback['c_title'], style: const TextStyle(fontSize: 15)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                   SingleChildScrollView(scrollDirection:Axis.horizontal ,
                               child: Text(feedback['feedback_details'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: customButtonColor,
        onPressed: (){
            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForwardedBack(fid: widget.fid,facultyname: widget.facultyname,),
                                ),
                              );
        },
        child: const Icon(Icons.remove_red_eye,color: Colors.white,),
      ),
    );
  }
}