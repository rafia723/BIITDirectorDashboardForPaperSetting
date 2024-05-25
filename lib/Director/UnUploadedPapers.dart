
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:biit_directors_dashbooard/API/api.dart';

class UnUploadedPapersScreen extends StatefulWidget {
   const UnUploadedPapersScreen({Key? key}) : super(key: key);

  @override
  State<UnUploadedPapersScreen> createState() => _UnUploadedPapersScreenState();
}

class _UnUploadedPapersScreenState extends State<UnUploadedPapersScreen> {
  List<dynamic> unUploadedPlist = [];
TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }


  void initializeData() async{
    await loadUnUploadedPapersData();
  }


 Future<void> loadUnUploadedPapersData() async {
   try {
       unUploadedPlist =await APIHandler().loadUnUploadedPapers();
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

  Future<void> searchUnUploadedPapersData(String courseTitle) async {
    try {
       if (courseTitle.isEmpty) {
        loadUnUploadedPapersData();
         return;
       }
        unUploadedPlist = await APIHandler().searchUnUploadedPapers(courseTitle);
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
      appBar: customAppBar(context: context, title: 'Incomplete Submissions'),
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
                        await searchUnUploadedPapersData(value);
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
                    itemCount: unUploadedPlist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                           title: Text(
                              unUploadedPlist[index]['c_title'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  unUploadedPlist[index]['c_code'],
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