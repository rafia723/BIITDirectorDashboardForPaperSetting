import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/course.dart';
import 'package:biit_directors_dashbooard/DATACELL/datacell.dart';
import 'package:biit_directors_dashbooard/DATACELL/editCourse.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseDetail extends StatefulWidget {
  const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}
Color customColor = const Color.fromARGB(255, 78, 223, 180);
class _CourseDetailState extends State<CourseDetail> {
  List<dynamic> clist = [];

  @override
  void initState() {
    super.initState();
    loadCourse();
  }

  TextEditingController search = TextEditingController();
  Future<void> updateStatus(int id, bool newStatus) async {
    String status = newStatus ? 'enabled' : 'disabled';
    Uri url =
        Uri.parse('${APIHandler().apiUrl}Course/editCourseStatus/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
        loadCourse();
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Status Changed'),
            );
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Error....'),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error changing status of Course'),
          );
        },
      );
    }
  }

  Future<void> searchCourses(String query) async {
    try {
      if (query.isEmpty) {
        loadCourse();
        return;
      }
      Uri url = Uri.parse(
          '${APIHandler().apiUrl}Course/searchCourse?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to search courses');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error searching courses'),
          );
        },
      );
    }
  }
 

  void editCourseRecords(int cid, dynamic data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCourse(cid, data),
      ),
    );
    loadCourse();
  
  }

   
  Future<void> loadCourse() async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Course/getCourse');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load course');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading course'),
          );
        },
      );
    }
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
        appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Course Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Datacell()));
          },
        ),
         ),
      body: 
      SizedBox(
           height: double.infinity, 
        child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/datacell.png',
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
                  onChanged: (value) {
                    searchCourses(value);
                  },
                  decoration: const InputDecoration(
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
                                onPressed: () {
                                  // Handle edit
                                  editCourseRecords(
                                      clist[index]['c_id'], clist[index]);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              Switch(
                                  value: clist[index]['status'] == 'enabled',
                                  onChanged: (newValue) {
                                    setState(() {
                                      updateStatus(
                                          clist[index]['c_id'], newValue);
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
        backgroundColor: customColor,
        onPressed: add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
