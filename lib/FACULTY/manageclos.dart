import 'package:flutter/material.dart';

class ManageClos extends StatefulWidget {
  const ManageClos({super.key});

  @override
  State<ManageClos> createState() => _ManageClosState();
}

class _ManageClosState extends State<ManageClos> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  List<String> clist = [];
  String _selectedItem = "Select Course";
  final List<String> _items = [
    "Select Course",
    "Programming Fundamentals",
    "Data Structure and algorithm"
  ];
  TextEditingController desc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png', // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Course',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButton<String>(
                        value: _selectedItem,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue ?? "";
                          });
                        },
                        items: _items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      maxLines: 4,
                      minLines: 1,
                      showCursor: true,
                      controller: desc,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: (() {
                          setState(() {
                            clist.add(desc.text);
                          });
                          desc.clear();
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customColor,
                          minimumSize: const Size(30, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: clist.length,
                        itemBuilder: (context, index) {
                          return SafeArea(
                            child: SizedBox(
                              height: 80,
                              width: 300,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(clist[index]),
                                          subtitle: Text(clist[index]),
                                          trailing:
                                              Wrap(spacing: 12, children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  clist.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ]))
                                    ],
                                  )),
                            ),
                          );
                        }),
                  ),
                  ElevatedButton(onPressed: (){}, child: const Text('data'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
