
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class ManageClos extends StatefulWidget {
   final String coursename;
final String ccode;
final int? cid;
 const ManageClos(
      {Key? key,
      required this.coursename,
      required this.ccode,
      required this.cid,})
      : super(key: key);

  @override
  State<ManageClos> createState() => _ManageClosState();
}

class _ManageClosState extends State<ManageClos> {
  List<dynamic> clist = [];
  List<dynamic> clolist = [];
  String? selectedCourse; // Nullable initially
  int? selectedCourseId;
  String? selectedCourseCode;
  TextEditingController desc = TextEditingController();
  bool isUpdateMode = false;
  int? selectedCloID;

  

  Future<void> loadCoursesofSenior() async {
    try {
      clist=await APIHandler().loadCoursesWithSeniorRole();
        setState(() {});
      } 
     catch (e) {
      if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }

   Future<void> loadClo(int cid) async {
    try {
      clolist=await APIHandler().loadClo(cid);
        setState(() {});
      } 
     catch (e) {
      if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }

  

  @override
  void initState() {
    super.initState();
    loadCoursesofSenior();
    selectedCourseId=widget.cid;
    loadClo(widget.cid!);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'CLOs'),
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
                    'Course',
                    style: TextStyle(
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
                          color: const Color.fromARGB(26, 112, 106, 106),
                          borderRadius: BorderRadius.circular(
                              5), // Optional: Add border radius
                        ),
                        child: DropdownButton<String>(
                          
                          hint:  Text(widget.coursename),
                          isExpanded: true,
                          elevation: 9,
                          value: selectedCourseCode,
                          items: clist.map((e) {
                            return DropdownMenuItem<String>(
                              value: e['c_code'],
                              onTap: () {
                                setState(() {
                                  //  selectedCourse = e['c_title'];
                                  selectedCourseId = e['c_id'];
                                });
                              },
                              child: Text(
                                e['c_title'],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCourseCode = newValue!;
                              loadClo(selectedCourseId!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.white70,
                        filled: true,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      controller: desc,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: customElevatedButton(
                            onPressed: () async {
                              if (isUpdateMode == false) {
                                int code = await APIHandler().addClo(
                                    desc.text, selectedCourseId!, 'disapproved');
                                if (code == 200) {
                                  if(mounted){
                                    showSuccesDialog(context, 'Inserted');
                                    Future.delayed(const Duration(seconds: 1),
                                          () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog after 1 second
                                      });
                                  }
                                  desc.clear();
                                  setState(() {
                                    selectedCourse = null;
                                    loadClo(selectedCourseId!);
                                  });
                                } else {
                                  if(mounted){
                                   showErrorDialog(context, 'Error...');
                                  }
                                }
                              } else {
                                int cloid =selectedCloID!; // Use the faculty ID provided in the widget
                                Map<String, dynamic> cloData = {
                                  "clo_text": desc.text,
                                  "c_id": selectedCourseId,
                                };
                                int code = await APIHandler()
                                    .updateClo(cloid, cloData);
                                if (code == 200) {
                                  if(mounted){
                                    showSuccesDialog(context, 'Updated');
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog after 1 second
                                      });
                                  }
                                 
                                  desc.clear();
                                  setState(() {
                                    selectedCourse = null;
                                    loadClo(selectedCourseId!);
                                     isUpdateMode = false;
                                  });
                                } else {
                                   if(mounted){
                                   showErrorDialog(context, 'Error...');
                                  }
                                }
                              }
                            },
                            buttonText: isUpdateMode ? 'Update' : 'Add'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: clolist.length,
                        itemBuilder: (context, index) {
                          return Card(
                            // elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                  title: Text('Clo ${index+1}',),
                                  subtitle: Text(clolist[index]['clo_text'],),
                                  trailing: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              // Find the index of the item with matching c_id
                                              int indexx = clist.indexWhere((e) =>
                                                  e['c_id'] ==
                                                  clolist[index]['c_id']);
                                              setState(() {
                                                selectedCloID =
                                                    clolist[index]['clo_id'];
                                              });
                                              if (indexx != -1) {
                                                // If item with matching c_id is found
                                                setState(() {
                                                  // Set selectedCourseId
                                                  selectedCourseId =
                                                      clist[indexx]['c_id'];
                                                  // Set selectedCourse based on index
                                                  selectedCourse =
                                                      clist[indexx]['c_code'];
                                                  // Toggle the update mode
                                                  isUpdateMode = true;
                                                });
                                              }
                                              // Set CLO text to desc TextFormField
                                              desc.text = clolist[index]['clo_text'];
                                            },
                                            icon: const Icon(Icons.edit)),
                                            Text(clolist[index]['status'],style: TextStyle(color: 
                                            clolist[index]['status']=='pending'?Colors.blue:clolist[index]['status']=='approved'?Colors.green:clolist[index]['status']=='disapproved'?Colors.red:Colors.black),),
                                      ],
                                    ),
                                  )));
                        }),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
