

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/Director/ApprovedPapersList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class PrintedPapers extends StatefulWidget {
  const PrintedPapers({super.key});
  @override
  State<PrintedPapers> createState() => _PrintedPapersState();
}

class _PrintedPapersState extends State<PrintedPapers> {
    List<dynamic> pplist = [];
  TextEditingController search = TextEditingController();
  bool isPrintedPressed=true;
    bool isApprovedPressed=false;


    @override
  void initState() {
    super.initState();
    loadPrintedPapersData();
  }

  Future<void> loadPrintedPapersData() async {
   try {
     pplist=await APIHandler().loadPrintedPapers();
     setState(() {
       
     });
   } catch (e) {
      if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error loading printed papers'),
            content: Text(e.toString()),
          );
        },
      );
      }
   }
  }

  Future<void> searchPrintedPapers(String courseTitle) async {
  try {
    if (courseTitle.isEmpty) { 
      loadPrintedPapersData();
      return;
    }
     pplist=await APIHandler().searchPrintedPapers(courseTitle);
      setState(() {
     });
  } catch (e) {
    if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error searching printed papers'),
            content: Text(e.toString()),
          );
        },
      );
       Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Printed Papers'),
      body:
         SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                 const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    SizedBox( width: 190,height: 50,
                      child: customButton(onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DRTApprovedPapers()));
                      }, buttonText: 'Approved', isPressed: isApprovedPressed)),
                    SizedBox(width:190,height: 50,child: customButton(onPressed: (){

                    }, buttonText: 'Printed', isPressed: isPrintedPressed))
                  ],),
                ),
                SizedBox(
                  width: 300,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: search,
                      onChanged: (value) async{
                        searchPrintedPapers(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.search,
                        ),
                        labelText: 'Search Course',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
          
                Expanded(
                  child: ListView.builder(
                    itemCount: pplist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                          title: Text(
                            pplist[index]['c_title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text(plist[index]['status']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               Text(
                                pplist[index]['c_code'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                 
                                },
                                icon: const Icon(Icons.check),
                              ),
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
    );
  }
}
