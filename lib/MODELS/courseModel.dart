class Course 
{
   late String ccode;
   late String cTitle;
   late String crHours;
   late String status;
  Course({required this.ccode,required this.cTitle,required this.crHours,required this.status});
  Course.fromMap(Map<String,dynamic> map)
  {
      ccode=map["c_code"];
      cTitle=map["c_title"];
      crHours=map["cr_hours"];
      status=map["status"];
  }
}