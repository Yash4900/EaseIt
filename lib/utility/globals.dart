// Global variables

class Globals {
  String _society;
  String _uid;
  String _email;
  String _fname;
  String _lname;
  String _phoneNum;
  String _flatNo;
  String _wing;
  String _role;
  String _imageUrl;
  Map<dynamic, dynamic> _flat;
  List<String> _hierarchy;
  dynamic _structure;

  static final Globals _instance = Globals._internal();

  factory Globals() => _instance;

  Globals._internal();

  // Getters
  String get society => _society;
  String get uid => _uid;
  String get email => _email;
  String get fname => _fname;
  String get lname => _lname;
  String get phoneNum => _phoneNum;
  String get flatNo => _flatNo;
  String get wing => _wing;
  String get role => _role;
  String get imageUrl => _imageUrl;
  Map<dynamic, dynamic> get flat => _flat;
  List<String> get hierarchy => _hierarchy;
  dynamic get structure => _structure;

  //   Setters
  set setSociety(String society) => _society = society;
  set setUid(String uid) => _uid = uid;
  set setEmail(String email) => _email = email;
  set setFname(String fname) => _fname = fname;
  set setLname(String lname) => _lname = lname;
  set setPhoneNum(String phoneNum) => _phoneNum = phoneNum;
  set setFlatNo(String flatNo) => _flatNo = flatNo;
  set setWing(String wing) => _wing = wing;
  set setRole(String role) => _role = role;
  set setImageUrl(String imageUrl) => _imageUrl = imageUrl;
  set setFlat(Map<dynamic, dynamic> flat) => _flat = flat;
  set setHierarchy(List<String> hierarchy) => _hierarchy = hierarchy;
  set setStructure(dynamic structure) => _structure = structure;
}
