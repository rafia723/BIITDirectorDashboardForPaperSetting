import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

class PaperStatusScreen extends StatefulWidget {
  final int fid;

  const PaperStatusScreen({
    Key? key, 
    required this.fid,
  }) : super(key: key);

  @override
  State<PaperStatusScreen> createState() => _PaperStatusScreenState();
}

class _PaperStatusScreenState extends State<PaperStatusScreen> {
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    loadPaperstatusOfSpecificFaculty();
  }

  Future<void> loadPaperstatusOfSpecificFaculty() async {
    try {
      list = await APIHandler().loadPaperstatusOfSpecificFaculty(widget.fid);
      setState(() {});
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error loading approved papers'),
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
      appBar: customAppBar(context: context, title: 'Paper Status'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20,),
          if (list.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ListView.builder(
  itemCount: list.length,
  itemBuilder: (context, index) {
    Color statusColor = Colors.black; // Default color

    // Set color based on status
    switch (list[index]['status']) {
      case 'uploaded':
        statusColor = Colors.blue;
        break;
      case 'pending':
        statusColor = Colors.red;
        break;
      case 'approved':
      case 'printed':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.black;
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Text(
          list[index]['c_title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              list[index]['status'],
              style: TextStyle(color: statusColor,fontSize: 12), // Set text color based on status
            ),
          ],
        ),
      ),
    );
  },
),
        ],
      ),
    );
  }
}