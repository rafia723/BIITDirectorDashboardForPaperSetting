

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/viewPaperHistory.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class PrintedPapersHistory extends StatefulWidget {

  final int year;
  final String session;
  final String term;
  const PrintedPapersHistory({
    Key? key,
     required this.year,
      required this.session,
       required this.term,
  }) : super(key: key);
  @override
  State<PrintedPapersHistory> createState() => _PrintedPapersHistoryState();
}

class _PrintedPapersHistoryState extends State<PrintedPapersHistory> {
    List<dynamic> pplist = [];
  TextEditingController search = TextEditingController();
  dynamic sid;


    @override
  void initState() {
    super.initState();
    loadPrintedPapersData();
   
  }

  Future<void> loadPrintedPapersData() async {
   try {
     pplist=await APIHandler().loadPrintedPapersWithSessionYearAndTerm(widget.year,widget.session,widget.term);
     
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

  Future<void> searchPrintedPapersData(String courseTitle) async {
  try {
    if (courseTitle.isEmpty) { 
      loadPrintedPapersData();
      return;
    }
     pplist=await APIHandler().searchPrintedPapersWithSessionTermAndYear(courseTitle,widget.session,widget.term,widget.year);
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
                SizedBox(
                  width: 300,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: search,
                      onChanged: (value) async{
                        searchPrintedPapersData(value);
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
                        child: GestureDetector(
                          onTap: (){
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperView(
                                 cid: pplist[index]['c_id'],
                                 ccode:  pplist[index]['c_code'],
                                 coursename:  pplist[index]['c_title'],
                                 pid:  pplist[index]['p_id'],
                                 
                                )
                            )
                      );
                          },
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
                                     Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperView(
                                 cid: pplist[index]['c_id'],
                                 ccode:  pplist[index]['c_code'],
                                 coursename:  pplist[index]['c_title'],
                                 pid:  pplist[index]['p_id'],
                                 
                                )
                            )
                      );
                                  },
                                  icon: const Icon(Icons.check),
                                ),
                              ],
                            ),
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
