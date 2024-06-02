

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/paperSetting.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class PaperHeader extends StatefulWidget {
  final int cid;
  final String coursename;
  final String ccode;
  final int fid;
 const PaperHeader({
  Key? key,
  required this.cid,
  required this.ccode,
  required this.coursename,
  required this.fid,
}) : super(key: key);

  @override
  State<PaperHeader> createState() => _PaperHeaderState();
}

class _PaperHeaderState extends State<PaperHeader> {
  TextEditingController durationController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
 // TextEditingController totalMarksController = TextEditingController();
  TextEditingController noOfQuestionsController = TextEditingController();
 // String selectedSessionValue = '';
  String selectedtermValue = '';
  DateTime _dateTime = DateTime.now();
  String selectedDate = '';
 // int _selectedYear = DateTime.now().year;
  List<dynamic> teachers = [];
  dynamic p_status= 'pending';
  dynamic sid;
   List<dynamic> list=[];
   bool midTerm=false;
   bool midAndApproved=false;
   bool finalTerm=false;
   dynamic status;


   Widget customElevatedButtonForThisScreen({
  required VoidCallback onPressed,
  required String buttonText,
  bool isEnabled = true, // New parameter to determine if the button should be enabled
  Color customColor = const Color.fromARGB(255, 78, 223, 180),
}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(customColor),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
    onPressed: isEnabled ? onPressed : null, // Disable the button if isEnabled is false
    child: Text(buttonText),
  );
}

  @override
  void initState() {
    super.initState();
    loadTeachers();
    initializeData();
  }

    Future<void> initializeData() async {
    try {
      // Making loadSession and loadTeachers calls in parallel
      await Future.wait([loadSession(), loadTeachers()]);
      if (sid != null) {
        loadPaperHeader(widget.cid, sid);
     //   status = await APIHandler().loadPaperStatus(widget.cid, sid);
        setState(() {}); // Update the UI after loading the status
      }
    } catch (e) {
      if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }


   Future<void> loadPaperHeader(int cid, int sid) async {
    try {
      list = await APIHandler().loadPaperHeader(cid, sid);
     for (var item in list) {
    String term = item['term']!.toLowerCase();
     status = item['status']!.toLowerCase();
    if (term == 'mid'&&(status=='approved'||status=='printed')) {
      midAndApproved=true;
    }
     if (term == 'mid') {
      midTerm = true;
    }
    if (term == 'final') {
      finalTerm = true;
    }
    // If both are true, we can exit the loop early
    if (midTerm && finalTerm) {
      break;
    }
  }
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error..'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }


  Future<void> loadTeachers() async {
    try {
      List<dynamic> teachersList = await APIHandler().loadTeachersByCourseId(widget.cid);
      setState(() {
        teachers = teachersList; // Correctly update the state with the loaded teachers
      });
    } catch (e) {
       if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }

 Future<void> loadSession() async {
    try {
      sid=await APIHandler().loadFirstSessionId();
      
      setState(() {
      });
    } catch (e) {
      if(mounted){
        showErrorDialog(context, e.toString());
      }
     
    }
  }
  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100))
        .then((value) => setState(() {
              // _dateTime = value!;
              //    selectedDate = '${DateTime(_dateTime.day, _dateTime.month, _dateTime.year)}';
              _dateTime = DateTime(value!.year, value.month, value.day);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(context: context, title: 'Paper Header'),
        body: Stack(children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

              //      const SizedBox(height: 30,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     const Text(
              //       '  Status: ',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       p_status == null ? 'Loading...' : '$p_status    ',
              //       style: TextStyle(
              //           fontSize: 16,
              //           color: p_status == "approved" || p_status == "printed"
              //               ? Colors.green
              //               : p_status == "rejected"
              //                   ? Colors.red
              //                   : Colors.black,
              //           fontWeight: FontWeight.w500),
              //     ),
              //   ],
              // ),

              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      '  Teacher: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      teachers.isEmpty
                          ? 'Loading...' // Display loading text
                          : teachers
                              .map<String>(
                                  (teacher) => teacher['f_name'] as String)
                              .join(
                                  ', '), // Extract teacher names and join with commas
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text(
                    '  Date of Exam:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '    ${_dateTime.day}/${_dateTime.month}/${_dateTime.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                      onPressed: _showDatePicker,
                      icon: const Icon(Icons.calendar_month)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '  Duration:       ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                        maxLines: 1,
                        controller: durationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    '  Degree:         ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                        maxLines: 1,
                        controller: degreeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     const Text(
              //       '  Total Marks: ',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     SizedBox(
              //       height: 35,
              //       width: 200,
              //       child: TextFormField(
              //           keyboardType: TextInputType.number,
              //           maxLines: 1,
              //           controller: totalMarksController,
              //           decoration: const InputDecoration(
              //             border: OutlineInputBorder(
              //               borderRadius:
              //                   BorderRadius.all(Radius.circular(8.0)),
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // const Text(
              //   '  Session:',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              // ),
              // Row(
              //   children: [
              //     const SizedBox(
              //       width: 40,
              //     ),
              //     Radio(
              //         value: 'Fall',
              //         groupValue: selectedSessionValue,
              //         onChanged: (val) {
              //           setState(() {
              //             selectedSessionValue = val.toString();
              //           });
              //         }),
              //     const Text('Fall'),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Radio(
              //         value: 'Spring',
              //         groupValue: selectedSessionValue,
              //         onChanged: (val) {
              //           setState(() {
              //             selectedSessionValue = val.toString();
              //           });
              //         }),
              //     const Text('Spring'),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Radio(
              //         value: 'Summer',
              //         groupValue: selectedSessionValue,
              //         onChanged: (val) {
              //           setState(() {
              //             selectedSessionValue = val.toString();
              //           });
              //         }),
              //     const Text('Summer'),
              //   ],
              // ),
              const Text(
                '  Term:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Radio(
                      value: 'Mid',
                      groupValue: selectedtermValue,
                      onChanged: (val) {
                        setState(() {
                          selectedtermValue = val.toString();
                        });
                      }),
                  const Text('Mid'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: 'Final',
                      groupValue: selectedtermValue,
                      onChanged: midAndApproved?(val) {
                        setState(() {
                          selectedtermValue = val.toString();
                        });
                      }:null),
                  const Text('Final'),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '  No. of Questions: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 35,
                    width: 50,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        controller: noOfQuestionsController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                  child: customElevatedButton(
                      onPressed: () {
                        if(noOfQuestionsController.text==''|| durationController.text==''|| degreeController.text==''
                        ||selectedtermValue==''||_dateTime==null){
                          showErrorDialog(context, 'Please provide all necessary information');
                        }else{

                        
                         APIHandler()
                            .addPaperHeader(
                          durationController.text,
                          degreeController.text,
                       //   int.parse(totalMarksController.text),
                          selectedtermValue,
                         // _selectedYear,
                          _dateTime,
                        //  selectedSessionValue,
                          int.parse(noOfQuestionsController.text),
                          widget.cid,
                          sid,
                          p_status,
                        )
                            .then((code) {
                          if (code == 200) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog after 2 seconds
                                });
                                return const AlertDialog(
                                  title: Text('Added'),
                                );
                              },
                            // ).then((value) {
                            //     Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //   builder: (context) => PaperSetting(
                            //     fid: widget.fid,
                            //       cid: widget.cid,
                            //       ccode: widget.ccode,
                            //       coursename: widget.coursename,
                            // )));
                            
                           // });
                            );
                           durationController.clear();
                           degreeController.clear();
                         //  totalMarksController.clear();
                           noOfQuestionsController.clear();
                           loadPaperHeader(widget.cid, sid);
                          setState(() {
                            
                          });
                          }
                        // } else if (code == 409) {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) {
                        //         Future.delayed(const Duration(seconds: 4), () {
                        //           Navigator.of(context)
                        //               .pop(); // Close the dialog after 2 seconds
                        //         });
                        //         return  AlertDialog(
                        //           title: Text(
                        //               'Paper term $selectedtermValue and session $selectedSessionValue added for the course and session'),
                        //         );
                        //       },
                        //     );

                          
                           else if (code == 400) {
                            if(mounted){
                              showErrorDialog(context, '$selectedtermValue already exists for this course');
                            }
                            //  Navigator.pushReplacement(
                            // context,
                            // MaterialPageRoute(
                            //   builder: (context) => PaperSetting(
                            //     fid: widget.fid,
                            //       cid: widget.cid,
                            //       ccode: widget.ccode,
                            //       coursename: widget.coursename,
                            // )));
                           
                          } 
                        else {
                          if(mounted){
                            showErrorDialog(context, 'Error return with status code $code');
                          }
                            
                          }
                        });
                        }
                      },
                      buttonText: 'Save')),
                        const SizedBox(height: 30,),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('   These terms headers already created'),
                      ),
                      const SizedBox(height: 10,),
                      if (midTerm && finalTerm) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: customElevatedButtonForThisScreen(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaperSetting(
          fid: widget.fid,
          cid: widget.cid,
          ccode: widget.ccode,
          coursename: widget.coursename,
        ),
      ),
    );
  },
  buttonText: 'Mid',
  isEnabled: !midAndApproved, // Disable the button if midAndApproved is true
),
                    ),
                    const SizedBox(width: 24),
                    SizedBox(
                      width: 100,
                      child: customElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaperSetting(
                                fid: widget.fid,
                                cid: widget.cid,
                                ccode: widget.ccode,
                                coursename: widget.coursename,
                              ),
                            ),
                          );
                        },
                        buttonText: 'Final',
                      ),
                    ),
                  ],
                ),
              ] else if (midTerm) ...[
                Center(
                  child: SizedBox(
                    width: 100,
                    child: customElevatedButtonForThisScreen(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaperSetting(
          fid: widget.fid,
          cid: widget.cid,
          ccode: widget.ccode,
          coursename: widget.coursename,
        ),
      ),
    );
  },
  buttonText: 'Mid',
  isEnabled: !midAndApproved, // Disable the button if midAndApproved is true
),
                  ),
                ),
              ] else if (finalTerm) ...[
                Center(
                  child: SizedBox(
                    width: 100,
                    child: customElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaperSetting(
                              fid: widget.fid,
                              cid: widget.cid,
                              ccode: widget.ccode,
                              coursename: widget.coursename,
                            ),
                          ),
                        );
                      },
                      buttonText: 'Final',
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(),
              ],
            ],
          ),
        ]));
  }
}
