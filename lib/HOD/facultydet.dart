import 'dart:convert';
import 'package:biit_directors_dashbooard/HOD/HOD_SCREEN_3.dart';
import 'package:biit_directors_dashbooard/HOD/hod.dart';
import 'package:http/http.dart' as http;
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
      Uri uri = Uri.parse(
          "${APIHandler().apiUrl}Faculty/getFacultyWithEnabledStatus");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        flist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load Faculty');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading faculty'),
          );
        },
      );
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
      Uri url = Uri.parse(
          '${APIHandler().apiUrl}Faculty/searchFacultyWithEnabledStatus?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        flist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to search faculty');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error searching faculty'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Faculty Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HOD()));
          },
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/HOD.png',
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
                      style: const TextStyle(color: Colors.white),
                      controller: search,
                      onChanged: (value) {
                        searchFaculty(value);
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),
                        labelText: 'Search Faculty',
                        labelStyle: TextStyle(color: Colors.white54),
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
                            child:CircularProgressIndicator(color: Colors.white,)
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
