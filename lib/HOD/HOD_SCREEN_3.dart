import 'dart:convert';
import 'package:biit_directors_dashbooard/HOD/HOD_SCREEN_4.dart';
import 'package:biit_directors_dashbooard/HOD/facultydet.dart';
import 'package:http/http.dart' as http;
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:flutter/material.dart';

class AssignedCourses extends StatefulWidget {
  final String facultyname;
  final int fid;

   const AssignedCourses({Key? key, required this.facultyname, required this.fid}) : super(key: key);


  @override
  State<AssignedCourses> createState() => _AssignedCoursesState();
}
class _AssignedCoursesState extends State<AssignedCourses> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  List<dynamic> aclist = [];
  Future<void> loadAssignedCourses(int id) async {
    try {
      Uri uri = Uri.parse(
          "${APIHandler().apiUrl}AssignedCourses/getAssignedCourses/$id");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        aclist = jsonDecode(response.body);
        setState(() {});
      } else if(response.statusCode == 404){
         showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Data not found for the given id'),
          );
        },
      );
      }else{
         showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Failed to load assigned courses. Please try again later.'),
          );
        },
      );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('An error occurred. Please try again later.'),
          );
        },
      );
    }
  }


  Future<void> deleteAssignedCourses(int id) async {
    try{
      Uri url = Uri.parse(
          '${APIHandler().apiUrl}AssignedCourses/deleteAssignedCourse/$id');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
     loadAssignedCourses(widget.fid);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Deleted Successfully'),
            );
          },
        );
        Future.delayed(const Duration(seconds: 1), () {

          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Error....'),
            );
          },
        );
      }
     }catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error deleting Assigned Courses'),
          );
        },
      );
    }
  }


   void add() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>  AssignCoursetoFaculty(facultyname: widget.facultyname,)),
    );
  }
  @override
  void initState() {
    loadAssignedCourses(widget.fid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
           backgroundColor: Colors.black,
        elevation: 10,
        title: const Text('View Course',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FacultyList()));
          },
        ),
      ),
         body:  Stack(
           fit: StackFit.expand,
           children: [
             Positioned.fill(
               child: Image.asset(
                 'assets/images/HOD.png',
                 fit: BoxFit.cover,
               ),
             ),
             Column(
               children: [
                const SizedBox(height: 80),
                 const Text('Teacher Name',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                 const SizedBox(height: 10,),
                 Text(widget.facultyname,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
                  const SizedBox(height: 50,),
                 const Text('Assigned Courses',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w600),),
                 const SizedBox(height: 10,),
                 Expanded(
                   child: ListView.builder(
                    itemCount: aclist.length,
                    itemBuilder: (context,index){
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white.withOpacity(0.8),
                          child:ListTile(
                            title: Text(aclist[index]['c_title']),
                            subtitle: Text(aclist[index]['c_code']),
                            trailing: IconButton(onPressed: (){
                              deleteAssignedCourses(aclist[index]['ac_id']);
                            }, icon: const Icon(Icons.delete)),
                          )
                        );
                    
                   }),
                 )
               ],
             )
           ],
         ),
          floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: customColor,
        onPressed: add,
        child: const Icon(Icons.add),
      ),
    );
  }
}