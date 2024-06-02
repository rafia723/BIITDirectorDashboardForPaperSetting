import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/Model/DifficultyModel.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class ManageDifficulty extends StatefulWidget {
  const ManageDifficulty({super.key});

  @override
  State<ManageDifficulty> createState() => _ManageDifficultyState();
}

class _ManageDifficultyState extends State<ManageDifficulty> {
  TextEditingController easyController = TextEditingController();
  TextEditingController mediumController = TextEditingController();
  TextEditingController difficultController = TextEditingController();
  List<int> numberOfQuestionsList = [2, 3, 4, 5, 6];
  int? selectedNumberOfQuestions;

  Widget buildNumberOfQuestionsDropdown() {
    return DropdownButton<int>(
      value: selectedNumberOfQuestions,
      hint: const Text('Select..'),
      onChanged: (int? value) {
        setState(() {
          selectedNumberOfQuestions = value;
        });
      },
      items: numberOfQuestionsList.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget buildTextFormField({required TextEditingController controller}) {
    return SizedBox(
      width: 50,
      height: 50,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Manage Difficulty'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const Center(
                  child: Text(
                    'Number of Questions:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(child: buildNumberOfQuestionsDropdown()),
                const SizedBox(height: 20),
                const Text(
                  'Easy',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text('Number of Easy Questions'),
                    const SizedBox(width: 80),
                    buildTextFormField(
                      controller: easyController,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Medium',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text('Number of Medium Questions'),
                    const SizedBox(width: 55),
                    buildTextFormField(
                      controller: mediumController,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Difficult',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text('Number of Difficult Questions'),
                    const SizedBox(width: 55),
                    buildTextFormField(
                      controller: difficultController,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: customElevatedButton(
                    onPressed: () async {
                      int easyValue = int.tryParse(easyController.text) ?? 0;
                      int mediumValue = int.tryParse(mediumController.text) ?? 0;
                      int difficultValue = int.tryParse(difficultController.text) ?? 0;

                      if (selectedNumberOfQuestions == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select the number of questions'),
                        ));
                        return;
                      }

                      Difficulty difficulty = Difficulty(
                        easy: easyValue,
                        medium: mediumValue,
                        hard: difficultValue,
                        numberOfQuestions: selectedNumberOfQuestions!,
                      );

                      try {
                        int response = await APIHandler().updateDifficulty(difficulty);

                        if (response == 200) {
                          if(mounted){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Difficulty levels updated successfully'),
                          ));
                          }
                         
                        } else if(response==400){

                          if(mounted){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('The sum of easy, medium, and hard should be equal to numberOfQuestions'),
                          ));
                          }
                        }
                      } catch (e) {
                        if(mounted){
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                          }
                      }
                    },
                    buttonText: 'Save',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}