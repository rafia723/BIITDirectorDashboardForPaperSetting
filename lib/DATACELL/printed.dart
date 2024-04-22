import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'datacell.dart';

class Printed extends StatefulWidget {
  const Printed({super.key});
  @override
  State<Printed> createState() => _PrintedState();
}

class _PrintedState extends State<Printed> {
  Future<void> loadPrintedPapers() async {
    Uri uri = Uri.parse('${APIHandler().apiUrl}Paper/getPrintedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      pplist = jsonDecode(response.body);
      setState(() {});
    } else {
      throw Exception('Failed to load Printed Papers');
    }
  }

  Future<void> SearchPrintedPapers(String courseTitle) async {
    try {
      if (courseTitle.isNotEmpty) {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Paper/SearchPrintedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        pplist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load Printed Papers');
      }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading Printed Papers'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadPrintedPapers();
  }

  List<dynamic> pplist = [];
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Printed Papers',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
         SizedBox(
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
                      style: const TextStyle(color: Colors.white),
                      controller: search,
                      onChanged: (value) {
                        SearchPrintedPapers(value);
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),
                        labelText: 'Search Course',
                        labelStyle: TextStyle(color: Colors.white54),
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
                              Text(pplist[index]['status']),
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
