import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'datacell.dart';

class Approved extends StatefulWidget {
  const Approved({super.key});

  @override
  State<Approved> createState() => _ApprovedState();
}

List<dynamic> plist = [];
TextEditingController search = TextEditingController();

class _ApprovedState extends State<Approved> {
  Future<void> loadApprovedPapers() async {
    Uri uri = Uri.parse('${APIHandler().apiUrl}Paper/getApprovedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      plist = jsonDecode(response.body);
      setState(() {});
    } else {
      throw Exception('Failed to load Approved Papers');
    }
  }

  Future<void> SearchApprovedPapers(String courseTitle) async {
    try {
      if (courseTitle.isEmpty) {
        loadApprovedPapers();
      }
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}Paper/SearchApprovedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        plist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load Approved Papers');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading Approved Papers'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadApprovedPapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text(
            'Approved Papers',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Datacell(),
                ),
              );
            },
          )),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png', // Replace with the path to your background image
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
                        // searchCourses(value);
                        // loadPrintedPapers(value);
                        SearchApprovedPapers(value);
                      },
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          labelText: 'Search Course',
                          border: OutlineInputBorder(),
                          filled: false),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
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
                          // subtitle: Text(plist[index]['status']),
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
