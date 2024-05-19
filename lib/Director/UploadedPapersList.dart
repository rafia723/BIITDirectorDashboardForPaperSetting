
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:biit_directors_dashbooard/API/api.dart';

class DRTUploadedPapers extends StatefulWidget {
  const DRTUploadedPapers({super.key});

  @override
  State<DRTUploadedPapers> createState() => _DRTUploadedPapersState();
}

class _DRTUploadedPapersState extends State<DRTUploadedPapers> {
  List<dynamic> uploadedPlist = [];
TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }


  void initializeData() async{
    await loadUploadedPapersData();
  }


 Future<void> loadUploadedPapersData() async {
   try {
       uploadedPlist =await APIHandler().loadUploadedPapers();
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

  Future<void> searchUploadedPapersData(String courseTitle) async {
    try {
       if (courseTitle.isEmpty) {
        loadUploadedPapersData();
         return;
       }
        uploadedPlist = await APIHandler().searchUploadedPapers(courseTitle);
        setState(() {});
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
      appBar: customAppBar(context: context, title: 'Uploaded Papers'),
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
                        await searchUploadedPapersData(value);
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
                    itemCount: uploadedPlist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                           title: Text(
                              uploadedPlist[index]['c_title'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  uploadedPlist[index]['c_code'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                  },
                                  icon: const Icon(Icons.remove_red_eye),
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