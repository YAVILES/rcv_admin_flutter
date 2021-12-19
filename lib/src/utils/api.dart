class API {
  static const String api = "http://127.0.0.1:8000/api";
  static const String liveBaseURL = "https://remote-ur/api";
  static const String localBaseURL = "http://127.0.0.1:8000/api";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/token/";
  static const String register = baseURL + "/security/user/";
  static const String forgotPassword = baseURL + "/security/forgot-password/";
}
