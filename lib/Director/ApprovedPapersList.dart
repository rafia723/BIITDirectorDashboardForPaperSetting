
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class DRTApprovedPapers extends StatefulWidget {
  const DRTApprovedPapers({super.key});

  @override
  State<DRTApprovedPapers> createState() => _DRTApprovedPapersState();
}

class _DRTApprovedPapersState extends State<DRTApprovedPapers> {
  List<dynamic> approvedPlist = [];
TextEditingController search = TextEditingController();


    @override
  void initState() {
    super.initState();
    initializedData();
  }


  Future<void> loadApprovedPapersData() async {
    try {
     approvedPlist=await APIHandler().loadApprovedPapers();
      setState(() {});
    } catch (e) {
      if(mounted){
            showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          );
        },
      );
      }
 
    }  
  }
  void initializedData()async{
    await loadApprovedPapersData();
  }

  Future<void> searchApprovedPapersData(String courseTitle) async {
    try {
       if (courseTitle.isEmpty) {
          loadApprovedPapersData();
        return;
       }
      approvedPlist=await APIHandler().searchApprovedPapers(courseTitle);
      setState(() {
        
      });
    }catch (e) {
      if(mounted){
  showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          );
        },
      );
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
                SizedBox(
                  width: 300,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: search,
                      onChanged: (value) async{
                        await searchApprovedPapersData(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.search,
                        ),
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: approvedPlist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                           title: Text(
                              approvedPlist[index]['c_title'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  approvedPlist[index]['c_code'],
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