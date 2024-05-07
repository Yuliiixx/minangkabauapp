class ApiUrl {
  static final ApiUrl _instance = ApiUrl._internal();

  factory ApiUrl() {
    return _instance;
  }

  ApiUrl._internal();

  // String baseUrl = "http://192.168.43.102/APIbudaya/";
  String baseUrl = "http://192.168.43.141/APIbudaya/";
  //  String baseUrl = "http://10.0.0.2/APIbudaya/";
}