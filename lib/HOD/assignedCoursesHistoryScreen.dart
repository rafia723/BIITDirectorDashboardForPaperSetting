import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/HOD/assgnedToFacultyHistory.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class AssignedCoursesHistory extends StatefulWidget {
  const AssignedCoursesHistory({super.key});

  @override
  State<AssignedCoursesHistory> createState() => _AssignedCoursesHistoryState();
}

class _AssignedCoursesHistoryState extends State<AssignedCoursesHistory> {
  int _selectedYear = DateTime.now().year;
  String _selectedSession = 'Spring'; 

  List<String> sessionList = ['Spring', 'Summer', 'Fall'];
  List<String> termList = ['Mid', 'Final'];
    List<dynamic> clist = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  TextEditingController search = TextEditingController();



   Future<void> searchCourse(String query) async {
    try {
      if (query.isEmpty) {
        loadCourses();
        return;
      }
        clist = await APIHandler().searchAssignedCoursesOfSessionAndYear(query,_selectedSession,_selectedYear);
        setState(() {});
      
    } catch (e) {
       if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadCourses() async {
    try {
     
        clist = await APIHandler().loadAssignedCoursesOFSessionAndYear(_selectedSession,_selectedYear);
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
      appBar: customAppBar(context: context, title: "Paper's History"),
      body: Stack(
        children: [
          // Background Image (Replace with your image)
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Year Dropdown
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Year',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      isExpanded: true,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedYear = newValue;
                            loadCourses();
                          });
                        }
                      },
                      items: List.generate(
                        2051 - 2000,
                        (index) => DropdownMenuItem<int>(
                          value: 2000 + index,
                          child: Text((2000 + index).toString()),
                        ),
                      ),
                    ),
                  ),

                  // Session Dropdown
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Session',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: _selectedSession,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSession = newValue;
                            loadCourses();
                          });
                        }
                      },
                      items: sessionList.map((String session) {
                        return DropdownMenuItem<String>(
                          value: session,
                          child: Text(session),
                        );
                      }).toList(),
                    ),
                  ),
               if(clist.isNotEmpty) 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: search,
        onChanged: (value) {
          searchCourse(value);
        },
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: Icon(
            Icons.search,
            color: Colors.black54,
          ),
          labelText: 'Search Course',
          labelStyle: TextStyle(color: Colors.black54),
          border: OutlineInputBorder(),
        ),
      ),
    ),
     clist.isNotEmpty?
    Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: clist.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white.withOpacity(0.8),
            child: GestureDetector(
              onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  AssignedToFacultyNamesHistory(
                          courseTitle: clist[index]['c_title'],
                          ccode: clist[index]['c_code'],
                          cid: clist[index]['c_id'],
                        ),
                      ),
                    );
              },
              child: ListTile(
                title: Text(
                  clist[index]['c_title'],
                  style:
                      const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      clist[index]['c_code'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  AssignedToFacultyNamesHistory(
                        courseTitle: clist[index]['c_title'],
                        ccode: clist[index]['c_code'],
                         cid: clist[index]['c_id'],
                        ),
                      ),
                    );
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ):Text('No data found for $_selectedSession $_selectedYear'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}