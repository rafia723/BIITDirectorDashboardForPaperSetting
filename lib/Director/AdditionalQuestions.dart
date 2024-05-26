import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class AdditionlQuestions extends StatefulWidget {
   final int pid;
  const AdditionlQuestions({
    Key? key,
    required this.pid,
  
  }) : super(key: key);
  @override
  State<AdditionlQuestions> createState() => _AdditionlQuestionsState();
}

class _AdditionlQuestionsState extends State<AdditionlQuestions> {
  List<dynamic> qlist = [];
  dynamic paperId;
  
  Map<int, List<dynamic>> cloMap = {};

 

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
loadQuestionsWithPendingStatus(widget.pid);
    setState(() {});
  }

  

  
  

  Future<void> loadQuestionsWithPendingStatus(int pid) async {
    try {
      qlist = await APIHandler().loadQuestionsWithPendingStatus(pid);
      setState(() {
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> loadClosMappedWithTopicData(int tid) async {
    try {
      List<dynamic> list = await APIHandler().loadClosMappedWithTopic(tid);
      cloMap[tid] = list;
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error loading CLOs mapped with topic: $e'),
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
      appBar: customAppBar(context: context, title: 'Additional Questions'),
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
                Expanded(
            child: ListView.builder(
              itemCount: qlist.length,
              itemBuilder: (context, index) {
                final question = qlist[index];
                final imageUrl = question['q_image'];
                final fetchedTopicId = question['t_id'];

                // Fetch CLOs for the current topic if not already fetched
                if (!cloMap.containsKey(fetchedTopicId)) {
                  loadClosMappedWithTopicData(fetchedTopicId);
                }

                final cloList = cloMap[fetchedTopicId] ?? [];
               
                    return Card(
                      
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: GestureDetector(
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              'Question # ${index + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(question['q_text']),
                                if (imageUrl != null)
                                  Image.network(
                                    imageUrl,
                                    height: 150,
                                    width: 300,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                          'Error loading image: $error');
                                    },
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('${question['q_difficulty']},'),
                                    Text('${question['q_marks']},'),
                                    Text(
                                        'CLOs: ${cloList.map((clo) => clo['clo_id']).join(',')}'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.check),
                          ),
                        ),
                      );
                   },
            ),
          )
            ],
          )
        ],
        ),
    ),
    );
  }
}