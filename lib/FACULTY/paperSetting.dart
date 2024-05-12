import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaperSetting extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  final List<dynamic> teachers;
  final DateTime date;
  final String duration;
  final String degree;
  final String tMarks;
  final String session;
    final String term;
    final int questions;
    final int year;
  const PaperSetting(
      {super.key,
       this.cid,
      required this.ccode,
      required this.coursename,
       required this.teachers,
      required this.date,
     required this.duration,
     required this.degree,
      required this.tMarks,
      required this.session,
         required this.term,
            required this.questions,
               required this.year,
      });

  

  @override
  State<PaperSetting> createState() => _PaperSettingState();
}

class _PaperSettingState extends State<PaperSetting> {
  TextEditingController questionController=TextEditingController();
  TextEditingController marksController=TextEditingController();
  String dropdownValue = 'Easy';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Paper Setting'),
      body: Stack(
        children: [
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                 Container(
                   width: 70, // Adjust the width of the circular logo
                   height: 70, // Adjust the height of the circular logo
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     border: Border.all(
                           color: Colors.white, // Adjust the border color
                           width: 1.0, // Adjust the border width
                     ),
                     image: const DecorationImage(
                           image: AssetImage('assets/images/biit.png'), // Replace with the path to your logo image
                           fit: BoxFit.fitWidth,
                     ),
                   ),
                 ),
                  Text(
                   'Barani Institute of Information Technology\n       PMAS Arid Agriculture University,\n                 Rawalpindi,Pakistan\n      ${widget.session} ${widget.year} : ${widget.term} Term Examination',
                   style: const TextStyle(fontSize: 11.5,fontWeight: FontWeight.bold),
                 ),
                 Container(
                   width: 70, // Adjust the width of the circular logo
                   height: 70, // Adjust the height of the circular logo
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     border: Border.all(
                           color: Colors.white, // Adjust the border color
                           width: 1.0, // Adjust the border width
                     ),
                     image: const DecorationImage(
                           image: AssetImage('assets/images/biit.png'), // Replace with the path to your logo image
                           fit: BoxFit.fitWidth,
                     ),
                   ),
                 ),
                             ],
                           ),
              ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black)),
              child: GestureDetector(
                onTap: () => {
                  Navigator.pop(context),
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                          const Text('Course Title: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                         Expanded(child: Text(widget.coursename,
                        //  overflow: TextOverflow.ellipsis, // Optionally, set overflow behavior
                        //      maxLines: 5, 
                             style: const TextStyle(fontSize: 12),)
                         ),
                          const Text('Course Code: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                        Expanded(child: Text(widget.ccode,style: const TextStyle(fontSize: 12),)),
                      ],
                    ),
                       
                 Row(
                   children: [
                     const Text('Date of Exam: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                      Expanded(child: Text('${widget.date.day}/${widget.date.month}/${widget.date.year}',style: const TextStyle(fontSize: 12)),),
                         const Text('Duration: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                     Expanded(child: Text(widget.duration,style: const TextStyle(fontSize: 12),)),
                   ],
                 ),
                   Row(
                   children: [
                    const Text('Degree Program: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                      Expanded(child: Text(widget.degree,style: const TextStyle(fontSize: 12))),
                            const Text('Total Marks: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                     Expanded(child: Text(widget.tMarks,style: const TextStyle(fontSize: 12),)),
                   ],
                 ),
                  Row(
                   children: [
                       const Text('Teachers Name: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                    Expanded(
                  child: Text(widget.teachers.isEmpty
                      ? 'Loading...' // Display loading text
                      : widget.teachers
                          .map<String>((teacher) => teacher['f_name'] as String)
                          .join(', '),
                    // overflow: TextOverflow.ellipsis, 
                    // maxLines: 1, 
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                   ],
                 ),
                      ],
                ),
              ),
            ),
          ),
         Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Expanded(
        child: TextFormField(
          controller: questionController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))
            )
          ),
        ),
      ),
           IconButton(onPressed: (){}, icon: const Icon(Icons.photo_library)),
           IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
    ],
  ),
),
    Row(
      children: [
        const Text('    Difficulty:  '),
        DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
            },
            items: <String>['Easy', 'Medium', 'Hard']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
            }).toList(),
          ),
          const SizedBox(width: 50,),
          const Text('Topic:  '),
          ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom( minimumSize: Size(80, 30),), 
          child: Text('Select',style: TextStyle(color: Colors.black),),),
      ],
    ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Marks:  '),
             SizedBox(
          width: 50, 
          height: 35,// Set the width as needed
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLines: 1,
            controller: marksController,
            decoration: const InputDecoration(
               
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
          ],
        ),

            ],
          )
        ],
      ),
    );
  }
}