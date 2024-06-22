import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class AssignedToFacultyNamesHistory extends StatefulWidget {
  final String courseTitle;
  final String ccode;
  final int cid;
  const AssignedToFacultyNamesHistory(
      {Key? key,
      required this.courseTitle,
      required this.ccode,
      required this.cid})
      : super(key: key);

  @override
  State<AssignedToFacultyNamesHistory> createState() => _AssignedToFacultyNamesHistoryState();
}

class _AssignedToFacultyNamesHistoryState extends State<AssignedToFacultyNamesHistory> {
  List<dynamic> atlist = [];

  Future<void> loadCourseAssignedToFacultyNames(int cid) async {
    try {
     atlist=await APIHandler().loadCourseAssignedToFacultyNames(cid);
        setState(() {});
        if(atlist.isEmpty){
          throw Exception('No data found for the given id');
        }
    } catch (e) {
      if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error:'),
            content: Text(e.toString()),
          );
        },
      );
      }
     
    }
  }

  @override
  void initState() {
    loadCourseAssignedToFacultyNames(widget.cid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'View Faculty'),
      body: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15.0,right: 10.0), // Adjust as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.courseTitle,
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
                height: 80,
              ),
              const Center(
                child: Text(
                  'Assigned To:',
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: atlist.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white.withOpacity(0.8),
                          child: ListTile(
                            title: Text(atlist[index]['f_name']),
                           
                          ));
                    }),
              ),
           
            ],
          ),
        ),
      ]),
    );
  }
}
