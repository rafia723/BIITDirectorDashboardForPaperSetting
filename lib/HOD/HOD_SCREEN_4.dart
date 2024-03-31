import 'dart:convert';
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/HOD/hod.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignCoursetoFaculty extends StatefulWidget {
  final String? facultyname;
   final int? fid;
  const AssignCoursetoFaculty({Key? key, this.facultyname,this.fid})
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

  Future<void> loadFaculty() async {
    try {
      Uri uri = Uri.parse(
          "${APIHandler().apiUrl}Faculty/getFacultyWithEnabledStatus");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        flist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load Faculty');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error loading faculty: $e'), // Show error details
          );
        },
      );
    }
  }
  Future<void> loadCourse() async {
    try {
      Uri uri =
          Uri.parse('${APIHandler().apiUrl}Course/getCourseWithEnabledStatus');
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


 Future<void> loadUnAssignedCourses(int? id) async {
    try {
      Uri uri =
          Uri.parse('${APIHandler().apiUrl}AssignedCourses/getUnAssignedCourses/$id');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
      
            unAssignedCoursesList = jsonDecode(response.body);
       setState(() {
         
       });
      } else {
        throw Exception('Failed to load unassignedcourse');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading unassignedcourse'),
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
          '${APIHandler().apiUrl}Course/searchCourseWithEnabledStatus?search=$query');
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


  @override
  void initState() {
    super.initState();
    loadFaculty();
    if(widget.fid==null&&selectedFacultyId==null){
      loadCourse();
    }else{
    loadUnAssignedCourses(widget.fid ?? int.tryParse(selectedFacultyId??''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Assign Courses',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HOD()));
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/HOD.png',
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                      decoration: BoxDecoration(
                        color: Colors.white, // Set background color to white
                        borderRadius: BorderRadius.circular(
                            5), // Optional: Add border radius
                      ),
                      child: DropdownButton<String>(
                        hint:  Text(widget.facultyname?? ' Select Teacher '),
                        isExpanded: true,
                        elevation: 9,
                        value: selectedFacultyId,
                        items: flist.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['f_id'].toString(),
                             onTap: () {
                              setState(() {
                                selectedFacultyText = e['f_name'];
                              });
                            },
                            child: Text(
                              e['f_name'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFacultyId = newValue!;
                            loadUnAssignedCourses(int.tryParse(selectedFacultyId??''));
                            
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                   widget.facultyname?? selectedFacultyText ?? "--------------", // Show selected faculty
                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                ),
                const Text(
                  'Courses',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: search,
                    onChanged: (value) {
                        searchCourses(value);
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      labelText: 'Search Courses',
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: widget.fid!=null ?  ListView.builder(
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
                          title:
                           Text(
                            unAssignedCoursesList[index]['c_title'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Checkbox(
                            value: checkedCourses[unAssignedCoursesList[index]['c_title']] ?? false,
                            checkColor: Colors.black,
                           onChanged: (value)
                           {
                              setState(() {
                                value=checkedCourses[unAssignedCoursesList[index]['c_title']] = value!;
                              });
                           }),
                        
                        ),
                      );
                    },
                ):ListView.builder(
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
                          title:
                           Text(
                            clist[index]['c_title'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Checkbox(
                            value: checkedCourses[clist[index]['c_title']] ?? false,
                            checkColor: Colors.black,
                           onChanged: (value)
                           {
                              setState(() {
                                value=checkedCourses[clist[index]['c_title']] = value!;

                              });
                           }),
                        
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
