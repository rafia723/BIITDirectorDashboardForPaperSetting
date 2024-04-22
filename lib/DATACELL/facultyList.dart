import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/editFaculty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'datacell.dart';
import 'faculty.dart';

class FacultyDetails extends StatefulWidget {
  const FacultyDetails({super.key});

  @override
  State<FacultyDetails> createState() => _FacultyDetailsState();
}
 Color customColor = const Color.fromARGB(255, 78, 223, 180);
class _FacultyDetailsState extends State<FacultyDetails> {
  List<dynamic> flist = [];
  TextEditingController search = TextEditingController();
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
          '${APIHandler().apiUrl}Faculty/searchFaculty?search=$query');
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

  Future<void> updateStatus(int id, bool newStatus) async {
    String status = newStatus ? 'enabled' : 'disabled';
    Uri url = Uri.parse('${APIHandler().apiUrl}Faculty/editFacultyStatus/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
        loadFaculty();
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Status Changed'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error changing status of faculty'),
          );
        },
      );
      
    }
  }

  void editFacultyRecords(int fid, dynamic data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFaculty(fid, data),
      ),
    );
    loadFaculty();
  }

  Future<void> loadFaculty() async {
    try {
      Uri uri = Uri.parse("${APIHandler().apiUrl}Faculty/getFaculty");
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

  void add() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FacultyForm()),
    );
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
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:    SizedBox(
          height: double.infinity, 
        child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/datacell.png',
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
                                  onChanged: (newValue) {
                                    setState(() {
                                      updateStatus(
                                          flist[index]['f_id'], newValue);
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
        backgroundColor: customColor,
        onPressed: add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
