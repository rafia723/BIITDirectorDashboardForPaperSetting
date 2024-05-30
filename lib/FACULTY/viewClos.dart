
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';


class ViewClos extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  const ViewClos({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
  }) : super(key: key);

  @override
  State<ViewClos> createState() => _ViewClosState();
}

class _ViewClosState extends State<ViewClos> {
  List<dynamic> clolist = [];

    Future<void> loadClosWithApprovedStatus(int cid) async {
    try {
      clolist=await APIHandler().loadApprovedClos(cid);
        setState(() {});
      } 
     catch (e) {
      if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }
  @override
  void initState() {
    super.initState();
    loadClosWithApprovedStatus(widget.cid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'View Clos'),
      body: Stack(
        children: [
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
            padding: const EdgeInsets.only(left: 15.0), // Adjust as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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

              ],
            ),
          ),
         
                Positioned(
                top: 100, // Adjust position as needed
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
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                          title: Text(
                            'Clo ${index+1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(clolist[index]['clo_text'],),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: customElevatedButton(onPressed: (){}, buttonText: 'Paper Settings'),
                )
                  ],
                ),
      ),
        ],
    ),   
    );
  }
}
