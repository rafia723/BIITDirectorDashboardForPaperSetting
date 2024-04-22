import 'package:biit_directors_dashbooard/FACULTY/faculty.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
   final String facultyname;
  final int fid;

  const Notifications({Key? key, required this.facultyname, required this.fid})
      : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  Faculty(facultyname: widget.facultyname,fid: widget.fid,),
                      ),
                    );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Faculty.png',
              fit: BoxFit.cover,
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Container with decoration for black border
                  const SizedBox(height: 80,),
                Container(
                    decoration: BoxDecoration(
                     
                     border: const Border(
                      top: BorderSide(color: Colors.white,width: 1.0),
                     // bottom: BorderSide(color: Colors.black,width: 1.0)
                      ),
                      borderRadius: BorderRadius.circular(
                          0.0), // Adjust the radius as needed
                    ),
                      
                    child: const Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                 
                                  children: [Text('CS-353|',style: TextStyle(fontSize: 15,color: Colors.white),)],
                                ),
                                Column(
                                  children: [Text('Programming Fundamentals',style: TextStyle(fontSize: 15,color: Colors.white),)],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('QNo1: Review Difficulty level of question.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                   // SizedBox(height: 10,),
                   Container(
                    decoration: BoxDecoration(
                     
                      border: const Border(
                      top: BorderSide(color: Colors.white,width: 1.0),
                  //    bottom: BorderSide(color: Colors.black,width: 1.0)
                      ),
                      borderRadius: BorderRadius.circular(
                          0.0), // Adjust the radius as needed
                    ),
                      
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [Text('CS-345|',style: TextStyle(fontSize: 15,color: Colors.white),)],
                                ),
                                Column(
                                  children: [Text('Ecommerce',style: TextStyle(fontSize: 15,color: Colors.white),)],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('QNo2: Review Difficulty level of question.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                       Container(
                    decoration: BoxDecoration(
                     
                      border: const Border(
                      top: BorderSide(color: Colors.white,width: 1.0),
                      bottom: BorderSide(color: Colors.white,width: 1.0)
                      ),
                      borderRadius: BorderRadius.circular(
                          0.0), // Adjust the radius as needed
                    ),
                    child: const Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  
                                  children: [Text('CS-384|',style: TextStyle(fontSize: 15,color: Colors.white),)],
                                ),
                                Column(
                                  children: [Text('Database',style: TextStyle(fontSize: 15,color: Colors.white),)],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('All questions are not appropriate. \nRecheck them.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                    
              ],
            ),
          ),
        ],
      ),
    );
  }
}
