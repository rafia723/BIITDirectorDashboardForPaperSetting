import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class PaperHeader extends StatefulWidget {
   final int? cid;
  final String coursename;
  final String ccode;
  const PaperHeader({super.key,required this.cid,required this.ccode,required this.coursename});
  

  @override
  State<PaperHeader> createState() => _PaperHeaderState();
}

class _PaperHeaderState extends State<PaperHeader> {
  TextEditingController durationController=TextEditingController();
   TextEditingController degreeController=TextEditingController();
     TextEditingController totalMarksController=TextEditingController();
       TextEditingController noOfQuestionsController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Paper Header'),
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
              
            const SizedBox(height: 50,),
            const  Center(
              child:  Text(
                'Paper Header',style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500),
                )
                ),
                const SizedBox(height: 10,),
                const Text('  Teachers:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                Row(
                   children: [
                     const Text('  Course Title:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                     Text(' ${widget.coursename}',style: const TextStyle(fontSize: 16),),
                   ],
                 ),
                 Row(
                   children: [
                     const Text('  Course Code:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                     Text(' ${widget.ccode}',style: const TextStyle(fontSize: 16),),
                   ],
                 ),
                const Row(
                   children: [
                     Text('  Date of Exam:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                   ],
                 ),
                  Row(
                   children: [
                     const Text('  Duration:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                     Container(
                      height: 10,
                      width: 10,
                       child: TextFormField(
                        maxLines: 1,
                        controller: durationController,
                         decoration: const InputDecoration(
                         border: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(4.0)),
                           ),
                       )
                       ),
                     ),
                   ],
                 ),
            ],
          ),
        ],
    ),   
    );
  }
}
