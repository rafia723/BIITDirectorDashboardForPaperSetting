import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/headerfeedback.dart';
import 'package:biit_directors_dashbooard/FACULTY/questionEdit.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final String facultyname;
  final int fid;

  const Notifications({Key? key, required this.facultyname, required this.fid}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isHeaderPressed = false;
  bool isCommentPressed = true;
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      list = await APIHandler().loadCommentsforQuestion(widget.fid);
      setState(() {});
    } catch (e) {
      if (mounted) {
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
                const SizedBox(
                  height: 10,
                ),
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
                              onPressed: () {},
                              buttonText: 'Question Comments',
                              isPressed: isCommentPressed),
                        ),
                        SizedBox(
                          width: 190,
                          height: 50,
                          child: customButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HeaderFeedback(
                                              fid: widget.fid,
                                              facultyname: widget.facultyname,
                                            )));
                              },
                              buttonText: 'Header Comments',
                              isPressed: isHeaderPressed),
                        )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    // Assuming your API returns objects with appropriate keys
                    final item = list[index];
                    return GestureDetector(
                      onTap: (){
                         Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionEdit(fid: widget.fid,cid: item['c_id'],ccode: item['c_code'],coursename: item['c_title'],qid: item['q_id'],fromCommentScreen: true,),
                                ),
                              );
                      },
                      child: Card(
                           margin: const EdgeInsets.symmetric(vertical: 5.0),
                       
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              // Display c_code from the database
                                              Text('${item['c_code']} | ', style: const TextStyle(fontSize: 15)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              // Display c_title from the database
                                              Text('${item['c_title']}', style: const TextStyle(fontSize: 15)),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Display feedback_details from the database
                                          Text('${item['feedback_details']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ),
                    );
                  }
                ),
  
                
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}