import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class HeaderEdit extends StatefulWidget {
  final int fid;
   final int? cid;
  final String coursename;
  final String ccode;

 const HeaderEdit({
  Key? key,
  required this.cid,
  required this.ccode,
  required this.coursename,
  required this.fid,
}) : super(key: key);


  @override
  State<HeaderEdit> createState() => _HeaderEditState();
}

class _HeaderEditState extends State<HeaderEdit> {
  TextEditingController durationController = TextEditingController();
  TextEditingController degreeController = TextEditingController();

  TextEditingController noOfQuestionsController = TextEditingController();

  String selectedtermValue = '';
  DateTime _dateTime = DateTime.now();
  String selectedDate = '';

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
     
      await Future.wait([loadSession(), loadTeachers()]);
      if (sid != null) {
        loadPaperHeader(widget.cid!, sid);
  
        setState(() {}); 
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
      List<dynamic> teachersList = await APIHandler().loadTeachersByCourseId(widget.cid!);
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
  child: customElevatedButtonForThisScreen(
    onPressed: () async {

 if(noOfQuestionsController.text==''|| durationController.text==''|| degreeController.text==''
                        ||selectedtermValue==''){
                          showErrorDialog(context, 'Please provide all necessary information');
                        }else{

      // Prepare the header data to be updated
      Map<String, dynamic> headerData = {
    "degree": degreeController.text,
    "duration": durationController.text,
    "term": selectedtermValue,
    "NoOfQuestions": int.parse(noOfQuestionsController.text),
    "c_id": widget.cid,
  };

  // Add exam_date only if it is different from the initial value
  if (_dateTime != DateTime.now()) {
    headerData["exam_date"] = _dateTime.toIso8601String();
  }


      // Make the API call to update the paper header
      try {
        int statusCode = await APIHandler().updateHeader(widget.cid!, headerData);
        if (statusCode == 200) {
         
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(); // Close the dialog after 2 seconds
              });
              return const AlertDialog(
                title: Text('Paper Updated'),
              );
            },
          );
          degreeController.clear();
          durationController.clear();
          noOfQuestionsController.clear();
          loadPaperHeader(widget.cid!, sid);
          setState(() {});
        } else {
   if(mounted){
  showErrorDialog(context, 'Failed to update paper $statusCode');
   }
        
        }
      } catch (e) {
      if(mounted){
showErrorDialog(context, 'Error: $e');
      }
        
      }
                        }         
                        },
    buttonText: 'Update',
  ),
)
                      
              ],
          
          ),
        ]));
  }
}