
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/course.dart';
import 'package:biit_directors_dashbooard/DATACELL/editCourse.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}
class _CourseDetailState extends State<CourseDetail> {
  List<dynamic> clist = [];
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCourseData();
  }

  Future<void> loadCourseData() async {
    try{
     clist=await APIHandler().loadCourse();
      setState(() {
      });
    }
    catch(e){
  if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error loading course'),
            content: Text(e.toString()),
          );
        },
      );
      }
    }
  }

Future<void> updateStatus(int id, bool newStatus) async {
  try {
    dynamic code = await APIHandler().updateCourseStatus(id, newStatus);
    if (mounted) {
      if (code == 200) {
        loadCourseData();
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const AlertDialog(
        //       title: Text('Status Changed'),
        //     );
        //   },
        // );
        // Future.delayed(const Duration(seconds: 1), () {
        //   Navigator.of(context).pop();
        // });
      } else {
        throw Exception('Non-200 response code');
      }
    }
  } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error changing status of course'),
            content: Text(e.toString()), // Optionally show the error message
          );
        },
      );
  }
}

   Future<void> searchCourseData(String query) async {
    try {
      if (query.isEmpty) {
       loadCourseData();
        return;
      }
     clist=await APIHandler().searchCourse(query);
     setState(() {
     });
    } catch (e) {
      if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error searching course'),
            content: Text(e.toString()),
          );
        },
      );
       Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      }
     
    }
  }


  void editCourseRecords(int cid, dynamic data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCourse(cid, data),
      ),
    );
    loadCourseData();
  
  }

  void add() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CourseForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: customAppBar(context: context, title: 'Course Details'),
      body: 
      SizedBox(
           height: double.infinity, 
        child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/bg.png',
                    fit: BoxFit.cover,
                  ),
                ),Column(
          children: [
            SizedBox(
              width: 300,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: search,
                  onChanged: (value) async{
                    searchCourseData(value);
                  },
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Icon(Icons.search),
                      labelText: 'Search Course',
                      border: OutlineInputBorder(),
                      filled: false),
                ),
              ),
            ),
            
                Expanded(
                  child: ListView.builder(
                    itemCount: clist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                          title: Text(
                            clist[index]['c_title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(clist[index]['c_code']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async{
                                  editCourseRecords(
                                      clist[index]['c_id'], clist[index]);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              Switch(
                                  value: clist[index]['status'] == 'enabled',
                                  onChanged: (newValue) async{
                                 
                                      await updateStatus(
                                          clist[index]['c_id'], newValue);
                                             setState(() {
                                    });
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: customButtonColor,
        onPressed: add,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
