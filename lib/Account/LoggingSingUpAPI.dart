import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'TheUser.dart';
import 'logging.dart' as login;
import 'package:celepraty/Users/Setting/userProfile.dart';
User? userGlobal;
String rememberIsLogin = '';
String clintGenerateToken = '';

class DatabaseHelper {
  String serverUrl = "https://mobile.celebrityads.net/api";
  String token = '';

  //logging--------------------------------------------------------------------------------------------
  Future<String> loggingMethod(String username, String password) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      setDeviceToken(deviceToken);
      //////
    }
    Map<String, dynamic> data = {
      "username": username,
      "password": password,
      'device_token': deviceToken
    };
    String url = "$serverUrl/login";
    try {
      final respons = await http.post(Uri.parse(url), body: data);
      //--------------------------------------
      var message = jsonDecode(respons.body)["message"]["en"];
      var state = jsonDecode(respons.body)["data"]?["status"];
      print('logging respons: $message');
      if (state == 200) {
        var username = jsonDecode(respons.body)["data"]?["user"]['username'];
        var email = jsonDecode(respons.body)["data"]?["user"]['email'];
        User u = User.fromJson(jsonDecode(respons.body)["data"]?["user"]);
        userGlobal = u;
        token = jsonDecode(respons.body)['data']['token'];
        var userId = jsonDecode(respons.body)["data"]?["user"]['id'];
        saveToken(token);
        saveUserGlobal(respons.body);
        saveUserData(userId);
        rememberIsLogin = token;
        print('-----------------------------------------------------');
        print('username is: $username');
        print('emial is: $email');

        print('-----------------------------------------------------');
        if (jsonDecode(respons.body)['data']['user']['type'] == 'user') {
          return 'user';
        } else {
          return 'celebrity';
        }
      } else if (message == "Invalid Credentials") {
        return "Invalid Credentials";
      } else if (message == "User not verified") {
        return "User not verified";
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

  //login with Social Media--------------------------------------------------------------------------------------------
  Future<String> loggingWithSocialMediaMethod(
      String email, String token) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      setDeviceToken(deviceToken);
      //////
    }
    Map<String, dynamic> data = {
      "username": email,
      'device_token': deviceToken
    };
    String url = "https://mobile.celebrityads.net/api/social-mobile";
    try {
      final respons =
          await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      var message = jsonDecode(respons.body)["message"]["en"];
      var state = jsonDecode(respons.body)["data"]?["status"];
      print('loggingWithSocialMedia respons: $message');
      if (state == 200) {
        String token = jsonDecode(respons.body)['data']['token'];
        saveToken(token);
        rememberIsLogin = token;
        saveRememberToken(rememberIsLogin);
        var userId = jsonDecode(respons.body)["data"]?["user"]['id'];
        saveUserData(userId);
        if (jsonDecode(respons.body)['data']['user']['type'] == 'user') {
          return 'user';
        } else {
          return 'celebrity';
        }
      } else if (message == "Invalid Credentials") {
        return "Invalid Credentials";
      } else if (message == "User not verified") {
        return "User not verified";
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

  //login with Social Media--------------------------------------------------------------------------------------------
  Future<String> clientTokenSocialMedia() async {
    Map<String, dynamic> data = {
      'grant_type': 'client_credentials',
      'client_id': '6',
      'client_secret': 'BeVOm1yZotgMNrcN4wAuo3lXebOMzmgV1H5uCji2',
      'scope': '*',
    };
    String url = "https://mobile.celebrityads.net/oauth/token";
    try {
      final respons = await http.post(Uri.parse(url), body: data);
      if (respons.statusCode == 200) {
        String token = jsonDecode(respons.body)['access_token'];
        clintGenerateToken = token;
        return 'done';
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
    return "serverException";
  }
  //userRegister--------------------------------------------------------------------------------------------

  Future<String> userRegister(
      String username,
      String password,
      String email,
      String countryId,
      String nationalityId,
      String areaId,
      String cityId,
      String phoneNumber,
      ) async {
    var userType;
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      setDeviceToken(deviceToken);
      //////
    }
    try {
      Map<String, dynamic> data = {
        "username": username,
        "password": password,
        "email": email,
        'country_id': '1',
        'device_token': deviceToken,
        'area_id': areaId,
        'city_id': cityId,
        'nationality_id': nationalityId,
        'phonenumber':phoneNumber
      };
      String url = "$serverUrl/user/new_register";
      final respons = await http.post(Uri.parse(url), body: data);
      print('status register respons: ${respons.body}');
      var message = jsonDecode(respons.body)?["message"]?["en"];
      int? status = jsonDecode(respons.body)?["data"]?["status"];
      print('user register respons: $message');

      //--------------------------------------------------------
      if (status == 200) {
        userType = jsonDecode(respons.body)['data']?['user']?['type'];
        var userId = jsonDecode(respons.body)["data"]?["user"]['id'];
        saveUserData(userId);
        //saveToken(token);
        //saveRememberUserEmail(email);
        //print(userType);
        return '$userType';
      } else if (message != "The email format is incorrect." &&
          message?['email']?[0] == "The email has already been taken." &&
          message['username']?[0] == "The username has already been taken.") {
        //print("email username found");
        return "email and username found";
        //--------------------------------------------------------
      } else if (message != "The email format is incorrect." &&
          message['username']?[0] == "The username has already been taken.") {
        //print("username found");
        return "username found";
      } else if (message != "The email format is incorrect." &&
          message['email']?[0] == "The email has already been taken.") {
        //print("email found");
        return "email found";
        //--------------------------------------------------------
      } else if (message == "The email format is incorrect.") {
        //print("email found");
        return "The email format is incorrect.";
        //--------------------------------------------------------
      }else if (message?["phonenumber"]?[0]=="The phonenumber has already been taken.") {
        //print("email found");
        return "The phonenumber has already been taken.";
        //--------------------------------------------------------
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

//celebrityRegister--------------------------------------------------------------------------------------------
  Future<String> celebrityRegister(
      String username,
      String password,
      String email,
      String nationalityId,
      String categoryId,
      String areaId,
      String cityId,
      String phoneNumber,

      ) async {
    var userType;

    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      setDeviceToken(deviceToken);
      //////
    }
    try {
      Map<String, dynamic> data = {
        "username": username,
        "password": password,
        "email": email,
        'country_id': '1',
        'category_id': categoryId,
        'device_token': deviceToken,
        'nationality_id': nationalityId,
        'area_id': areaId,
        'city_id': cityId,
        'phonenumber':phoneNumber
      };
      String url = "$serverUrl/celebrity/register";
      final respons = await http.post(Uri.parse(url), body: data);
      print(' respons: ${respons.body}');
      var message = jsonDecode(respons.body)?["message"]?["en"];
      int? status = jsonDecode(respons.body)?["data"]?["status"];
      print('user register respons: $message');

      //--------------------------------------------------------
      if (status == 200) {
        //token = jsonDecode(respons.body)['data']['token'];
        userType = jsonDecode(respons.body)['data']?['celebrity']?['type'];
        var userId = jsonDecode(respons.body)["data"]?["celebrity"]?['id'];
        saveUserData(userId);
        //saveToken(token);

        // print('respons body: ${jsonDecode(respons.body)}');
        // print(userType);
        return '$userType';
      } else if (message != "The email format is incorrect." &&
          message['email']?[0] == "The email has already been taken." &&
          message['username']?[0] == "The username has already been taken.") {
        // print("email username found");
        return "email and username found";
        //--------------------------------------------------------
      } else if (message != "The email format is incorrect." &&
          message['username']?[0] == "The username has already been taken.") {
        //print("username found");
        return "username found";
      } else if (message != "The email format is incorrect." &&
          message['email']?[0] == "The email has already been taken.") {
        //print("email found");
        return "email found";
        //--------------------------------------------------------
      } else if (message == "The email format is incorrect.") {
        //print("email found");
        return "The email format is incorrect.";
        //--------------------------------------------------------
      }else if (message?["phonenumber"]?[0]=="The phonenumber has already been taken.") {
        //print("email found");
        return "The phonenumber has already been taken.";
        //--------------------------------------------------------
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

//save facebook access Email------------------------------------------------------------
  static saveFacebookAccessUserEmail(String facebookToken) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'facebook';
    final value = facebookToken;
    prefs.setString(key, value);
    print('saved facebook User Id is: $facebookToken');
  }

  //get facebook access Email------------------------------------------------------------
  static Future<String> getFacebookAccessUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'facebook';
    String value = prefs.getString(key) ?? '';
    print('get facebook User Id is: $value');
    return value;
  }
  //save google access Email------------------------------------------------------------

  static saveGoogleAccessUserEmail(String googleToken) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'Google';
    final value = googleToken;
    prefs.setString(key, value);
    print('saved Google User Id is: $googleToken');
  }

  //get google access Email------------------------------------------------------------
  static Future<String> getGoogleAccessUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'Google';
    String value = prefs.getString(key) ?? '';
    print('get Google User Id is: $value');
    return value;
  }
//save token------------------------------------------------------------

  static saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = token;
    prefs.setString(key, value);
    print('logging token is: $token');
  }
  static saveUserGlobal(String user) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userGlobal';
    final value = user;
    prefs.setString(key, value);
    print('user information: $value');
  }

  //red token------------------------------------------------------------
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    String value = prefs.getString(key) ?? '';
    return value;
  }

  //remember me token------------------------------------------------------------
  static saveRememberToken(String user) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'save';
    prefs.setString(key, rememberIsLogin);
  }

  //get remember me token------------------------------------------------------------
  static Future<String> getRememberToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'save';
    String value = prefs.getString(key) ?? '';
    return value;
  }
  static Future<String> getUserGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userGlobal';
    String value = prefs.getString(key) ?? '';
    return value;
  }
//save Remember User------------------------------------------------------------
  static saveRememberUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user';
    prefs.setString(key, user);
    print('save Remember user: $user');
  }

  //get Remember User------------------------------------------------------------
  static Future<String> getRememberUser() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user';
    String value = prefs.getString(key) ?? '';
    print('get Remember user: $value');
    return value;
  }

//save Remember User Email------------------------------------------------------------
  static saveRememberUserEmail(String user) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'email';
    prefs.setString(key, user);
    print('save Remember email: ${user}');
  }

  //get Remember User Email------------------------------------------------------------
  static Future<String> getRememberUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'email';
    String value = prefs.getString(key) ?? '';
    print('get Remember email: $value');
    return value;
  }

//save user data id------------------------------------------------------------
  static saveUserData(int user) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'data';
    final value = user;
    prefs.setInt(key, value);
    print('saved  User Id is: $user');
  }

  //get user data ------------------------------------------------------------
  static Future<int> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'data';
    int value = prefs.getInt(key) ?? 0;
    print('get  User Id is: $value');
    return value;
  }

//save deviceToken------------------------------------------------------------
  static setDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'device';
    final value = token;
    prefs.setString(key, token);
    print('=====saved  device token is=====: $token');
  }

  //get deviceToken ------------------------------------------------------------
  static Future<String> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'device';
    String value = prefs.getString(key) ?? '';
    print('get  device token is: $value');
    return value;
  }

  static void removeRememberToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'save';
    bool de = await prefs.remove(key);
    print('dddddddddddelete $de');
  }

  static void removeDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'device';
    bool de = await prefs.remove(key);
    print('dddddddddddelete $de');
  }
  static void removeUserGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userGlobal';
    bool de = await prefs.remove(key);
    print('dddddddddddelete $de');
  }
  //remove token-----------------------------------------------------------------
  static void removeRememberUser() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user';
    bool de = await prefs.remove(key);
    print('dddddddddddelete user $de');
  }

  //remove uaser-----------------------------------------------------------------
  static void removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'data';
    bool de = await prefs.remove(key);
    print('dddddddddddelete user $de');
  }

  //remove Remember User Email-----------------------------------------------------------------
  static void removeRememberUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'email';
    bool de = await prefs.remove(key);
    print('dddddddddddelete user $de');
    //
  }

  //remove FacebookUserId-----------------------------------------------------------------
  static void removeFacebookUserEmail() async {
    FacebookAuth.i.logOut();
    final prefs = await SharedPreferences.getInstance();
    const key = 'facebook';
    bool de = await prefs.remove(key);
    print('dddddddelete FacebookUserId $de');
  }

  //remove GoogleUserId-----------------------------------------------------------------
  static void removeGoogleUserEmail() async {
    GoogleSignIn().disconnect();
    final prefs = await SharedPreferences.getInstance();
    const key = 'Google';
    bool de = await prefs.remove(key);
    print('dddddddelete Google email $de');
    //
  }
}
//
