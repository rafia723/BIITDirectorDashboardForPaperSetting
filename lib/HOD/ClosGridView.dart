import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class GridViewScreen extends StatefulWidget {
  const GridViewScreen({super.key});

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  Color customColor = const Color.fromARGB(255, 72, 238, 188);
  List<dynamic> clist = [];
  String? selectedCourse; // Nullable initially
  int? selectedCourseId;
  List<dynamic> clolist = [];
  List<dynamic> cloGridHeaderList = [];
  int? selectedCloIndex; // Track the index of the selected CLO button
  TextEditingController asgController = TextEditingController();
  TextEditingController quizController = TextEditingController();
  TextEditingController midController = TextEditingController();
  TextEditingController finalController = TextEditingController();
  String selectedCLOText = ''; // Holds the text of the selected CLO button

  Future<void> loadCourseWithEnabled() async {
    try {
      clist = await APIHandler().loadCourseWithEnabledStatus();
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
      clolist = await APIHandler().loadClo(cid);
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

  Future<void> addCloGridWeightageData(
      int cloid, int headerid, int? weightage) async {
    try {
      dynamic code =
          await APIHandler().addCloGridWeightage(cloid, headerid, weightage);
      setState(() {});
      if (code == 200) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return const AlertDialog(
                title: Text('updated...'),
              );
            },
          );
          asgController.clear();
          quizController.clear();
          midController.clear();
          finalController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error inserting weightage'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadCourseWithEnabled();
    loadCloGridHeader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Clos Grid'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Course:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 350),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            26, 112, 106, 106), // Set background color to white
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Add border radius
                      ),
                      child: DropdownButton<String>(
                        hint: const Text(' Select Course '),
                        isExpanded: true,
                        elevation: 9,
                        value: selectedCourse,
                        items: clist.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['c_code'],
                            onTap: () {
                              setState(() {
                                selectedCourse = e['c_title'];
                                selectedCourseId = e['c_id'];
                              });
                            },
                            child: Text(
                              e['c_title'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCourse = newValue!;
                            selectedCourseId = clist.firstWhere((course) =>
                                course['c_code'] == newValue)['c_id'];
                            loadClo(selectedCourseId!);
                            loadCloGridHeader(); // Load CLO grid headers when course changes
                            selectedCloIndex =
                                null; // Reset selected CLO index when course changes
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: clolist.asMap().entries.map((entry) {
                      int index = entry.key;
                      bool isPressed = selectedCloIndex == index;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(isPressed
                                ? customColor
                                : Colors.white.withOpacity(0.8)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedCloIndex = index;
                              selectedCLOText = 'CLO ${index + 1}';
                            });
                          },
                          child: Text('CLO ${index + 1}'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 320,
                    height: 30,
                    color: customColor,
                    child: const Center(
                      child: Text(
                        'Assessments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 320,
                    height: 30,
                    //    color: const Color.fromARGB(224, 224, 219, 219),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: cloGridHeaderList.map((header) {
                        return Text(
                          header[
                              'name'], // Adjust this according to your actual data structure
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  color: const Color.fromARGB(224, 224, 219, 219),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      const SizedBox(width: 5),
                      const Text(
                        'Weight', // Text to be displayed on the left
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 60), // Adjust spacing as needed
                      Row(
                        children: cloGridHeaderList.map((header) {
                          return SizedBox(
                            width: 75, // Adjust width as needed
                            child: Text(
                              '${header['weightage']}%', // Concatenate the weightage value with the '%' sign
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.black,
                ),
                if (selectedCLOText.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection:Axis.horizontal,
                    child: Row(
                      children: [
                        Text(selectedCLOText),
                        const SizedBox(width: 55,),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: asgController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                       
                        ),
                           const Text('%'),
                          const SizedBox(width: 15,),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: quizController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                             const Text('%'),
                         const SizedBox(width: 15,),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: midController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                             const Text('%'),
                         const SizedBox(width: 15,),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: finalController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                             const Text('%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                    if (selectedCLOText.isNotEmpty)
           Align(
  alignment: Alignment.centerRight,
  child: customElevatedButton(
    onPressed: () {
      int? cloId = selectedCloIndex != null ? selectedCloIndex! + 1 : null;
      if (cloId != null) {
        if (asgController.text.isNotEmpty) {
          int asgWeightage = int.parse(asgController.text);
          if (asgWeightage > cloGridHeaderList[0]['weightage']) {
            // Show message if weightage exceeds
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Weightage for Assignment exceeded.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            return; // Stop execution if weightage exceeds
          }
          addCloGridWeightageData(cloId, 1, asgWeightage);
        }
        // Similar logic for other text form fields
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Please select a CLO.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    },
    buttonText: 'Update',
  ),
),
                const SizedBox(
                  height: 250,
                ),
                Center(
                    child: customElevatedButton(
                        onPressed: () {}, buttonText: 'View Clos'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
