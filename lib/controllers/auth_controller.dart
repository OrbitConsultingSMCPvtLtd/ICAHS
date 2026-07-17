import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/models/token.dart';
import 'package:icahs_hwr/models/user.dart';
import 'package:icahs_hwr/service/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  AuthController(this._http);

  @override
  void onInit() async {
    await checkAuthStatus();
    super.onInit();
  }

  final HttpService _http;
  User? _user;
  Token? _token;

  User? get user => _user;
  Token? get token => _token;

  RxBool isLogin = false.obs;
  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      var res = await _http.postRequest("/login", {
        "p_username": username,
        "p_password": password,
      });
      var body = jsonDecode(res.body);

      if (body['status'] == "ERROR") {
        return {'status': false, 'message': body['message']};
      }

      var prefs = await SharedPreferences.getInstance();

      _user = User.fromJson(body);
      _token = Token(token: body['token'], expiry: body['token_expiry']);

      prefs.setString('user', jsonEncode(_user?.toJson()));
      printInfo(info: "user stored locally");
      prefs.setString('token', jsonEncode(_token?.toJson()));
      printInfo(info: "token stored locally");

      isLogin.value = true;
      return {'status': true, 'message': body['message']};
    } catch (e) {
      return {'status': false, 'message': e.toString()};
    }
  }

  Future<void> checkAuthStatus() async {
    var prefs = await SharedPreferences.getInstance();
    try {
      isLoading.value = true;
      var tkn = prefs.getString('token');
      if (tkn == null) {
        printInfo(info: "token null");
        isLogin.value = false;
        isLoading.value = false;
        return;
      }
      var tknJson = jsonDecode(tkn);

      if (_isTokenExpired(tknJson['token_expiry'])) {
        printInfo(info: "token expired!");
        isLogin.value = false;
        isLoading.value = false;
        return;
      }

      var tUser = prefs.getString('user');
      if (tUser == null) {
        printInfo(info: "User null");
        isLogin.value = false;
        isLoading.value = false;
        return;
      }

      _user = User.fromJson(jsonDecode(tUser));

      print(_user?.toJson());

      isLogin.value = true;
    } catch (e) {
      printError(info: e.toString());
      isLogin.value = false;
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");
    await prefs.remove("user");
  }

  bool _isTokenExpired(String expiry) {
    try {
      final expiryDate = DateTime.parse(expiry.replaceFirst(' ', 'T'));

      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }
}
