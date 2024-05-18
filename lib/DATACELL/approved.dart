import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class Approved extends StatefulWidget {
  const Approved({super.key});

  @override
  State<Approved> createState() => _ApprovedState();
}

List<dynamic> plist = [];
TextEditingController search = TextEditingController();

class _ApprovedState extends State<Approved> {

  @override
  void initState() {
    super.initState();
    loadApprovedPapersData();
  }

  Future<void> loadApprovedPapersData() async {
    try {
      plist=await APIHandler().loadApprovedPapers();
       setState(() {
      });
    }
    catch(e){
  if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error loading approved papers'),
            content: Text(e.toString()),
          );
        },
      );
      }
    }
  }

  Future<void> searchApprovedPapers(String courseTitle) async {
  try {
    if (courseTitle.isEmpty) { 
      loadApprovedPapersData();
      return;
    }
     plist=await APIHandler().searchApprovedPapers(courseTitle);
      setState(() {
     });
  } catch (e) {
    if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error searching approved papers'),
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
      appBar: customAppBar(context: context, title: 'Approved Papers'),
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
                        searchApprovedPapers(value);
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
                    shrinkWrap: true,
                    itemCount: plist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                          title: Text(
                            plist[index]['c_title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customElevatedButton(
                                  onPressed: () {}, buttonText: 'Print')
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
