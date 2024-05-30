
import 'package:biit_directors_dashbooard/HOD/AssignedCoursesList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:flutter/material.dart';

class FacultyList extends StatefulWidget {
  const FacultyList({super.key});

  @override
  State<FacultyList> createState() => _FacultyListState();
}

List<dynamic> flist = [];
TextEditingController search = TextEditingController();

class _FacultyListState extends State<FacultyList> {
  Future<void> loadFaculty() async {
    try {
        flist = await APIHandler().loadFacultyWithEnabledStatus();
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
    loadFaculty();
  }

  Future<void> searchFaculty(String query) async {
    try {
      if (query.isEmpty) {
        loadFaculty();
        return;
      }
        flist = await APIHandler().searchFacultyWithEnabledStatus(query);
        setState(() {});
      
    } catch (e) {
       if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Faculty Details'),
      body: SizedBox(
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
                      onChanged: (value) {
                        searchFaculty(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                        labelText: 'Search Faculty',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: flist.length,
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
                                    builder: (context) => AssignedCourses(
                                      facultyname: flist[index]['f_name'],
                                        fid: flist[index]['f_id'],
                                    ),
                                  ),
                                );
                          },
                          child: flist.isEmpty
                          ?const Center(
                            child:CircularProgressIndicator(color: Colors.black,)
                            ):ListTile(
                            title: Text(
                              flist[index]['f_name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AssignedCourses(
                                      facultyname: flist[index]['f_name'],
                                        fid: flist[index]['f_id'],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.remove_red_eye),
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
