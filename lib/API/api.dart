import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
class APIHandler{
  String apiUrl='http://192.168.10.2:3000/';
 ///////////////////////////////CLO///////////////////////////////////////
  Future<int> addClo(
      String cloText, int cId,String status) async {
    String url = "${apiUrl}Clo/addClo";
    var cloobj = {
      'clo_text': cloText,
      'c_id': cId,
      'status': status
    };
    var json = jsonEncode(cloobj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

  Future<int> updateClo(int cloid, Map<String, dynamic> cloData) async {
  Uri url = Uri.parse('${APIHandler().apiUrl}Clo/editClo/$cloid');
  try {
    var cloJson = jsonEncode(cloData);
    var response = await http.put(
      url,
      body: cloJson,
      headers: {"Content-Type": "application/json"},
    );
      return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
}

 Future<int> updateCloStatus(int id, String newStatus) async {
   String status = newStatus == 'approved' ? 'disapproved' : 'approved';
    Uri url = Uri.parse('${APIHandler().apiUrl}Clo/updateCloStatus/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
     return response.statusCode;
      } catch (error) {
    throw Exception('Error: $error');
  }
 }
/////////////////////////////////////Topic///////////////////////////////////////////////

Future<int> addTopic(String tName, int cId) async {
  String url = "${apiUrl}Topic/addTopic";
  var topicobj = {
    't_name': tName,
    'c_id': cId
  };
  var json = jsonEncode(topicobj);
  Uri uri = Uri.parse(url);
  var response = await http.post(uri,
      body: json,
      headers: {"Content-Type": "application/json; charset=UTF-8"});
  
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    int topicId = responseData['topicId'] as int;
    return topicId;
  } else {
    return -1; 
  }
}
Future<int> addMappingsofCloAndTopic(int topicId, List<dynamic> selectedCloIds) async {
    final response = await http.post(
      Uri.parse("${apiUrl}Clo_Topic_Mapping/addMappingsofCloAndTopic"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tid': topicId,
        'cloIds': selectedCloIds,
      }),
    );
return response.statusCode;
}

  Future<int> deleteTopic(int id) async {
    try{
      Uri url = Uri.parse(
          '${APIHandler().apiUrl}Topic/deleteTopic/$id');
      var response = await http.delete(url);
     return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
  }

 Future<int> updateTopic(int tid, Map<String, dynamic> tData) async {
  Uri url = Uri.parse('${apiUrl}Topic/editTopic/$tid');
  try {
    var topicJson = jsonEncode(tData);
    var response = await http.put(
      url,
      body: topicJson,
      headers: {"Content-Type": "application/json"},
    );
      return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
}


Future<List<dynamic>> loadClosMappedWithTopic(int tid) async {
  List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${apiUrl}Clo_Topic_Mapping/getClosMappedWithTopic/$tid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
       
      } else {
        throw Exception('Error....');
      }
    } catch (e) {
      throw Exception('Failed to load clos mapped with topic');
    }
    return list;
  }

  //  Future<int> deleteCloTopicMapping(int topicId, int cloId) async {
  //   try {
  //     Uri url = Uri.parse('${apiUrl}Clo_Topic_Mapping/deleteMapping/$topicId/$cloId');
  //     var response = await http.delete(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     return response.statusCode;
  //   } catch (error) {
  //     throw Exception('Error: $error');
  //   }
  // }

  // Future<int> addSingleMapping(int cloId, int tid) async {
  // String url = "${apiUrl}Clo_Topic_Mapping/addSingleMapping";
  // var obj = {
  //   'clo_id': cloId,
  //   't_id': tid
  // };
  // var json = jsonEncode(obj);
  // Uri uri = Uri.parse(url);
  // var response = await http.post(uri,
  //     body: json,
  //     headers: {"Content-Type": "application/json; charset=UTF-8"});
  //  return response.statusCode;
  // }


  ///////////////////////////////////////////SubTopics////////////////////////////////////////////
  Future<int> addSubTopic(String stName, int tId) async {
  String url = "${apiUrl}SubTopic/addSubTopic";
  var subtopicobj = {
    'st_name': stName,
    't_id': tId
  };
  var json = jsonEncode(subtopicobj);
  Uri uri = Uri.parse(url);
  var response = await http.post(uri,
      body: json,
      headers: {"Content-Type": "application/json; charset=UTF-8"});
  return response.statusCode;
  }

 Future<int> updateSubTopic(int stid, Map<String, dynamic> stData) async {
  Uri url = Uri.parse('${apiUrl}SubTopic/editSubTopic/$stid');
  try {
    var subtopicJson = jsonEncode(stData);
    var response = await http.put(
      url,
      body: subtopicJson,
      headers: {"Content-Type": "application/json"},
    );
      return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
}

///////////////////////////////////////////////Paper//////////////////////////////////////////////////////
Future<List<dynamic>> loadTeachersByCourseId(int cid) async {
  List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${apiUrl}Paper/getTeachersNamebyCourseId/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
       
      } else {
        throw Exception('Error....');
      }
    } catch (e) {
      throw Exception('Failed to load clos mapped with topic');
    }
    return list;
  }


  Future<dynamic> loadPaperStatus(int cid,int sid) async {
  dynamic status;
    try {
      Uri uri = Uri.parse('${apiUrl}Paper/getPaperStatus/$cid/$sid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        status = jsonDecode(response.body);
       
      } else {
        throw Exception('Error....');
      }
    } catch (e) {
      throw Exception('Failed to load paper status');
    }
    return status;
  }

  Future<int> addPaperHeader (
      String duration,String degree,int tMarks,String term,int year,DateTime date,String session,int NoOfQuestions, int cId,int sid,String status) async {
    String url = "${apiUrl}Paper/addPaperHeaderMids";
    var headerobj = {
      'duration': duration,
      'degree': degree,
      't_marks': tMarks,
      'term': term,
      'year': year,
      'exam_date': date.toString(),
      'session': session,
      'NoOfQuestions': NoOfQuestions,
      'c_id': cId,
      's_id': sid,
      'status': status
    };
    var json = jsonEncode(headerobj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
        
    return response.statusCode;
  }

Future<int> addQuestion(String qtext, Uint8List? qimage, int qmarks, String qdifficulty, String qstatus, int tid, int pid, int fid) async {
  String url = "${apiUrl}Question/addQuestion";

  // Prepare the multipart request
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
  request.fields.addAll({
    'q_text': qtext,
    'q_marks': qmarks.toString(),
    'q_difficulty': qdifficulty,
    'q_status': qstatus,
    't_id': tid.toString(),
    'p_id': pid.toString(),
    'f_id': fid.toString(),
  });
  if (qimage != null) {
    // Attach the image file to the request
    request.files.add(http.MultipartFile.fromBytes('q_image', qimage, filename: 'image.jpg',)); // Set a filename for the image
  }
  // Send the request and await the response
  var response = await request.send();

  // Return the status code
  return response.statusCode;
}



}

