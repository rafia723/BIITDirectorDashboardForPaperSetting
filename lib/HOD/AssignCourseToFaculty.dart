import 'dart:convert';
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignCoursetoFaculty extends StatefulWidget {
  final String? facultyname;
  final int? fid;
  const AssignCoursetoFaculty({Key? key, this.facultyname, this.fid})
      : super(key: key);

  @override
  State<AssignCoursetoFaculty> createState() => _AssignCoursetoFacultyState();
}

class _AssignCoursetoFacultyState extends State<AssignCoursetoFaculty> {
  List<dynamic> clist = [];
  List<dynamic> unAssignedCoursesList = [];
  late List<dynamic> flist = [];
  String? selectedFacultyId;
  String? selectedFacultyText; // Nullable initially
  TextEditingController search = TextEditingController();
  Map<String, bool> checkedCourses = {};
  String? checkedCourseId;

 
  Future<void> loadFaculty() async {
    try {
        flist = await APIHandler().loadFacultyWithEnabledStatus();
        setState(() {});
      } 
     catch (e) {
      if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }
   Future<void> loadCourse() async {
    try {
     
        clist = await APIHandler().loadCourseWithEnabledStatus();
        setState(() {});
      
    } catch (e) {
      if(mounted){
   showErrorDialog(context, e.toString());
      }
     
    }
  }
 

  Future<void> loadUnAssignedCourses(int? id) async {
    try {
        unAssignedCoursesList = await APIHandler().loadUnAssignedCourses(id);
        setState(() {});
      }
     catch (e) {
     if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }


  Future<void> assignCourse(int cid, int fid) async {
    String url = "${APIHandler().apiUrl}AssignedCourses/assignCourse/$cid/$fid";
    var assignCourseobj = {
      'c_id': cid,
      'f_id': fid,
    };
    var json = jsonEncode(assignCourseobj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    if (response.statusCode == 200) {
      loadUnAssignedCourses(fid);
      setState(() {});
      if (mounted) {
        showSuccesDialog(context, 'Course Assigned Successfully');
      }
    }
  }

  
   Future<void> searchCourses(String query) async {
    try {
      if (query.isEmpty) {
        loadCourse();
        return;
      }
        clist = await APIHandler().searchCourseWithEnabledStatus(query);
        setState(() {});
      
    } catch (e) {
       if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }
Future<void> searchUnAssignedCourses(String query) async {
  try {
    if (query.isEmpty) {
      loadUnAssignedCourses(widget.fid ?? int.tryParse(selectedFacultyId ?? '') ?? 0);
      return;
    }

    unAssignedCoursesList = await APIHandler().searchUnAssignedCourses(query, widget.fid ?? int.tryParse(selectedFacultyId ?? '') ?? 0);
    setState(() {});
  } catch (e) {
    if (mounted) {
      showErrorDialog(context, e.toString());
    }
  }
}

  @override
  void initState() {
    super.initState();
    loadFaculty();
    if (widget.fid == null && selectedFacultyId == null) {
      loadCourse();
    } else {
      loadUnAssignedCourses(
          widget.fid ?? int.tryParse(selectedFacultyId ?? '') ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Assign Courses'),
      body: Stack(
        fit: StackFit.expand,
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
                const Text(
                  'Teacher Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 350),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(26, 112, 106, 106),
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Add border radius
                      ),
                      child: DropdownButton<String>(
                        hint: Text(widget.facultyname ?? ' Select Teacher '),
                        isExpanded: true,
                        elevation: 9,
                        value: selectedFacultyId,
                        items: flist.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['f_id'].toString(),
                            onTap: () async {
                              setState(() {
                                selectedFacultyId = e['f_id'].toString();
                                selectedFacultyText = e['f_name'];
                              });
                              await loadUnAssignedCourses(
                                  int.tryParse(e['f_id'].toString()) ?? 0);
                              setState(() {});
                            },
                            child: Text(
                              e['f_name'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedFacultyId = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    widget.facultyname ??
                        selectedFacultyText ??
                        "--------------", // Show selected faculty
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const Text(
                  'Courses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: search,
                    onChanged: (value) async {
                      if(selectedFacultyId == null && widget.fid == null){
                            await searchCourses(value);
                      }
                      else if(selectedFacultyId != null || widget.fid != null){
                        await searchUnAssignedCourses(value);
                        setState(() {
                          
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      labelText: 'Search Courses',
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: selectedFacultyId != null || widget.fid != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: unAssignedCoursesList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white.withOpacity(0.8),
                              child: ListTile(
                                  title: Text(
                                    unAssignedCoursesList[index]['c_title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: Checkbox(
                                    value: checkedCourses.containsKey(
                                            unAssignedCoursesList[index]['c_id']
                                                .toString())
                                        ? checkedCourses[
                                            unAssignedCoursesList[index]['c_id']
                                                .toString()]
                                        : false,
                                    onChanged: (newValue) async {
                                      setState(() {
                                        checkedCourses[
                                            unAssignedCoursesList[index]['c_id']
                                                .toString()] = newValue!;
                                      });
                                      if (newValue != null && newValue) {
                                        try {
                                          await assignCourse(
                                              unAssignedCoursesList[index]
                                                  ['c_id'],
                                              widget.fid ??
                                                  int.tryParse(
                                                      selectedFacultyId ??
                                                          '') ??
                                                  0);
                                        } catch (e) {
                                          if(mounted){
                                            showErrorDialog(context, e.toString());
                                          }
                                        }
                                      }
                                    },
                                  )),
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Checkbox(
                                  value: clist[index]['c_title'] == 'true',
                                  checkColor: Colors.black,
                                  onChanged: (newValue) async {
                                    if (selectedFacultyId == null) {
                                      showErrorDialog(context,
                                          'Select teacher name from dropdown');
                                    } else {
                                      setState(() {
                                        checkedCourseId =
                                            clist[index]['c_id'].toString();
                                        loadUnAssignedCourses(
                                            int.parse(selectedFacultyId ?? ''));
                                      });
                                      if (checkedCourseId != null &&
                                          newValue != null &&
                                          newValue) {
                                        try {
                                          await assignCourse(
                                              int.parse(checkedCourseId ?? ''),
                                              int.parse(
                                                  selectedFacultyId ?? ''));
                                        } catch (e) {
                                          if(mounted){
                                            showErrorDialog(context, e.toString());
                                          }
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


