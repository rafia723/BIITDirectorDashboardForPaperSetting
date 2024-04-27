import 'dart:convert';
import 'package:biit_directors_dashbooard/HOD/CloCheck.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:flutter/material.dart';

class AssignedtoDetails extends StatefulWidget {
  final String courseTitle;
  final String ccode;
  final int cid;
  const AssignedtoDetails(
      {Key? key,
      required this.courseTitle,
      required this.ccode,
      required this.cid})
      : super(key: key);

  @override
  State<AssignedtoDetails> createState() => _AssignedtoDetailsState();
}

class _AssignedtoDetailsState extends State<AssignedtoDetails> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  List<dynamic> atlist = [];

  Future<void> loadAssignedToCourses(int id) async {
    try {
      Uri uri =
          Uri.parse("${APIHandler().apiUrl}AssignedCourses/getAssignedTo/$id");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        atlist = jsonDecode(response.body);
        setState(() {});
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Data not found for the given id'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  'Failed to load assigned faculty. Please try again later.'),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('An error occurred. Please try again later.'),
          );
        },
      );
    }
  }

  Future<void> deleteAssignedToCourses(int id) async {
    try {
      Uri url = Uri.parse(
          '${APIHandler().apiUrl}AssignedCourses/deleteAssignedCourse/$id');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        loadAssignedToCourses(widget.cid);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Deleted Successfully'),
            );
          },
        );
        Future.delayed(const Duration(milliseconds: 500), () {
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
            title: Text('Error deleting Assigned Faculty'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    loadAssignedToCourses(widget.cid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'View Faculty',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      body: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/HOD.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15.0), // Adjust as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.courseTitle,
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
                height: 80,
              ),
              const Center(
                child: Text(
                  'Assigned To:',
                  style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
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
                            trailing: IconButton(
                                onPressed: () {
                                  
                                  showConfirmationDialog(context, title: 'Confirmation', content: 'Are you sure you want to unassign from ${atlist[index]['f_name']}', 
                                  onConfirm:
                                   (){
                              deleteAssignedToCourses(atlist[index]['ac_id']);
                                   });
                                },
                                icon: const Icon(Icons.delete)),
                          ));
                    }),
              ),
              Center(
                  child: customElevatedButton(
                      onPressed: () {
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  
                                  CloCheckingScreen(courseTitle: widget.courseTitle,ccode: widget.ccode,cid:widget.cid),
                                ),
                              );
                      }, buttonText: 'Manage CLOs'))
            ],
          ),
        ),
      ]),
    );
  }
}
