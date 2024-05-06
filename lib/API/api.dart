import 'dart:convert';
import 'package:http/http.dart' as http;
class APIHandler{
  String apiUrl='http://192.168.10.12:3000/';
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


  Future<dynamic> loadPaperStatus(int cid) async {
  dynamic status;
    try {
      Uri uri = Uri.parse('${apiUrl}Paper/getPaperStatus/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        status = jsonDecode(response.body);
       
      } else {
        throw Exception('Error....');
      }
    } catch (e) {
      throw Exception('Failed to load clos mapped with topic');
    }
    return status;
  }





}

