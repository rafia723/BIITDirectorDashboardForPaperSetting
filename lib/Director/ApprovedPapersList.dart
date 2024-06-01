import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/Director/PrintedPapers.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class DRTApprovedPapers extends StatefulWidget {
  const DRTApprovedPapers({super.key});

  @override
  State<DRTApprovedPapers> createState() => _DRTApprovedPapersState();
}

class _DRTApprovedPapersState extends State<DRTApprovedPapers> {
  List<dynamic> plist = [];
  TextEditingController search = TextEditingController();
  bool isApprovedPressed = true;
  bool isPrintedPressed = false;

  @override
  void initState() {
    super.initState();
    loadApprovedPapersData();
  }

  Future<void> loadApprovedPapersData() async {
    try {
      plist = await APIHandler().loadApprovedPapers();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error loading approved papers'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }
  

  Future<void> searchApprovedPapers(String courseTitle) async {
    try {
      if (courseTitle.isEmpty) {
        loadApprovedPapersData();
        return;
      }
      plist = await APIHandler().searchApprovedPapers(courseTitle);
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error searching approved papers'),
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
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 190,
                          height: 50,
                          child: customButton(
                              onPressed: () {},
                              buttonText: 'Approved',
                              isPressed: isApprovedPressed)),
                      SizedBox(
                          width: 190,
                          height: 50,
                          child: customButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PrintedPapers()));
                              },
                              buttonText: 'Printed',
                              isPressed: isPrintedPressed))
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: search,
                      onChanged: (value) async {
                        searchApprovedPapers(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.search,
                        ),
                        labelText: 'Search Course',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                plist[index]['c_code'],
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
