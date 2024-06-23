import 'package:biit_directors_dashbooard/DATACELL/PrintedPapersHistoryList.dart';
import 'package:flutter/material.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart'; // Assuming this contains your customAppBar widget

class PapersHistory extends StatefulWidget {
  const PapersHistory({super.key});

  @override
  State<PapersHistory> createState() => _PapersHistoryState();
}

class _PapersHistoryState extends State<PapersHistory> {
  int _selectedYear = DateTime.now().year;
  String _selectedSession = 'Spring'; 
  String _selectedTerm = 'Mid';

  List<String> sessionList = ['Spring', 'Summer', 'Fall'];
  List<String> termList = ['Mid', 'Final'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: "Paper's History"),
      body: Stack(
        children: [
          // Background Image (Replace with your image)
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Year Dropdown
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Year',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      isExpanded: true,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedYear = newValue;
                          });
                        }
                      },
                      items: List.generate(
                        2025 - 2023,
                        (index) => DropdownMenuItem<int>(
                          value: 2023 + index,
                          child: Text((2023 + index).toString()),
                        ),
                      ),
                    ),
                  ),

                  // Session Dropdown
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Session',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: _selectedSession,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSession = newValue;
                          });
                        }
                      },
                      items: sessionList.map((String session) {
                        return DropdownMenuItem<String>(
                          value: session,
                          child: Text(session),
                        );
                      }).toList(),
                    ),
                  ),

                  // Term Dropdown
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Term',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      hint: const Text('Select Term..'),
                      value: _selectedTerm,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedTerm = newValue;
                          });
                        }
                      },
                      items: termList.map((String term) {
                        return DropdownMenuItem<String>(
                         
                          value: term,
                          child: Text(term),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  customElevatedButton(onPressed: (){
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrintedPapersHistory(
                                  year: _selectedYear,
                                  session:_selectedSession,
                                  term: _selectedTerm,
                                )
                            )
                      );
                  }, buttonText: 'View')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}