import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/HOD/CloCheck.dart';
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
  String? selectedCourseCode; // Nullable initially
  int? selectedCourseId;
    String? selectedCourseText;
  List<dynamic> clolist = [];
  List<dynamic> cloGridHeaderList = [];
  int? selectedCloIndex; // Track the index of the selected CLO button

  int? selectedCloId;
  TextEditingController asgController = TextEditingController();
  TextEditingController quizController = TextEditingController();
  TextEditingController midController = TextEditingController();
  TextEditingController finalController = TextEditingController();
  String selectedCLONumber = ''; // Holds the number of the selected CLO button
  String selectedCLOText='';
  List<dynamic> cloWeightageofCourse = [];
  List<dynamic> cloWeightageofclo = [];
  List<dynamic> data = [];
  dynamic index;

  Future<int> calculateTotalWeightage(int headerId) async {
    await loadCloWeightageofSpecificHeaderInCourse(selectedCourseId!, headerId);
    int totalWeightage = 0;
    for (var cloWeightage in data) {
      if (cloWeightage['clo_id'] != selectedCloId ||
          cloWeightage['header_id'] != headerId) {
        totalWeightage += (cloWeightage['weightage'] ?? 0) as int;
      }
    }
    return totalWeightage;
  }

  Future<int> calculateTotalAssignmentWeightage() async {
    return await calculateTotalWeightage(1);
  }

  Future<int> calculateTotalQuizWeightage() async {
    return await calculateTotalWeightage(2);
  }

  Future<int> calculateTotalMidWeightage() async {
    return await calculateTotalWeightage(3);
  }

  Future<int> calculateTotalFinalWeightage() async {
    return await calculateTotalWeightage(4);
  }

  Widget buildTextFormField({required TextEditingController controller}) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        maxLines: 1,
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  Future<void> loadCourseWithEnabled() async {
    try {
      clist = await APIHandler().loadCourseWithEnabledStatus();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
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

  Future<void> loadCloGridHeader() async {
    try {
      cloGridHeaderList = await APIHandler().loadCLOGridHeader();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
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
         showSuccesDialog(context, 'Updated..');
          asgController.clear();
          quizController.clear();
          midController.clear();
          finalController.clear();
          await loadCloWeightage(selectedCloId!);
        }
      }
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
        showErrorDialog(context, e.toString());
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

  Future<void> loadCloWeightageofSpecificHeaderInCourse(
      int cid, int hid) async {
    try {
      data = await APIHandler()
          .loadCourseGridViewWeightageWithSpecificHeader(cid, hid);
      setState(() {});
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
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
                        value: selectedCourseCode,
                        items: clist.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['c_code'],
                            onTap: () {
                              setState(() {
                                selectedCourseCode = e['c_code'];
                                selectedCourseId = e['c_id'];
                                selectedCourseText=e['c_title'];

                              });
                            },
                            child: Text(
                              e['c_title'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedCourseCode = newValue!;
                            selectedCourseId = clist.firstWhere((course) =>
                                course['c_code'] == newValue)['c_id'];
                            selectedCloIndex = null;
                            selectedCLONumber = '';
                             index=0;
                          });

                          // Load CLOs for the selected course
                          await loadClo(selectedCourseId!);
                          await loadCourseCloWeightage(selectedCourseId!);
                           if(mounted) {
                          setState(() {});
                           }
                       
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: clolist.isNotEmpty
                        ? clolist.asMap().entries.map((entry) {
                            int index = entry.key;
                            bool isPressed = selectedCloIndex == index;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      isPressed
                                          ? customColor
                                          : Colors.white.withOpacity(0.8)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    selectedCloIndex = index;
                                    selectedCloId = entry.value['clo_id'];
                                    selectedCLOText = entry.value['clo_text'];
                                    selectedCLONumber = '${index + 1}';
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('CLO $selectedCLONumber'),
                                          content: Text(selectedCLOText),
                                          actions: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.check))
                                          ],
                                        );
                                      },
                                    );
                                  });
                                  await loadCourseCloWeightage(
                                      selectedCourseId!);
                                },
                                child: Text('CLO ${index + 1}'),
                              ),
                            );
                          }).toList()
                        : (selectedCourseId != null
                            ? [const Text('No CLOs')]
                            : [const Text('Select Course')]),
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
                if (selectedCLONumber.isNotEmpty && clolist.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text('CLO -$selectedCLONumber',style: const TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(width: 55),
                          buildTextFormField(controller: asgController),
                          const Text('%'),
                          const SizedBox(width: 15),
                          buildTextFormField(controller: quizController),
                          const Text('%'),
                          const SizedBox(width: 15),
                          buildTextFormField(controller: midController),
                          const Text('%'),
                          const SizedBox(width: 15),
                          buildTextFormField(controller: finalController),
                          const Text('%'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
               if (selectedCLONumber.isNotEmpty && clolist.isNotEmpty)
                  Align(
                      alignment: Alignment.centerRight,
                      child: customElevatedButton(
                        onPressed: () async {
                          int? cloID = selectedCloId;
                          if (cloID != null) {
                            bool isValid = true;
                            String errorMessage = '';

                            // Validate Assignment weightage
                            if (asgController.text.isNotEmpty) {
                              bool isUpdate = cloWeightageofclo.any(
                                (weightageData) =>
                                    weightageData['clo_id'] == cloID &&
                                    weightageData['header_id'] ==
                                        cloGridHeaderList[0]['header_id'],
                              );
                              int asgWeightage = int.parse(asgController.text);
                              if (asgWeightage >
                                  cloGridHeaderList[0]['weightage']) {
                                isValid = false;
                                errorMessage =
                                    'Weightage for Assignment exceeded.';
                              }
                              if (!isValid) {
                                showErrorDialog(context, errorMessage);
                                return; // Stop execution if validation failed
                              } else if (isUpdate) {
                                int totalAssignmentWeightage =
                                    await calculateTotalAssignmentWeightage();
                                setState(() {});

                                int totalAsgHeaderWeightage =
                                    cloGridHeaderList[0]['weightage'] as int;
                                int asgAndTotalAsg = 0;
                                asgAndTotalAsg =
                                    asgWeightage + totalAssignmentWeightage;
                                if (totalAssignmentWeightage >=
                                        totalAsgHeaderWeightage ||
                                    asgAndTotalAsg > totalAsgHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total assignment weightage exceeds the limit of $totalAsgHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                                // addCloGridWeightageData(
                                //     cloID,
                                //     cloGridHeaderList[0]['header_id'],
                                //     asgWeightage);
                              } else {
                                int totalAssignmentWeightage =
                                    await calculateTotalAssignmentWeightage();
                                setState(() {});

                                int totalAsgHeaderWeightage =
                                    cloGridHeaderList[0]['weightage'] as int;
                                int asgAndTotalAsg = 0;
                                asgAndTotalAsg =
                                    asgWeightage + totalAssignmentWeightage;
                                if (totalAssignmentWeightage >=
                                        totalAsgHeaderWeightage ||
                                    asgAndTotalAsg > totalAsgHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total assignment weightage exceeds the limit of $totalAsgHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                              }
                            }

                            // Validate Quiz weightage
                            if (quizController.text.isNotEmpty) {
                              bool isUpdate = cloWeightageofclo.any(
                                (weightageData) =>
                                    weightageData['clo_id'] == cloID &&
                                    weightageData['header_id'] ==
                                        cloGridHeaderList[1]['header_id'],
                              );
                              int quizWeightage =
                                  int.parse(quizController.text);
                              if (quizWeightage >
                                  cloGridHeaderList[1]['weightage']) {
                                isValid = false;
                                errorMessage = 'Weightage for Qui exceeded.';
                              }
                              if (!isValid) {
                                showErrorDialog(context, errorMessage);
                                return; // Stop execution if validation failed
                              } else if (isUpdate) {
                                int totalQuizWeightage =
                                    await calculateTotalQuizWeightage();
                                setState(() {});
                                int totalQuizHeaderWeightage =
                                    cloGridHeaderList[1]['weightage'] as int;
                                int quizAndTotalQuiz = 0;
                                quizAndTotalQuiz =
                                    quizWeightage + totalQuizWeightage;
                                if (totalQuizWeightage >=
                                        totalQuizHeaderWeightage ||
                                    quizAndTotalQuiz >
                                        totalQuizHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total quiz weightage exceeds the limit of $totalQuizHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                                // addCloGridWeightageData(
                                //     cloID,
                                //     cloGridHeaderList[1]['header_id'],
                                //     quizWeightage);
                              } else {
                                int totalQuizWeightage =
                                    await calculateTotalQuizWeightage();
                                setState(() {});
                                int totalQuizHeaderWeightage =
                                    cloGridHeaderList[1]['weightage'] as int;
                                int quizAndTotalQuiz = 0;
                                quizAndTotalQuiz =
                                    quizWeightage + totalQuizWeightage;
                                if (totalQuizWeightage >=
                                        totalQuizHeaderWeightage ||
                                    quizAndTotalQuiz >
                                        totalQuizHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total quiz weightage exceeds the limit of $totalQuizHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                              }
                            }
                            // Validate Midterm weightage
                            if (midController.text.isNotEmpty) {
                              bool isUpdate = cloWeightageofclo.any(
                                (weightageData) =>
                                    weightageData['clo_id'] == cloID &&
                                    weightageData['header_id'] ==
                                        cloGridHeaderList[2]['header_id'],
                              );
                              int midWeightage = int.parse(midController.text);
                              if (midWeightage >
                                  cloGridHeaderList[2]['weightage']) {
                                isValid = false;
                                errorMessage =
                                    'Weightage for Midterm exceeded.';
                              }
                              if (!isValid) {
                                showErrorDialog(context, errorMessage);
                                return; // Stop execution if validation failed
                              } else if (isUpdate) {
                                int totalMidWeightage =
                                    await calculateTotalMidWeightage();
                                setState(() {});
                                int totalMidHeaderWeightage =
                                    cloGridHeaderList[2]['weightage'] as int;
                                int midAndTotalMid = 0;
                                midAndTotalMid =
                                    midWeightage + totalMidWeightage;
                                if (totalMidWeightage >=
                                        totalMidHeaderWeightage ||
                                    midAndTotalMid > totalMidHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total Mid Term weightage exceeds the limit of $totalMidHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                                // addCloGridWeightageData(
                                //     cloID,
                                //     cloGridHeaderList[2]['header_id'],
                                //     midWeightage);
                              } else {
                                int totalMidWeightage =
                                    await calculateTotalMidWeightage();
                                setState(() {});
                                int totalMidHeaderWeightage =
                                    cloGridHeaderList[2]['weightage'] as int;
                                int midAndTotalMid = 0;
                                midAndTotalMid =
                                    midWeightage + totalMidWeightage;
                                if (totalMidWeightage >=
                                        totalMidHeaderWeightage ||
                                    midAndTotalMid > totalMidHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total Mid Term weightage exceeds the limit of $totalMidHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                              }
                            }

                            // Validate Final weightage
                            if (finalController.text.isNotEmpty) {
                              bool isUpdate = cloWeightageofclo.any(
                                (weightageData) =>
                                    weightageData['clo_id'] == cloID &&
                                    weightageData['header_id'] ==
                                        cloGridHeaderList[3]['header_id'],
                              );
                              int finalWeightage =
                                  int.parse(finalController.text);
                              if (finalWeightage >
                                  cloGridHeaderList[3]['weightage']) {
                                isValid = false;
                                errorMessage = 'Weightage for Final exceeded.';
                              }
                              if (!isValid) {
                                showErrorDialog(context, errorMessage);
                                return; // Stop execution if validation failed
                              } else if (isUpdate) {
                                int totalFinalWeightage =
                                    await calculateTotalFinalWeightage();
                                setState(() {});
                                int totalFinalHeaderWeightage =
                                    cloGridHeaderList[3]['weightage'] as int;
                                int finalAndTotalFinal = 0;
                                finalAndTotalFinal =
                                    finalWeightage + totalFinalWeightage;
                                if (totalFinalWeightage >=
                                        totalFinalHeaderWeightage ||
                                    finalAndTotalFinal > totalFinalHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total Final Term weightage exceeds the limit of $totalFinalHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                                // addCloGridWeightageData(
                                //     cloID,
                                //     cloGridHeaderList[3]['header_id'],
                                //     finalWeightage);
                              }
                              else {
                                int totalFinalWeightage =
                                    await calculateTotalFinalWeightage();
                                setState(() {});
                                int totalFinalHeaderWeightage =
                                    cloGridHeaderList[3]['weightage'] as int;
                                int FinalAndTotalFinal = 0;
                                FinalAndTotalFinal =
                                    finalWeightage + totalFinalWeightage;
                                if (totalFinalWeightage >=
                                        totalFinalHeaderWeightage ||
                                    FinalAndTotalFinal > totalFinalHeaderWeightage) {
                                  if (mounted) {
                                    showErrorDialog(context,
                                        'Total Final** Term weightage exceeds the limit of $totalFinalHeaderWeightage%.');
                                  }
                                  return; // Stop execution if validation failed
                                }
                              }
                            }

                            // Show error dialog if any validation failed
                            if (!isValid) {
                              showErrorDialog(context, errorMessage);
                              return; // Stop execution if validation failed
                            }

                            // If all validations passed, update the fields
                            if (asgController.text.isNotEmpty) {
                              int asgWeightage = int.parse(asgController.text);

                              addCloGridWeightageData(
                                  cloID,
                                  cloGridHeaderList[0]['header_id'],
                                  asgWeightage);
                            }
                            if (quizController.text.isNotEmpty) {
                              int quizWeightage =
                                  int.parse(quizController.text);
                              addCloGridWeightageData(
                                  cloID,
                                  cloGridHeaderList[1]['header_id'],
                                  quizWeightage);
                            }
                            if (midController.text.isNotEmpty) {
                              int midWeightage = int.parse(midController.text);
                              addCloGridWeightageData(
                                  cloID,
                                  cloGridHeaderList[2]['header_id'],
                                  midWeightage);
                            }
                            if (finalController.text.isNotEmpty) {
                              int finalWeightage =
                                  int.parse(finalController.text);
                              addCloGridWeightageData(
                                  cloID,
                                  cloGridHeaderList[3]['header_id'],
                                  finalWeightage);
                            }
                          } else {
                            showErrorDialog(context, 'Please Select CLO');
                          }
                        },
                        buttonText: 'Update',
                      )),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Clo Grid',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 320,
                              height: 30,
                              color: const Color.fromARGB(224, 224, 219, 219),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: cloGridHeaderList.map((header) {
                                  return Text(
                                    header[
                                        'name'], // Adjust this according to your actual data structure
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                const SizedBox(
                                    width: 60), // Adjust spacing as needed
                                Row(
                                  children: cloGridHeaderList.map((header) {
                                    return SizedBox(
                                      width: 75, // Adjust width as needed
                                      child: Text(
                                        '${header['weightage']}%', // Concatenate the weightage value with the '%' sign
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            color: const Color.fromARGB(224, 224, 219, 219),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                const SizedBox(width: 10),
                                Column(
                                  children:
                                      clolist.asMap().entries.map((entry) {
                                  //  int cloIndex = entry.key;
                                    int cloId = entry.value['clo_id'];
                                    String cloNumber =
                                        entry.value['clo_number'];
                                    // Filter weightages for the current CLO
                                    var cloWeightages = cloWeightageofclo
                                        .where((weightage) =>
                                            weightage['clo_id'] == cloId)
                                        .toList();

                                    // Create a list to hold weightages for all headers
                                    List<int> headerWeightages =
                                        List<int>.filled(
                                            cloGridHeaderList.length, 0);

                                    // Populate weightages for each header
                                    for (var weightage in cloWeightages) {
                                      int headerIndex = cloGridHeaderList
                                          .indexWhere((header) =>
                                              header['header_id'] ==
                                              weightage['header_id']);
                                      if (headerIndex != -1) {
                                        headerWeightages[headerIndex] =
                                            weightage['weightage'];
                                      }
                                    }
                                    return Row(
                                      children: [
                                        Text(
                                          cloNumber,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 70),
                                        Row(
                                          children: headerWeightages
                                              .map((headerWeightage) {
                                            return SizedBox(
                                              width: 75,
                                              child: Text(
                                                '$headerWeightage%',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                    child:clist.isNotEmpty&&selectedCourseId!=null?  customElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>  CloCheckingScreen(courseTitle: selectedCourseText!, ccode: selectedCourseCode!, cid: selectedCourseId!)),
    );

                        }, buttonText: 'View Clos'):const SizedBox())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
