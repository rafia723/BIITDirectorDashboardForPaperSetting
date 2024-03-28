import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

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
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const Faculty(),
            //           ),
            //         );
          },
        ),
      ),
      body: Stack(
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
                // Add Container with decoration for black border
                  const SizedBox(height: 80,),
                Container(
                    decoration: BoxDecoration(
                     
                     border: const Border(
                      top: BorderSide(color: Colors.black,width: 1.0),
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
                                 
                                  children: [Text('CS-353|',style: TextStyle(fontSize: 15),)],
                                ),
                                Column(
                                  children: [Text('Programming Fundamentals',style: TextStyle(fontSize: 15),)],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('QNo1: Review Difficulty level of question.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
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
                      top: BorderSide(color: Colors.black,width: 1.0),
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
                                  children: [Text('CS-345|',style: TextStyle(fontSize: 15),)],
                                ),
                                Column(
                                  children: [Text('Ecommerce',style: TextStyle(fontSize: 15),)],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('QNo2: Review Difficulty level of question.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                       Container(
                    decoration: BoxDecoration(
                     
                      border: const Border(
                      top: BorderSide(color: Colors.black,width: 1.0),
                      bottom: BorderSide(color: Colors.black,width: 1.0)
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
                                  
                                  children: [Text('CS-384|',style: TextStyle(fontSize: 15),)],
                                ),
                                Column(
                                  children: [Text('Database',style: TextStyle(fontSize: 15),)],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('All questions are not appropriate. \nRecheck them.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
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
