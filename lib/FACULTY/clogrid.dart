import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class CLOGrid extends StatefulWidget {
  final String coursename;
  final String ccode;
  final int cid;
  const CLOGrid({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
  }) : super(key: key);

  @override
  State<CLOGrid> createState() => _CLOGridState();
}

class _CLOGridState extends State<CLOGrid> {
  Color customColor = const Color.fromARGB(255, 72, 238, 188);
  List<dynamic> cloGridHeaderList = [];
  List<dynamic> cloWeightageofCourse = [];

  List<dynamic> cloWeightageofclo = [];
  List<dynamic> clolist = [];

  @override
  void initState() {
    super.initState();
    loadCloGridHeader();
    loadCourseCloWeightage(widget.cid);
    loadClo(widget.cid);
  }

  Future<void> loadCloGridHeader() async {
    try {
      cloGridHeaderList = await APIHandler().loadCLOGridHeader();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error:'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> loadCloWeightage(int cloid) async {
    try {
      var data = await APIHandler().loadCLOGridWeightageofClo(cloid);
      cloWeightageofclo.addAll(data);
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadCourseCloWeightage(int cid) async {
    try {
      cloWeightageofCourse = await APIHandler().loadCourseCLOGridWeightage(cid);
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error:'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> loadClo(int cid) async {
    try {
      clolist = await APIHandler().loadApprovedClos(cid);
      setState(() {});
      for (var clo in clolist) {
        await loadCloWeightage(clo['clo_id']);
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: customAppBar(context: context, title: 'Clo Grid'),
        body: Stack(children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 8.0), // Adjust as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  widget.coursename,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Course Code: ${widget.ccode}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 210,
                    height: 40,
                    color: customColor,
                    child: const Center(
                      child: Text(
                        'Assessments  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 250,
                      height: 50,
                      //    color: const Color.fromARGB(224, 224, 219, 219),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (cloGridHeaderList.isNotEmpty)
                            Text(
                              "   ${cloGridHeaderList[2]['name']} Term", // Accessing name at index 0
                              style: 
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(
                            width: 20,
                          ),
                          if (cloGridHeaderList.length > 1)
                            Text("${cloGridHeaderList[3]['name']} Term",style:const TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      )),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text(
                      'Weight', // Text to be displayed on the left
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 40), // Adjust spacing as needed
                    Center(
                      child: SizedBox(
                        // color: const Color.fromARGB(224, 224, 219, 219),
                        height: 50,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 35,
                            ),
                            if (cloGridHeaderList.isNotEmpty)
                              SizedBox(
                                width: 75, // Adjust width as needed
                                child: Text(
                                  '${cloGridHeaderList[2]['weightage']}%', // Accessing weightage at index 0
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            const SizedBox(
                              width: 55,
                            ),
                            if (cloGridHeaderList.length > 1)
                              SizedBox(
                                width: 55, // Adjust width as needed
                                child: Text(
                                  '${cloGridHeaderList[3]['weightage']}%', // Accessing weightage at index 1
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),

                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 1.0,
                    width: 250,
                    color: Colors.black,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: clolist.asMap().entries.map((entry) {
                    
                      int cloId = entry.value['clo_id'];
                      String cloNumber = entry.value['clo_number'];

                      // Filter weightages for the current CLO
                      var cloWeightages = cloWeightageofclo
                          .where((weightage) => weightage['clo_id'] == cloId)
                          .toList();

                      // Create a list to hold weightages for all headers
                      List<int> headerWeightages =
                          List<int>.filled(cloGridHeaderList.length, 0);

                      // Populate weightages for headers with id 3 and 4
                      for (var weightage in cloWeightages) {
                        int headerId = weightage['header_id'];
                        if (headerId == 3 || headerId == 4) {
                          int headerIndex = cloGridHeaderList.indexWhere(
                            (header) => header['header_id'] == headerId,
                          );
                          if (headerIndex != -1) {
                            headerWeightages[headerIndex] =
                                weightage['weightage'];
                          }
                        }
                      }

                      // Filter the headerWeightages to include only indices corresponding to header_id 3 and 4
                      List<int> specificHeaderWeightages = [];
                      for (var i = 0; i < cloGridHeaderList.length; i++) {
                        int headerId = cloGridHeaderList[i]['header_id'];
                        if (headerId == 3 || headerId == 4) {
                          specificHeaderWeightages.add(headerWeightages[i]);
                        }
                      }

                      // Return the Row for the current CLO
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              cloNumber,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 70),
                          Row(
                            children:
                                specificHeaderWeightages.map((headerWeightage) {
                              return SizedBox(
                                width: 135,
                                child: Text(
                                  '$headerWeightage%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
