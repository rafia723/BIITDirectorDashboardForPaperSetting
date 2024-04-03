import 'dart:convert';
import 'package:http/http.dart' as http;
class APIHandler{
  String apiUrl='http://192.168.10.12:3000/';

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
  


}

