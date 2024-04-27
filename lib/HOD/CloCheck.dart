import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CloCheckingScreen extends StatefulWidget {
  final String courseTitle;
  final String ccode;
  final int cid;
  const CloCheckingScreen(
      {Key? key,
      required this.courseTitle,
      required this.ccode,
      required this.cid})
      : super(key: key);

  @override
  State<CloCheckingScreen> createState() => _CloCheckingScreenState();
}

class _CloCheckingScreenState extends State<CloCheckingScreen> {
  List<dynamic> clolist = [];
  Future<void> loadClo(int cid) async {
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Clo/getClo/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clolist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load clos');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading clos'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadClo(widget.cid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'CLOs',
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
      body: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/HOD.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15.0), // Adjust as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.courseTitle,
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'Course Code: ${widget.ccode}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          top: 150, // Adjust position as needed
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: clolist.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(
                          'Clo ${index+1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          clolist[index]['clo_text'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: customElevatedButton(
                          onPressed: () async {
                            String newStatus =
                                clolist[index]['status'] == 'approved'
                                    ? 'disapproved'
                                    : 'approved';
                            int statusCode = await APIHandler().updateCloStatus(
                                clolist[index]['clo_id'], newStatus);
                            if (statusCode == 200) {
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
                              setState(() {
                                clolist[index]['status'] = newStatus;
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
                          },
                          buttonText: clolist[index]['status'] == 'approved'
                              ? 'Disapprove'
                              : 'Approve', // Update button text based on current status
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
