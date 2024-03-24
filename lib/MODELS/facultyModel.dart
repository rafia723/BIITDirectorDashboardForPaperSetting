class Faculty 
{
   late String name;
   late String username;
   late String password;
   late String status;
  Faculty({required this.name,required this.username,required this.password,required this.status});
  Faculty.fromMap(Map<String,dynamic> map)
  {
      name=map["f_name"];
      username=map["username"];
      password=map["password"];
      status=map["status"];
  }
}