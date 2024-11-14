
import 'package:biit_directors_dashbooard/Director/paperHeaderScreen.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:biit_directors_dashbooard/API/api.dart';

class DRTUploadedPapers extends StatefulWidget {
   
  List<dynamic>? list;
   DRTUploadedPapers({
    Key? key,
    required this.list,
  }) : super(key: key);
  @override
  State<DRTUploadedPapers> createState() => _DRTUploadedPapersState();
}

class _DRTUploadedPapersState extends State<DRTUploadedPapers> {

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
       widget.list =await APIHandler().loadUploadedPapers();
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
        widget.list = await APIHandler().searchUploadedPapers(courseTitle);
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
                    itemCount: widget.list!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: GestureDetector(
                          onTap: () => {
                              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperHeaderScreen(cid: widget.list![index]['c_id'], 
                                ccode: widget.list![index]['c_code'], 
                                coursename: widget.list![index]['c_title'])))
                          },
                          child: ListTile(
                             title: Text(
                                widget.list![index]['c_title'],
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.list![index]['c_code'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                       Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaperHeaderScreen(cid: widget.list![index]['c_id'], 
                                ccode: widget.list![index]['c_code'], 
                                coursename: widget.list![index]['c_title'])));
                                    },
                                    icon: const Icon(Icons.remove_red_eye),
                                  ),
                                ],
                              ),
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