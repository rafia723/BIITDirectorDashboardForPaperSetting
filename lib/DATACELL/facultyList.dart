
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/editFaculty.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'faculty.dart';

class FacultyDetails extends StatefulWidget {
  const FacultyDetails({super.key});

  @override
  State<FacultyDetails> createState() => _FacultyDetailsState();
}
class _FacultyDetailsState extends State<FacultyDetails> {
  List<dynamic> flist = [];
  TextEditingController search = TextEditingController();

  
  @override
  void initState() {
    super.initState();
    loadFacultyData(); 
  }

  
  Future<void> loadFacultyData() async {
    try{
 flist=await APIHandler().loadFaculty();
      setState(() {
      });
    }
    catch(e){
  if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error loading faculty'),
            content: Text(e.toString()),
          );
        },
      );
      }
    }
     
  }

  Future<void> searchFacultyData(String query) async {
    try {
      if (query.isEmpty) {
       loadFacultyData();
        return;
      }
     flist=await APIHandler().searchFaculty(query);
     setState(() {
     });
    } catch (e) {
      if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error searching faculty'),
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

Future<void> updateStatus(int id, bool newStatus) async {
  try {
    dynamic code = await APIHandler().updateFacultyStatus(id, newStatus);
    if (mounted) {
      if (code == 200) {
        loadFacultyData();
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const AlertDialog(
        //       title: Text('Status Changed'),
        //     );
        //   },
        // );
        // Future.delayed(const Duration(seconds: 1), () {
        //   Navigator.of(context).pop();
        // });
      } else {
        throw Exception('Non 200 error');
      }
    }
  } catch (e) {
    if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error changing status of faculty'),
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

  void editFacultyRecords(int fid, dynamic data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFaculty(fid, data),
      ),
    );
    loadFacultyData();
  }


  void add() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FacultyForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Faculty Details'),
      body:    SizedBox(
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
                    searchFacultyData(value);
                  },
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: Icon(Icons.search),
                    labelText: 'Search Faculty',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
         
                Expanded(
                  child: ListView.builder(
                    itemCount: flist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                          title: Text(
                            flist[index]['f_name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(flist[index]['username']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Handle edit
                                  editFacultyRecords(
                                      flist[index]['f_id'], flist[index]);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              Switch(
                                  value: flist[index]['status'] == 'enabled',
                                  onChanged: (newValue) async{
                                      await updateStatus(flist[index]['f_id'], newValue);
                                       setState(() {
                                    });
                                  }), 
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: customButtonColor,
        onPressed: add,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
