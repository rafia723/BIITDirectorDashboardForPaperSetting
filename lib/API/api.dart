import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
class APIHandler{
  String apiUrl='http://192.168.10.7:3000/';
  /////////////////////////////////////////////////////////Datacell Module////////////////////////////////////////////////////////////////////////////

 ///////////////////////////////////////////////////////////Faculty/////////////////////////////////////////////////////////////////////////

Future<List<dynamic>> loadFaculty() async {
  List<dynamic> flist=[];
  try {
    Uri uri = Uri.parse("${apiUrl}Faculty/getFaculty");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      flist = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Faculty');
    }
  } catch (e) {
    throw Exception('Error: $e');
    }
    return flist;
}

Future<List<dynamic>> searchFaculty(String query) async {
    List<dynamic> flist=[];
    try {
      Uri url = Uri.parse(
          '${apiUrl}Faculty/searchFaculty?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        flist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to search faculty');
      }
    } catch (e) {
     throw Exception('Error: $e');
    }
    return flist;
  }

  Future<int> updateFacultyStatus(int id, bool newStatus) async {
  String status = newStatus ? 'enabled' : 'disabled';
  Uri url = Uri.parse('${apiUrl}Faculty/editFacultyStatus/$id');
  try {
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );
    return response.statusCode;
  }
   catch (e) {
   throw Exception('Error: $e');
  }
   
}

Future<int> updateFaculty(int id, Map<String, dynamic> facultyData) async {
  Uri url = Uri.parse('${apiUrl}Faculty/editFaculty/$id');
  try {
    var facultyJson = jsonEncode(facultyData);
    var response = await http.put(
      url,
      body: facultyJson,
      headers: {"Content-Type": "application/json"},
    );
      return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
}

Future<int> addFaculty(
      String name, String username, String password, String status) async {
    String url = "${apiUrl}Faculty/addFaculty";
    var facultyobj = {
      'f_name': name,
      'username': username,
      'password': password,
      'status': status
    };
    var json = jsonEncode(facultyobj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

/////////////////////////////////////////////////////////////////Course///////////////////////////////////////////////////////////////////////////
 
   Future<List<dynamic>> loadCourse() async {
    List<dynamic> clist=[];
    try {
      Uri uri = Uri.parse('${apiUrl}Course/getCourse');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load course');
      }
      return clist;
    } 
    catch (e) {
      throw Exception('Error $e');
    }
  }

  Future<List<dynamic>> searchCourse(String query) async {
    List<dynamic> clist=[];
    try {
      Uri url = Uri.parse('${apiUrl}Course/searchCourse?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to search course');
      }
    } catch (e) {
     throw Exception('Error: $e');
    }
    return clist;
  }

   Future<int> updateCourseStatus(int id, bool newStatus) async {
  String status = newStatus ? 'enabled' : 'disabled';
  Uri url = Uri.parse('${apiUrl}Course/editCourseStatus/$id');
  try {
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );
    return response.statusCode;
  }
   catch (e) {
   throw Exception('Error: $e');
  }
   
}

Future<int> updateCourse(int id, Map<String, dynamic> courseData) async {
  Uri url = Uri.parse('${apiUrl}Course/editCourse/$id');
  try {
    var courseJson = jsonEncode(courseData);
    var response = await http.put(
      url,
      body: courseJson,
      headers: {"Content-Type": "application/json"},
    );
      return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
}

 Future<int> addCourse(String cCode,String cTitle,String cHours,String status)async
  {
String url="${apiUrl}Course/addCourse";
    var courseobj={
      'c_code':cCode,
      'c_title':cTitle,
      'cr_hours':cHours,
      'status':status
    };
    var json=jsonEncode(courseobj);
    Uri uri=Uri.parse(url);
    var response =await  http.post(uri,body: json,headers:{"Content-Type":"application/json; charset=UTF-8"});
   return response.statusCode;
  }

  ///////////////////////////////////////////////////////////////////Paper/////////////////////////////////////////////////////////////////////////
 Future<List<dynamic>> loadApprovedPapers() async {    //Faculty & Datacell &Director
  List<dynamic>plist=[];
  try{
    Uri uri = Uri.parse('${apiUrl}Paper/getApprovedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      plist = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Approved Papers');
    }
    return plist;
    }catch(e){
        throw Exception('Error $e');
    }
  }

  Future<List<dynamic>> searchApprovedPapers(String courseTitle) async {            //Faculty & Datacell &Director
      List<dynamic>plist=[];      
  try {
      Uri uri = Uri.parse('${apiUrl}Paper/SearchApprovedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        plist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load Approved Papers');
      }
      return plist;
  } catch (e) {
    throw Exception('Error $e');
  }
}

 Future<List<dynamic>> loadPrintedPapers() async {             // Datacell &Director
  List<dynamic>plist=[];
  try{
    Uri uri = Uri.parse('${apiUrl}Paper/getPrintedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      plist = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Printed Papers');
    }
    return plist;
    }catch(e){
        throw Exception('Error $e');
    }
  }

   Future<List<dynamic>> searchPrintedPapers(String courseTitle) async {  //Datacell &Director
      List<dynamic>plist=[];
  try {
      Uri uri = Uri.parse('${apiUrl}Paper/SearchPrintedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        plist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load printed Papers');
      }
      return plist;
  } catch (e) {
    throw Exception('Error $e');
  }
}

/////////////////////////////////////////////////////////////Faculty Module//////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////CLO//////////////////////////////////////////////////////////////////////////
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
  Uri url = Uri.parse('${apiUrl}Clo/editClo/$cloid');
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
    Uri url = Uri.parse('${apiUrl}Clo/updateCloStatus/$id');
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
//////////////////////////////////////////////////////////////////Topic////////////////////////////////////////////////////////////////////
 Future<List<dynamic>> loadCommonSubTopics(int cid) async {
    List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}TopicTaught/getcommonSubTopictaught/$cid');
      
      var response = await http.get(uri);

      if (response.statusCode == 200) {
          list = jsonDecode(response.body);
      }
       else {
        throw Exception('Failed to load common subTopics');
      }
     }catch (e) {
     throw Exception('Error: $e');
    }
    return list;
  }

Future<int> addTopicTaught(int tid, int? stid, int fid) async {
  String url = "${apiUrl}TopicTaught/addTopicTaught";
  var obj = {
    't_id': tid,
    'st_id': stid,
    'f_id': fid,
  };
  var json = jsonEncode(obj);
  Uri uri = Uri.parse(url);
  var response = await http.post(
    uri,
    body: json,
    headers: {"Content-Type": "application/json; charset=UTF-8"},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    int id = responseData['id'] as int;
    return id;
  } else {
    throw Exception('Failed to add TopicTaught. Status code: ${response.statusCode}');
  }
}

Future<int> deleteTopicTaught (int ttid) async {
    String url = "${apiUrl}TopicTaught/deleteTopicTaught";
    var obj = {
      'tt_id': ttid,
    };
    var json = jsonEncode(obj);
    Uri uri = Uri.parse(url);
    var response = await http.delete(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

   Future<List<dynamic>> getTopicTaught(int fid) async {
    final response = await http.get(
      Uri.parse('${apiUrl}TopicTaught/getTopicTaught/$fid'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load topics taught');
    }
  }

 Future<List<dynamic>> loadTopics(int cid) async {
    List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Topic/getTopic/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
          list = jsonDecode(response.body);
      }
       else {
        throw Exception('Failed to load Topics');
      }
     }catch (e) {
     throw Exception('Error: $e');
    }
    return list;
  }

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
          '${apiUrl}Topic/deleteTopic/$id');
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

  ///////////////////////////////////////////////////////////SubTopics/////////////////////////////////////////////////////////////////////////////
 
 Future<List<dynamic>> loadSubTopic(int tid) async {
  List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}SubTopic/getSubTopic/$tid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);

       // return subtopics;
      } else {
        throw Exception('Failed to load sub-topics');
      }
    } catch (e) {
     throw Exception('Error: $e');
    
    }
      return list;
  }

 
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

///////////////////////////////////////////////////////////////Paper/////////////////////////////////////////////////////////////////////////
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

Future<List<dynamic>> loadPaperHeader(int cid, int sid) async {
  List<dynamic> list=[];
    try {
      Uri uri =
          Uri.parse("${apiUrl}Paper/getPaperHeader/$cid/$sid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
      list=jsonDecode(response.body);
      
    } return list;
    }catch (e) {
      throw Exception('Error: $e');
    }
  }

  ///////////////////////////////////////////////////////Session///////////////////////////////////////////////////////////////////////////////

  Future<int> loadSession() async {
    dynamic sid;
    try {
      Uri uri = Uri.parse("${apiUrl}Session/getSession");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          // Assuming you only need the first session data if multiple are returned
          Map<String, dynamic> sessionData = responseData[0];
           sid = sessionData['s_id'];
        } 
      }
      return sid;
    } 
    catch(e){
      throw Exception('Error: $e');
    }
  }

/////////////////////////////////////////////////////////////Question/////////////////////////////////////////////////////////////////////

 Future<List<dynamic>> loadQuestion(int pid) async {
  List<dynamic> qlist=[];
    try {
      Uri uri = Uri.parse("${apiUrl}Question/getQuestion/$pid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
          qlist = jsonDecode(response.body);
      } 
      return qlist;
    } catch (e) {
     throw Exception('Error: $e');
    }
  }

  Future<int> updateQuestionStatusFromPendingToUploaded(int id, bool newStatus) async {
  String status = newStatus ? 'pending' : 'uploaded';
  Uri url = Uri.parse('${apiUrl}Question/editQuestionStatusFromPendingToUploaded/$id');
  try {
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );
    return response.statusCode;
  }
   catch (e) {
   throw Exception('Error: $e');
  } 
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






//////////////////////////////////////////////////////////Director Module/////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////Paper////////////////////////////////////////////////////////////////////////

Future<List<dynamic>> loadUploadedPapers() async {
  List<dynamic> list=[];
    Uri uri = Uri.parse('${apiUrl}Paper/getUploadedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      list = jsonDecode(response.body);
     
    } else {
      throw Exception('Failed to load Uploaded Papers');
    }
    return list;
  }

  Future<List<dynamic>> searchUploadedPapers(String courseTitle) async {
    List<dynamic> list=[];
      Uri uri = Uri.parse('${apiUrl}Paper/SearchUploadedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load Uploaded Papers');
      }
      return list;
  }


Future<List<dynamic>> loadUnUploadedPapers() async {
  List<dynamic> list=[];
    Uri uri = Uri.parse('${apiUrl}Paper/getUnUploadedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      list = jsonDecode(response.body);
     
    } else {
      throw Exception('Failed to load UnUploaded Papers');
    }
    return list;
  }

  Future<List<dynamic>> searchUnUploadedPapers(String courseTitle) async {
    List<dynamic> list=[];
      Uri uri = Uri.parse('${apiUrl}Paper/SearchUnUploadedPapers?courseTitle=$courseTitle');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load UnUploaded Papers');
      }
      return list;
  }


// Future<List<dynamic>> loadApprovedAndPrintedPapers() async {
//   List<dynamic> list=[];
//     Uri uri = Uri.parse('${apiUrl}Paper/getApprovedAndPrintedPapers');
//     var response = await http.get(uri);
//     if (response.statusCode == 200) {
//       list = jsonDecode(response.body);
     
//     } else {
//       throw Exception('Failed to load Approved and Printed Papers');
//     }
//     return list;
//   }

//    Future<List<dynamic>> searchApprovedAndPrintedPapers(String courseTitle) async {
//     List<dynamic> list=[];
//       Uri uri = Uri.parse('${apiUrl}Paper/SearchApprovedAndPrintedPapers?courseTitle=$courseTitle');
//       var response = await http.get(uri);
//       if (response.statusCode == 200) {
//         list = jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to load Approved and Printed Papers');
//       }
//       return list;
//   }


   Future<int> updatePaperStatusToApproved(int id) async {
   
    Uri url = Uri.parse('${apiUrl}Paper/editPaperStatusToApproved/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
      );
     return response.statusCode;
      } catch (error) {
    throw Exception('Error: $error');
  }
 }




////////////////////////////////////////////////////////Question//////////////////////////////////////////////////////////////////////////

 Future<List<dynamic>> loadQuestionsWithUploadedStatus(int pid) async {
  List<dynamic> qlist=[];
    try {
      Uri uri = Uri.parse("${apiUrl}Question/getQuestionsWithUploadedStatus/$pid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
          qlist = jsonDecode(response.body);
      } 
      return qlist;
    } catch (e) {
     throw Exception('Error: $e');
    }
  }


 Future<List<dynamic>> loadQuestionsWithPendingStatus(int pid) async {
  List<dynamic> qlist=[];
    try {
      Uri uri = Uri.parse("${apiUrl}Question/getQuestionsWithPendingStatus/$pid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
          qlist = jsonDecode(response.body);
      } 
      return qlist;
    } catch (e) {
     throw Exception('Error: $e');
    }
  }

Future<int> updateQuestionStatusToApprovedOrRejected(int id, String newStatus) async {
  String status = newStatus.toLowerCase(); // Convert newStatus to lowercase
  if (status != 'approved' && status != 'rejected' && status != 'uploaded') {
    throw Exception('Invalid status: $newStatus');
  }
  
  Uri url = Uri.parse('${apiUrl}Question/editQuestionStatusToApprovedOrRejected/$id');
  try {
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"newStatus": status}),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.statusCode;
    } else {
      throw Exception('Failed to update question status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}


Future<int> updateQuestionStatusToUploaded(int id) async {   //Additional Question Screen
   
    Uri url = Uri.parse('${apiUrl}Question/editQuestionStatusToUploaded/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
      );
     return response.statusCode;
      } catch (error) {
    throw Exception('Error: $error');
  }
 }



//////////////////////////////////////////////////////////Feedback///////////////////////////////////////////////////////////////////////


Future<int> addFeedback(
      String feedbackText, int pid , int? qid) async {
    String url = "${apiUrl}Feedback/addFeedback";
    var obj = {
      'feedback_details': feedbackText,
      'p_id': pid,
      'q_id': qid,
    };
    var json = jsonEncode(obj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }






///////////////////////////////////////////////////////////////HOD/////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////Course////////////////////////////////////////////////////////////////////////
 Future< List<dynamic>> loadCourseAssignedToFacultyNames(int cid) async {
  List<dynamic> list=[];
    try {
      Uri uri =
          Uri.parse("${APIHandler().apiUrl}AssignedCourses/getAssignedTo/$cid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      
      } 
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<dynamic>> loadCourseWithEnabledStatus() async {
    List<dynamic> list=[];
    try {
      Uri uri =
          Uri.parse('${apiUrl}Course/getCourseWithEnabledStatus');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list =jsonDecode(response.body);
      } else {
        throw Exception('Failed to load course');
      }
    return list;
    } catch (e) {
    throw Exception(e);
    }
  }

///////////////////////////////////////////////////////////////CLO/////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadClo(int cid) async {
     List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Clo/getClo/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);

      } else {
        throw Exception('Failed to load clos');
      }
   return list;
    } catch (e) {
       throw Exception(e);
    }
  }
  //////////////////////////////////////////////////CLO Grid View Header//////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadCLOGridHeader() async {
     List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${apiUrl}Gridview_Header/getGridViewHeader');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);

      } else {
        throw Exception('Failed to load clo grid header');
      }
   return list;
    } catch (e) {
       throw Exception(e);
    }
  }

//////////////////////////////////////////////////////Grid view weightage///////////////////////////////////////////////////////////////

Future<int> addCloGridWeightage(
      int cloid, int headerId , int? weightage) async {
    String url = "${apiUrl}GridView_Weightage/addGridViewWeightage";
    var obj = {
      'clo_id': cloid,
      'header_id': headerId,
      'weightage': weightage,
    };
    var json = jsonEncode(obj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

  Future<List<dynamic>> loadCourseCLOGridWeightage(int cid) async {
     List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${apiUrl}GridView_Weightage/getCourseGridViewWeightage/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);

      } else {
        throw Exception('Failed to load clo grid weightage');
      }
   return list;
    } catch (e) {
       throw Exception(e);
    }
  }

 Future<List<dynamic>> loadCLOGridWeightageofClo(int cloid) async {
     List<dynamic> list=[];
    try {
      Uri uri = Uri.parse('${apiUrl}GridView_Weightage/getGridViewWeightage/$cloid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);

      } else {
        throw Exception('Failed to load clo grid weightage');
      }
   return list;
    } catch (e) {
       throw Exception(e);
    }
  }


}