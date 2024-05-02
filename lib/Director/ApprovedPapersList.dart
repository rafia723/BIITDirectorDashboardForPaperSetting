// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DRTApprovedPapers extends StatefulWidget {
  const DRTApprovedPapers({super.key});

  @override
  State<DRTApprovedPapers> createState() => _DRTApprovedPapersState();
}
List<dynamic> approved_plist = [];
TextEditingController search = TextEditingController();
class _DRTApprovedPapersState extends State<DRTApprovedPapers> {

  Future<void> loadApprovedPapers() async {
    Uri uri = Uri.parse('${APIHandler().apiUrl}Paper/getApprovedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      approved_plist = jsonDecode(response.body);
      setState(() {});
    } else {
      throw Exception('Failed to load Approved Papers');
    }
  }

  Future<void> SearchApprovedPapers(String courseTitle) async {
    try {
       if (courseTitle.isNotEmpty) {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Paper/SearchApprovedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        approved_plist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load Approved Papers');
      }
    } 
    }catch (e) {
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
      appBar: customAppBar(context: context, title: 'Approved Papers'),
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
                        SearchApprovedPapers(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.search,
                        ),
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: approved_plist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                           title: Text(
                              approved_plist[index]['c_title'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  approved_plist[index]['c_code'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                  },
                                  icon: const Icon(Icons.check),
                                ),
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