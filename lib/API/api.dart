import 'dart:convert';
import 'dart:typed_data';
import 'package:biit_directors_dashbooard/Model/DifficultyModel.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  String apiUrl = 'http://192.168.141.92:3000/';
  /////////////////////////////////////////////////////////Datacell Module////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////Faculty/////////////////////////////////////////////////////////////////////////

  Future<List<dynamic>> loadFaculty() async {
    List<dynamic> flist = [];
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

  Future<String> loadFacultyName(int fid) async {
    String facultyName = ''; // Variable to store the faculty name
    try {
      Uri uri = Uri.parse(
          "${apiUrl}Faculty/getFacultyName/$fid"); // Assuming endpoint accepts f_id
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decode the response body
        dynamic decodedResponse = jsonDecode(response.body);
        // Extract faculty name if found
        facultyName = decodedResponse['f_name'] ??
            ''; // Extract faculty name or assign empty string if not found
      } else {
        throw Exception('Failed to load Faculty');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return facultyName;
  }

  Future<List<dynamic>> searchFaculty(String query) async {
    List<dynamic> flist = [];
    try {
      Uri url = Uri.parse('${apiUrl}Faculty/searchFaculty?search=$query');
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
    } catch (e) {
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
    List<dynamic> clist = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Course/getCourse');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load course');
      }
      return clist;
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  Future<List<dynamic>> searchCourse(String query) async {
    List<dynamic> clist = [];
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
    } catch (e) {
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

  Future<int> addCourse(
      String cCode, String cTitle, String cHours, String status) async {
    String url = "${apiUrl}Course/addCourse";
    var courseobj = {
      'c_code': cCode,
      'c_title': cTitle,
      'cr_hours': cHours,
      'status': status
    };
    var json = jsonEncode(courseobj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

  ///////////////////////////////////////////////////////////////////Paper/////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadApprovedPapers() async {
    //Faculty & Datacell &Director
    List<dynamic> plist = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Paper/getApprovedPapers');
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

  Future<List<dynamic>> searchApprovedPapers(String courseTitle) async {
    //Faculty & Datacell &Director
    List<dynamic> plist = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}Paper/SearchApprovedPapers?courseTitle=$courseTitle');
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

  Future<List<dynamic>> loadPrintedPapers() async {
    // Datacell &Director
    List<dynamic> plist = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Paper/getPrintedPapers');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        plist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load Printed Papers');
      }
      return plist;
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  Future<List<dynamic>> loadPrintedPapersWithSessionYearAndTerm(
      int year, String session, String term) async {
    List<dynamic> plist = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}Paper/getPrintedPapersWithSessionYearAndTerm?year=$year&session=$session&term=$term');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        plist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load Printed Papers');
      }
      return plist;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> searchPrintedPapersWithSessionTermAndYear(
      String courseTitle, String session, String term, int year) async {
    //Datacell &Director
    List<dynamic> plist = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}Paper/SearchPrintedPapersWithSessionTermAndYear?courseTitle=$courseTitle&session=$session&term=$term&year=$year');
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

  Future<List<dynamic>> searchPrintedPapers(String courseTitle) async {
    //Datacell &Director
    List<dynamic> plist = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}Paper/SearchPrintedPapers?courseTitle=$courseTitle');
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

  Future<List<int>> loadCloNumberOfSpecificCloids(List<dynamic> cloIds) async {
    List<int> list = [];
    try {
      // Convert the list of cloIds to a comma-separated string
      String cloIdsString = cloIds.join(',');

      // Construct the URL with the query parameter
      Uri uri = Uri.parse(
          '${apiUrl}Clo/getCloNumberofSpecificCloIds?clo_ids=$cloIdsString');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> decoded = jsonDecode(response.body);

        // Extract the clo_number field from each object and add it to the list
        list = decoded.map((item) => item['clo_number'] as int).toList();
      } else {
        throw Exception('Failed to load clos');
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> addClo(String cloText, int cId, String status) async {
    String url = "${apiUrl}Clo/addClo";
    var cloobj = {'clo_text': cloText, 'c_id': cId, 'status': status};
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
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}TopicTaught/getcommonSubTopictaught/$cid');

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load common subTopics');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return list;
  }

  Future<List<dynamic>> loadCommonTopics(int cid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}TopicTaught/getcommonTopictaught/$cid');

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load common Topics');
      }
    } catch (e) {
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
      throw Exception(
          'Failed to add TopicTaught. Status code: ${response.statusCode}');
    }
  }

  Future<int> deleteTopicTaught(int ttid) async {
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
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Topic/getTopic/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load Topics');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return list;
  }

  Future<int> addTopic(String tName, int cId) async {
    String url = "${apiUrl}Topic/addTopic";
    var topicobj = {'t_name': tName, 'c_id': cId};
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

  Future<int> addMappingsofCloAndTopic(
      int topicId, List<dynamic> selectedCloIds) async {
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
    try {
      Uri url = Uri.parse('${apiUrl}Topic/deleteTopic/$id');
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

  Future<List<int>> loadClosMappedWithTopic(int tid) async {
    List<int> list = [];
    try {
      Uri uri =
          Uri.parse('${apiUrl}Clo_Topic_Mapping/getClosMappedWithTopic/$tid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        if (decodedBody is List) {
          list = List<int>.from(decodedBody);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error....${response.statusCode}');
      }
      return list;
    } catch (e) {
      throw Exception('Failed to load clos mapped with topic');
    }
  }

  Future<int> updateCloTopicMapping(int tId, List<int> cloIds) async {
    Uri url = Uri.parse('${apiUrl}Clo_Topic_Mapping/updateCloTopicMapping');
    try {
      var body = jsonEncode({
        "t_id": tId,
        "cloIds": cloIds,
      });
      var response = await http.put(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  ///////////////////////////////////////////////////////////SubTopics/////////////////////////////////////////////////////////////////////////////

  Future<List<dynamic>> loadSubTopic(int tid) async {
    List<dynamic> list = [];
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
    var subtopicobj = {'st_name': stName, 't_id': tId};
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
    List<dynamic> list = [];
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

  Future<List<dynamic>> loadPaperstatusOfSpecificFaculty(int id) async {
    List<dynamic> list = [];
    Uri url = Uri.parse(
        '${apiUrl}Paper/getPaperStatusOfCoursesAssignedToFaculty/$id');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw ('Error....');
      }
    } catch (e) {
      throw (e.toString());
    }
    return list;
  }

  Future<dynamic> loadPaperStatus(int cid, int sid) async {
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

  Future<int> addPaperHeader(String duration, String degree, String term,
      DateTime date, int NoOfQuestions, int cId, int sid, String status) async {
    String url = "${apiUrl}Paper/addPaper";
    var headerobj = {
      'duration': duration,
      'degree': degree,
      // 't_marks': tMarks,
      'term': term,
      // 'year': year,
      'exam_date': date.toString(),
      // 'session': session,
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
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Paper/getPaperHeader/$cid/$sid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> loadPaperHeaderOfSpecificPid(int pid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Paper/getPaperHeaderWithPId/$pid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> loadPaperHeaderIfTermMidAndApproved(
      int cid, int sid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          "${apiUrl}Paper/getPaperHeaderIfTermisMidAndApproved/$cid/$sid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> updateHeader(int cid, Map<String, dynamic> HeaderData) async {
    Uri url = Uri.parse(
        '${apiUrl}Paper/UpdatePaper'); // Append cid as a query parameter
    try {
      var paperJson = jsonEncode(HeaderData);
      var response = await http.put(
        url,
        body: paperJson,
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  ///////////////////////////////////////////////////////Session///////////////////////////////////////////////////////////////////////////////

  Future<int> loadFirstSessionId() async {
    dynamic sid;
    try {
      Uri uri = Uri.parse("${apiUrl}Session/getActiveSession");
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
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

/////////////////////////////////////////////////////////////Question/////////////////////////////////////////////////////////////////////

  Future<List<dynamic>> loadQuestion(int pid) async {
    List<dynamic> qlist = [];
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

  Future<List<Map<String, dynamic>>> loadQuestionWithMultipleImages(
      int pId) async {
    List<Map<String, dynamic>> questions = [];
    try {
      Uri uri =
          Uri.parse('${apiUrl}Question/getQuestionWithMultipleImages/$pId');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        if (decodedBody is List) {
          questions = List<Map<String, dynamic>>.from(decodedBody);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
      return questions;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load questions');
    }
  }

  Future<List<Map<String, dynamic>>> loadQuestionByQidWithMultipleImages(
      int qId) async {
    List<Map<String, dynamic>> questions = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}Question/getQuestionByQIDWithMultipleImages/$qId');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        if (decodedBody is List) {
          questions = List<Map<String, dynamic>>.from(decodedBody);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
      return questions;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load questions');
    }
  }

  Future<List<dynamic>> loadQuestionOfSpecificQid(int qid) async {
    List<dynamic> qlist = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Question/getQuestionbyQID/$qid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        qlist = jsonDecode(response.body);
      }
      return qlist;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> updateQuestionStatusFromPendingToUploaded(
      int id, bool newStatus) async {
    String status = newStatus ? 'pending' : 'uploaded';
    Uri url = Uri.parse(
        '${apiUrl}Question/editQuestionStatusFromPendingToUploaded/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      return response.statusCode;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> addQuestionWithMultipleImages(
    String qtext,
    List<Uint8List> qimages, // List of images
    int qmarks,
    String qdifficulty,
    String qstatus,
    int pid,
    int fid,
    int cid,
  ) async {
    String url = "${apiUrl}Question/addQuestionWithMultipleImages";

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    request.fields.addAll({
      'q_text': qtext,
      'q_marks': qmarks.toString(),
      'q_difficulty': qdifficulty,
      'q_status': qstatus,
      'p_id': pid.toString(),
      'f_id': fid.toString(),
      'c_id': cid.toString(),
    });

    for (var i = 0; i < qimages.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'q_images',
        qimages[i],
        filename: 'image$i.jpg',
      ));
    }

    // Send the request and await the response
    var response = await request.send();

    // Parse the response
    var responseBody = await response.stream.bytesToString();
    var parsedResponse = jsonDecode(responseBody);

    // Get the status code
    var statusCode = response.statusCode;

    // Get the q_id from the response if available
    var qId = parsedResponse['q_id'];

    // Return the status code and q_id
    return {'status': statusCode, 'q_id': qId};
  }

  Future<Map<String, dynamic>> addQuestion(
      String qtext,
      Uint8List? qimage,
      int qmarks,
      String qdifficulty,
      String qstatus,
      int pid,
      int fid,
      int cid) async {
    String url = "${apiUrl}Question/addQuestion";

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    request.fields.addAll({
      'q_text': qtext,
      'q_marks': qmarks.toString(),
      'q_difficulty': qdifficulty,
      'q_status': qstatus,
      // 't_id': tid.toString(),
      'p_id': pid.toString(),
      'f_id': fid.toString(),
      'c_id': cid.toString(),
    });
    if (qimage != null) {
      // Attach the image file to the request
      request.files.add(http.MultipartFile.fromBytes(
        'q_image',
        qimage,
        filename: 'image.jpg',
      )); // Set a filename for the image
    }
    // Send the request and await the response
    var response = await request.send();

    // Parse the response
    var responseBody = await response.stream.bytesToString();
    var parsedResponse = jsonDecode(responseBody);

    // Get the status code
    var statusCode = response.statusCode;

    // Get the q_id from the response if available
    var qId = parsedResponse['q_id'];

    // Return the status code and q_id
    return {'status': statusCode, 'q_id': qId};
  }

  Future<int> updateQuestionOfSpecificQid(
      int qid,
      String qtext,
      Uint8List? qimage,
      int qmarks,
      String qdifficulty,
      String qstatus,
      int pid,
      int fid,
      int cid) async {
    String url = "${apiUrl}Question/updateQuestionOfSpecificQid/$qid";

    // Prepare the multipart request
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    request.fields.addAll({
      'q_text': qtext,
      'q_marks': qmarks.toString(),
      'q_difficulty': qdifficulty,
      'q_status': qstatus,
      // 't_id': tid.toString(),
      'p_id': pid.toString(),
      'f_id': fid.toString(),
      'c_id': cid.toString(),
      'q_id': qid.toString()
    });

    if (qimage != null) {
      // Attach the image file to the request
      request.files.add(http.MultipartFile.fromBytes('q_image', qimage,
          filename: 'image.jpg')); // Set a filename for the image
    }

    // Send the request and await the response
    var response = await request.send();

    // Parse the response
    var responseBody = await response.stream.bytesToString();
    var parsedResponse = jsonDecode(responseBody);

    // Get the status code
    var statusCode = response.statusCode;

    // Return the status code
    return statusCode;
  }

///////////////////////////////////////////////////////////SubQuestion////////////////////////////////////////////////////////////////
  Future<Map<String, dynamic>> addSubQuestion(
      String sqtext, Uint8List? sqimage, int qid, int cid) async {
    String url = "${apiUrl}SubQuestions/addSubQuestion";

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    //request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    request.fields.addAll({
      'sq_text': sqtext,
      'q_id': qid.toString(),
      'c_id': cid.toString(),
    });
    if (sqimage != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'sq_image',
        sqimage,
        filename: 'image.jpg',
      )); // Set a filename for the image
    }
    // Send the request and await the response
    var response = await request.send();

    // Parse the response
    var responseBody = await response.stream.bytesToString();
    var parsedResponse = jsonDecode(responseBody);

    // Get the status code
    var statusCode = response.statusCode;

    // Get the q_id from the response if available
    var sqId = parsedResponse['sq_id'];

    // Return the status code and q_id
    return {'status': statusCode, 'sq_id': sqId};
  }

  Future<List<dynamic>> loadSubQuestionOfSpecificQid(int qid) async {
    List<dynamic> sqlist = [];
    try {
      Uri uri = Uri.parse("${apiUrl}SubQuestions/getSubQuestionbyQID/$qid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        sqlist = jsonDecode(response.body);
      }
      return sqlist;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> updateSubQuestionOfSpecificSQid(
      int sqid, String sqtext, Uint8List? sqimage, int cid) async {
    String url = "${apiUrl}SubQuestions/updateSubQuestionOfSpecificsQid/$sqid";

    // Prepare the multipart request
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    request.fields.addAll(
        {'sq_text': sqtext, 'c_id': cid.toString(), 'sq_id': sqid.toString()});

    if (sqimage != null) {
      // Attach the image file to the request
      request.files.add(http.MultipartFile.fromBytes('sq_image', sqimage,
          filename: 'image.jpg')); // Set a filename for the image
    }

    // Send the request and await the response
    var response = await request.send();

    // Parse the response
    var responseBody = await response.stream.bytesToString();
    var parsedResponse = jsonDecode(responseBody);

    // Get the status code
    var statusCode = response.statusCode;

    // Return the status code
    return statusCode;
  }

///////////////////////////////////////TOPCQUESTION////////////////////////////////////////////////////////////////////////////////////

  Future<int> addTopicOfQuestion(int qid, List<int> topicIds) async {
    final response = await http.post(
      Uri.parse("${apiUrl}QuestionTopic/addTopicQuestion"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'q_id': qid,
        'topicIds': topicIds,
      }),
    );

    return response.statusCode;
  }

  Future<List<int>> loadTopicIdMappedWithQuestion(int qid) async {
    List<int> list = [];
    try {
      Uri uri =
          Uri.parse('${apiUrl}QuestionTopic/getTopicIdMappedWithQuestion/$qid');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        if (decodedBody is List) {
          list = List<int>.from(decodedBody);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
      return list;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load Topic ids mapped with question');
    }
  }

  Future<List<dynamic>> loadTopicsDataMappedWithQuestion(int qid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}QuestionTopic/getTopicDataMappedWithQuestion/$qid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Error....');
      }
      return list;
    } catch (e) {
      throw Exception('Failed to load Topics data mapped with question');
    }
  }

  Future<int> updateTopicQuestionMapping(int qId, List<int> topicIds) async {
    Uri url = Uri.parse('${apiUrl}QuestionTopic/updateTopicQuestionMapping');
    try {
      var body = jsonEncode({
        "q_id": qId,
        "topicIds": topicIds,
      });
      var response = await http.put(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<dynamic>> loadClosofSpecificQuestion(int qid) async {
    List<dynamic> list = [];
    try {
      Uri uri =
          Uri.parse("${apiUrl}QuestionTopic/getClosOfSpecificQuesestion/$qid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future<List<dynamic>> loadQuestionsWithSameCloAndSameDifficulty(
  //     List<int> cloList,
  //     String difficulty,
  //     String status,
  //     int excludeId,
  //     int pId) async {
  //   List<dynamic> list = [];
  //   try {
  //     final String baseUrl =
  //         '${apiUrl}Question/getQuestionsByCLODifficultyAndStatus';
  //     final String cloQuery = cloList.map((clo) => 'cloList=$clo').join('&');
  //     Uri uri = Uri.parse(
  //         '$baseUrl?$cloQuery&difficulty=$difficulty&status=$status&excludeId=$excludeId&pId=$pId');
  //     var response = await http.get(uri);

  //     if (response.statusCode == 200) {
  //       list = jsonDecode(response.body);
  //     }
  //     return list;
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }

  Future<List<Map<String, dynamic>>> loadAdditionalQuestions(int pId, List<String> clos, {String? difficulty}) async {
  try {
    // Build the URI with query parameters
    Uri uri = Uri.parse("${apiUrl}Question/getadditionalquestion/$pId");
    Map<String, String> queryParams = {
      'clos': clos.join(','),
    };
    if (difficulty != null && difficulty.isNotEmpty) {
      queryParams['difficulty'] = difficulty;
    }
    uri = uri.replace(queryParameters: queryParams);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load additional questions');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

///////////////////////////////////////////////////////////////Faculty////////////////////////////////////////////////////////////////
  Future<Map<String, dynamic>> loginFaculty(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${apiUrl}Faculty/loginFaculty"),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Login successful',
          'fid': responseData['fid'],
          'fname': responseData['fname']
        };
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Invalid username or password'};
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

//////////////////////////////////////////////////////AssignedCourses//////////////////////////////////////////////////////////////////

  Future<List<dynamic>> loadAssignedCourses(int id) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse("${apiUrl}AssignedCourses/getAssignedCourses/$id");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw ('Data not found for the given id');
      }
      return list;
    } catch (e) {
      throw (e.toString());
    }
  }
//////////////////////////////////////////////////FEEDBAckkkkkk/////////////////////////////////////////////////////////////////////////////

  Future<List<dynamic>> loadCommentsForPaperHeaderOnlyifSenior(int fid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}Feedback/getFeedbackOfPaperHeaderOnlySenior/$fid');

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load ');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return list;
  }


Future<List<dynamic>> loadCommentsForPaperOnlyifSenior(int fid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}Feedback/getFeedbackOfPaperOnlySenior/$fid');

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load ');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return list;
  }

  Future<List<dynamic>> loadCommentsforQuestion(int fid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}Feedback/getFeedbackofQuestionSpecificTeacher/$fid');

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load ');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    return list;
  }

  Future<int> loadSeniorTeacherFidofSpecificCourse(int cid) async {
    try {
      Uri uri = Uri.parse(
          "${apiUrl}AssignedCourses/getSeniorTeacherId/$cid"); // Assuming endpoint accepts c_id
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        dynamic decodedResponse = jsonDecode(response.body);
        int fid = decodedResponse; // Since response is just a number
        return fid;
      } else {
        throw Exception('Failed to load fid');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

//////////////////////////////////////////////////////////Director Module/////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////Paper////////////////////////////////////////////////////////////////////////

  Future<List<dynamic>> loadUploadedPapers() async {
    List<dynamic> list = [];
    Uri uri = Uri.parse('${apiUrl}Paper/getUploadedPapers');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      list = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Uploaded Papers');
    }
    return list;
  }

  Future<List<dynamic>> loadTopicsOfSpecificPaper(int pid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Paper/getTopicIncludedInPaper/$pid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        list = List<String>.from(jsonResponse.map((item) => item[
            't_name'])); // Assuming the API response is a list of maps with 't_name' key
      }
      return list;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> loadTopicsNotIncludedInSpecificPaper(int pid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Paper/getTopicNotIncludedInPaper/$pid");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        list = List<String>.from(jsonResponse.map((item) => item[
            't_name'])); // Assuming the API response is a list of maps with 't_name' key
      }
      return list;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> searchUploadedPapers(String courseTitle) async {
    List<dynamic> list = [];
    Uri uri = Uri.parse(
        '${apiUrl}Paper/SearchUploadedPapers?courseTitle=$courseTitle');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      list = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Uploaded Papers');
    }
    return list;
  }

  Future<List<dynamic>> loadUnUploadedPapers() async {
    List<dynamic> list = [];
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
    List<dynamic> list = [];
    Uri uri = Uri.parse(
        '${apiUrl}Paper/SearchUnUploadedPapers?courseTitle=$courseTitle');
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

  Future<int> updatePaperStatusToPending(int id) async {
    Uri url = Uri.parse('${apiUrl}Paper/editPaperStatusToPending/$id');
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

  Future<int> updatePaperStatusToForwardrdBack(int id) async {
    Uri url = Uri.parse('${apiUrl}Paper/editPaperStatusToRejected/$id');
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

  Future<int> updatePaperStatusToUploaded(int id) async {
    Uri url = Uri.parse('${apiUrl}Paper/editPaperStatusToUploaded/$id');
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

  Future<int> updatePaperStatusToPrinted(int id) async {
    Uri url = Uri.parse('${apiUrl}Paper/editPaperStatusToPrinted/$id');
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
    List<dynamic> qlist = [];
    try {
      Uri uri = Uri.parse(
          "${apiUrl}Question/getQuestionsWithUploadedOrApprovedStatus/$pid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        qlist = jsonDecode(response.body);
      }
      return qlist;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

 Future<List<String>> loadClosMappedWithQuestion(int qid) async {
    List<String> qlist = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Question/getQuestionCLOS/$qid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        qlist = body.map<String>((item) => item['clo_number'] as String).toList();
      }
      return qlist;
    } catch (e) {
      throw Exception('Error: $e');
    }
}

  Future<List<dynamic>> loadQuestionsWithPendingStatus(int pid) async {
    List<dynamic> qlist = [];
    try {
      Uri uri =
          Uri.parse("${apiUrl}Question/getQuestionsWithPendingStatus/$pid");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        qlist = jsonDecode(response.body);
      }
      return qlist;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> updateQuestionStatusToApprovedOrRejected(
      int id, String newStatus) async {
    String status = newStatus.toLowerCase(); // Convert newStatus to lowercase
    if (status != 'approved' && status != 'pending' && status != 'uploaded') {
      throw Exception('Invalid status: $newStatus');
    }

    Uri url = Uri.parse(
        '${apiUrl}Question/editQuestionStatusToApprovedOrRejected/$id');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"newStatus": status}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.statusCode;
      } else {
        throw Exception(
            'Failed to update question status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> updateQuestionStatusToUploaded(int id) async {
    //Additional Question Screen

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

  Future<int> updateQuestionText(int qid, String qText) async {
    Uri url = Uri.parse('${apiUrl}Question/editQuestionText/$qid');
    try {
      var questionJson = jsonEncode({
        'q_text': qText,
      });
      var response = await http.put(
        url,
        body: questionJson,
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

//////////////////////////////////////////////////////////Feedback///////////////////////////////////////////////////////////////////////

  Future<int> addFeedback(
      String feedbackText, int pid, int? qid, int? fid) async {
    String url = "${apiUrl}Feedback/addFeedback";
    var obj = {
      'feedback_details': feedbackText,
      'p_id': pid,
      'q_id': qid,
      'f_id': fid,
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
  Future<List<dynamic>> loadCourseAssignedToFacultyNames(int cid) async {
    List<dynamic> list = [];
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
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Course/getCourseWithEnabledStatus');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load course');
      }
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<dynamic>> loadCoursesWithSeniorRole() async {
    List<dynamic> clist = [];
    try {
      Uri uri =
          Uri.parse('${APIHandler().apiUrl}Course/getCoursesofSeniorTeacher');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load courses with senior role');
      }
      return clist;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> searchCourseWithEnabledStatus(String query) async {
    List<dynamic> list = [];
    try {
      Uri url = Uri.parse(
          '${apiUrl}Course/searchCourseWithEnabledStatus?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw ('Failed to search course');
      }
    } catch (e) {
      throw ('Error: $e');
    }
    return list;
  }

///////////////////////////////////////////////////////////////CLO/////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadClo(int cid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Clo/getClo/$cid');
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

  Future<List<dynamic>> loadApprovedClos(int cid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Clo/getCloWithApprovedStatus/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //////////////////////////////////////////////////CLO Grid View Header//////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadCLOGridHeader() async {
    List<dynamic> list = [];
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
      int cloid, int headerId, int? weightage) async {
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

//   Future<int> updateCloGridWeightage(
//     int cloid, int headerId, int? weightage) async {
//   String url = "${apiUrl}GridView_Weightage/updateGridViewWeightage";
//   var obj = {
//     'clo_id': cloid,
//     'header_id': headerId,
//     'weightage': weightage,
//   };
//   var json = jsonEncode(obj);
//   Uri uri = Uri.parse(url);
//   var response = await http.put(uri,
//       body: json,
//       headers: {"Content-Type": "application/json; charset=UTF-8"});
//   return response.statusCode;
// }

  Future<List<dynamic>> loadCourseCLOGridWeightage(int cid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}GridView_Weightage/getCourseGridViewWeightage/$cid');
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
    List<dynamic> list = [];
    try {
      Uri uri =
          Uri.parse('${apiUrl}GridView_Weightage/getGridViewWeightage/$cloid');
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

  Future<List<dynamic>> loadCourseGridViewWeightageWithSpecificHeader(
      int cid, int hid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}GridView_Weightage/getCourseGridViewWeightageWithSpecificHeader/$cid/$hid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load clo grid weightage');
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> loadClosWeightageofSpecificCourseAndHeaderName(
      int cid, String headerName) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${apiUrl}GridView_Weightage/getCloWeightageofSpecificCourseAndHeaderName/$cid/$headerName');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load clo grid weightage');
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

////////////////////////////////////////////////////////Faculty////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadFacultyWithEnabledStatus() async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse("${apiUrl}Faculty/getFacultyWithEnabledStatus");
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<dynamic>> searchFacultyWithEnabledStatus(String query) async {
    List<dynamic> flist = [];
    try {
      Uri url = Uri.parse(
          '${apiUrl}Faculty/searchFacultyWithEnabledStatus?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        flist = jsonDecode(response.body);
      } else {
        throw ('Failed to search faculty');
      }
    } catch (e) {
      throw ('Error: $e');
    }
    return flist;
  }

  ////////////////////////////////////////////////////////Assign & UnAssign Courses///////////////////////////////////////////////////////

  Future<List<dynamic>> loadUnAssignedCourses(int? id) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}AssignedCourses/getUnAssignedCourses/$id');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<dynamic>> searchUnAssignedCourses(String query, int fid) async {
    List<dynamic> list = [];
    try {
      Uri url = Uri.parse(
          '${apiUrl}AssignedCourses/searchUnAssignedCourses/$fid?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw ('Failed to search unAssigned Courses');
      }
    } catch (e) {
      throw ('Error: $e');
    }
    return list;
  }

  Future<List<dynamic>> loadAssignedCoursesOFSessionAndYear(
      String session, int year) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}AssignedCourses/getAssignedCoursesOfSessionAndYear?session=$session&year=$year');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // throw Exception('Failed to load assigned courses. Status code: ${response.statusCode}');
      } else {
        throw Exception(
            'Failed to load assigned courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
    return list;
  }

  Future<List<dynamic>> searchAssignedCoursesOfSessionAndYear(
      String query, String session, int year) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}AssignedCourses/SearchAssignedCoursesOfSessionAndYear?session=$session&year=$year&courseTitle=$query');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to load courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: ${e.toString()}');
    }
    return list;
  }

  Future<List<dynamic>> loadAssignedCoursesToFacultyInSpecificSessionAndYear(
      int cid, String session, int year, int sid) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse(
          '${APIHandler().apiUrl}AssignedCourses/getAssignedCoursesToFacultyInSpecificSessionAndYear/$cid?session=$session&year=$year&s_id=$sid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('No assigned courses found for the given parameters.');
      } else {
        throw Exception(
            'Failed to load assigned courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      throw Exception('Error occurred: ${e.toString()}');
    }
    // Return the list of assigned courses
    return list;
  }
//////////////////////////////////////////////////////////////Difficulty////////////////////////////////////////////////////////////////

  Future<int> updateDifficulty(Difficulty difficulty) async {
    final Uri url = Uri.parse('${apiUrl}Difficulty/postDifficulty');

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(difficulty.toJson()),
      );
      return response.statusCode;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> loadDifficulty(int noOfQuestions) async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Difficulty/getDifficulty/$noOfQuestions');
      var response = await http.get(uri);

      print(response.statusCode);
      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load');
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//////////////////////////////////////////////////////Session HOD////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> loadSession() async {
    List<dynamic> list = [];
    try {
      Uri uri = Uri.parse('${apiUrl}Session/getSession');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        list = jsonDecode(response.body);
      }
      return list;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<int> addSession(String sname, int year, String status) async {
    String url = "${apiUrl}Session/addSession";
    var obj = {'s_name': sname, 'year': year, 'status': status};
    var json = jsonEncode(obj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

  Future<int> updateSession(int sid, String sname, int year) async {
    Uri url = Uri.parse('${apiUrl}Session/editSession/$sid');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          's_name': sname,
          'year': year,
        }),
      );
      return response.statusCode;
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<int> updateSessionStatus(int sid) async {
    Uri url = Uri.parse('${apiUrl}Session/updateStatusOfSession/$sid');
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
}
