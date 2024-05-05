import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaperHeader extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  const PaperHeader(
      {super.key,
      required this.cid,
      required this.ccode,
      required this.coursename});

  @override
  State<PaperHeader> createState() => _PaperHeaderState();
}

class _PaperHeaderState extends State<PaperHeader> {
  TextEditingController durationController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController totalMarksController = TextEditingController();
  TextEditingController noOfQuestionsController = TextEditingController();
  String selectedSessionValue = '';
  String selectedtermValue = '';
  DateTime _dateTime = DateTime.now();
  int _selectedYear = DateTime.now().year;

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100))
        .then((value) => setState(() {
              _dateTime = value!;
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
                const Row(
                  children: [
                    Text(
                      '  Status:',style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
          
              const SizedBox(
                height: 10,
              ),
              const Text(
                '  Teachers:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       const Text(
              //         '  Course Title:',
              //         style:
              //             TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //       ),
              //       Text(
              //         '    ${widget.coursename}',
              //         style: const TextStyle(fontSize: 16),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     const Text(
              //       '  Course Code:',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       '    ${widget.ccode}',
              //       style: const TextStyle(fontSize: 16),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
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
              Row(
                children: [
                  const Text(
                    '  Total Marks: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        controller: totalMarksController,
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
                '  Session:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Radio(
                      value: 'Fall',
                      groupValue: selectedSessionValue,
                      onChanged: (val) {
                        setState(() {
                          selectedSessionValue = val.toString();
                        });
                      }),
                  const Text('Fall'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: 'Spring',
                      groupValue: selectedSessionValue,
                      onChanged: (val) {
                        setState(() {
                          selectedSessionValue = val.toString();
                        });
                      }),
                  const Text('Spring'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: 'Summer',
                      groupValue: selectedSessionValue,
                      onChanged: (val) {
                        setState(() {
                          selectedSessionValue = val.toString();
                        });
                      }),
                  const Text('Summer'),
                ],
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
                      onChanged: (val) {
                        setState(() {
                          selectedtermValue = val.toString();
                        });
                      }),
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
                  const SizedBox(width: 10,),
                  const Text(
                    '  Year: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10,),
                  DropdownButton<int>(
                    value: _selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                      });
                    },
                    items: List.generate(
                      2101 - 2000,
                      (index) => DropdownMenuItem<int>(
                        value: 2000 + index,
                        child: Text((2000 + index).toString()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                  child: customElevatedButton(
                      onPressed: () {}, buttonText: 'Save'))
            ],
          ),
        ]));
  }
}
