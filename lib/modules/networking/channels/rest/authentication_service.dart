// import 'base_service.dart';
//
// class AuthenticationService extends BaseService
// {
//   static Future login(String email, String password) async
//   {
//     var response = await BaseService.postData('login', {'email': email, 'password': password});
//     if(response['token'] != null) {
//       // Save token to local storage
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString(Settings.authToken, response['token']);
//     }
//   }
//
//   static Future<dynamic> register(String email, String password, String name) async
//   {
//     return BaseService.postData('register', {'email': email, 'password': password, 'name': name});
//   }
//
// }