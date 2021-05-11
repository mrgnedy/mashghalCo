import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mashghal_co/models/SignupModel.dart';
import 'package:mashghal_co/models/forgetPasswordModel.dart';
import 'package:mashghal_co/models/httpException.dart';
import 'package:mashghal_co/models/userSignUpModel.dart';
import 'package:mashghal_co/models/userSignUpModel.dart' as prefix0;
import 'package:mashghal_co/providers/FCM.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loginModel.dart';

class Auth with ChangeNotifier {
  String _token;
  Login _login;
  SignUpModel _signUp;
  UserSignUpModel _userSignUpModel;
  ForgetPassword _forgetPassword;
  String _userId;
  String _type;
  String userCode;
  String _code;
  bool get isAuth {
    return _token != null;
  }

  String _fcmToken;
  getTokenCallback(String token) {
    _fcmToken = token;
    print('TOKEEEEENOOOOOOOO $_fcmToken');
  }

  Auth() {
    FirebaseNotifications fcm =
        FirebaseNotifications.getToken(getTokenCallback);
  }

  String get code {
    return _code;
  }

  String get type {
    return _type;
  }

  UserSignUpModel get userSignUpModel {
    return _userSignUpModel;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  ForgetPassword get forgetPass {
    return _forgetPassword;
  }

  //------------------------------User Sign Up----------------------------------
  Future userSignUp(
    String name,
    String email,
    String role,
    String phone,
    String password,
  ) async {
    _type = role;
    const url = 'https://mashghllkw.com/api/v1/user/signup';
    try {
      print('FCM $_fcmToken');
      var body = ({
        'google_token': _fcmToken,
        'name': name,
        'email': email,
        'phone': '+966' + phone.toString(),
        'password': password,
        'lat': '10.300000000000000710542735760100185871124267578125',
        'long': '11.300000000000000710542735760100185871124267578125',
        'address': 'maka',
        'role': role,
        'service_type': 'home',
      });
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.post(
        url,
        body: body,
//        headers: headers
      );
      final Map responseData = json.decode(response.body);
      if (responseData.containsKey('validation')) {
        List validation = [];
        validation = responseData['validation'];
        print(':::::::::validation::::::::::' + validation[0].toString());
        throw HttpException(validation[0]);
      } else {
        if (response.statusCode >= 200 && response.statusCode < 300) {
//          userCode = responseData['data']['code'].toString();
//          print(':::::' + userCode);
//          _token = responseData['data']['user']['api_token'];
//          print('::::::' + _token);
//          _userId = responseData['data']['user']['id'].toString();
//          print('::::::' + _userId);
////          print(responseData);
          print('::::::' + response.body);
          _userSignUpModel = UserSignUpModel.fromJson(responseData);
          _token = _userSignUpModel.data.user.apiToken.toString();
          _userId = _userSignUpModel.data.user.id.toString();
          _code = _userSignUpModel.data.code;
          print('::::' + _code);
          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {'token': _token, 'userId': _userId, 'type': _type, 'code': _code},
          );
          prefs.setString('userData', userData);
          return _code;
        } else {
          if (responseData.containsKey('validation')) {
            List validation = [];
            validation = responseData['validation'];
            print(':::::::::validation::::::::::' + validation[0].toString());
            throw HttpException(validation[0]);
          }
        }
      }
    } catch (error) {
      print(error);
//      throw error;
    }
  }

  //------------------------advertiser Sign Up----------------------------------
  Future sPSignUp(
    String lat,
    String long,
    String address,
    String name,
    String email,
    String serviceType,
    String role,
    String phone,
    String password,
    String days,
  ) async {
    _type = role;
    const url = 'https://mashghllkw.com/api/v1/user/signup';
    try {
      final response = await http.post(
        url,
        body: {
          'google_token': _fcmToken,
          'name': name,
          'email': email,
          'phone': '+966' + phone,
          'password': password,
          'lat': lat == null ? '11.3' : lat,
          'long': long == null ? '11.3' : long,
          'address': address == null ? "السعوديه" : address,
          'role': role,
          'service_type': serviceType,
          'services': 'شعر - قص',
          'days': days,
        },
      );
      final responseData = json.decode(response.body);
      print('::::::::::' + response.body);
      if (responseData.containsKey('validation')) {
        print('Contains Validitation');
        List validation = [];
        validation = responseData['validation'];
        return false;
        throw HttpException(validation[0]);
      } else {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _code = responseData['data']['code'];
          print('::::::' + _code);
          _token = responseData['data']['user']['api_token'];
          print('::::::' + _token);
          _userId = responseData['data']['user']['id'].toString();
          print('::::::' + _userId);
//
//          _signUp = SignUpModel.fromJson(responseData);
////          print(':::::' + _signUp.data.code);
////          _token = _signUp.data.user.apiToken;
////          print('::::::::::::::::::::::' + _signUp.data.code);
////          _userId = _signUp.data.user.id.toString();
          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {'token': _token, 'userId': _userId, 'type': _type, 'code': _code},
          );
          prefs.setString('userData', userData);
        } else {
          print('::::::errorr::::');
          if (responseData.containsKey('validation')) {
            List validation = [];
            validation = responseData['validation'];
            print(':::::::::validation::::::::::' + validation[0].toString());
            throw HttpException(validation[0]);
          }
        }
      }
    } catch (error) {
//      print('errorrrrrrrrr' + error.toString());
//      throw error;
    }
  }

  //-----------------------------Login-----------------------------------------
  Future<void> logIn(String phone, String password, String type) async {
    _type = type;
    const url = 'https://mashghllkw.com/api/v1/user/signin';
    try {
      final response = await http.post(
        url,
        body: {
          'google_token': _fcmToken,
          'phone': '+966' + phone,
          'password': password,
          'type': type,
        },
      );
      final responseData = json.decode(response.body);
      print('::::::::::::::::::::::::::' + response.body);
      if (responseData.containsKey('validation')) {
        String validation = responseData['validation'];
        print(':::::::::validation::::::::::' + validation.toString());
        throw HttpException(validation);
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _login = Login.fromJson(responseData);
        _token = _login.data.user.apiToken;
        _userId = _login.data.user.id.toString();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userId': _userId,
            'type': _type,
          },
        );
        prefs.setString('userData', userData);
        return _login;
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  //-----------------------------AutoLogin--------------------------------------
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _type = extractedUserData['type'];
    notifyListeners();
    print('HALO $_fcmToken');
    return true;
  }

  //-----------------------------logout-----------------------------------------
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _type = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //--------------------------ForgetPassword------------------------------------
  String reCode;
  Future forgetPassword(String phone) async {
    _type = type;
    const url = 'https://mashghllkw.com/api/v1/user/send-forget-password';
    try {
      final response = await http.post(
        url,
        body: {
          'phone': '+966$phone',
        },
      );
      final responseData = json.decode(response.body);
      if (responseData.containsKey('validation')) {
        List validation = [];
        validation = responseData['validation'];
        print(':::::::::validation::::::::::' + validation[0].toString());
        throw HttpException(validation[0]);
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _forgetPassword = ForgetPassword.fromJson(responseData);
        print(responseData);
        reCode = _forgetPassword.data.verifyNum.toString();
        final pref = await SharedPreferences.getInstance();
        pref.setString('reCode', reCode);
        print(reCode);
        notifyListeners();
        return _forgetPassword;
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  //-----------------------------VerifyNumber-----------------------------------
  Future verifyNumber(String phone, String Vcode) async {
    _type = type;
    const url = 'https://mashghllkw.com/api/v1/user/verify-forget-password';
    try {
      final response = await http.post(
        url,
        body: {
          'phone': '+966$phone',
          'code': Vcode,
        },
      );
      final responseData = json.decode(response.body);
      if (responseData.containsKey('validation')) {
        List validation = [];
        validation = responseData['validation'];
        print(':::::::::validation::::::::::' + validation[0].toString());
        throw HttpException(validation[0]);
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
        final pref = await SharedPreferences.getInstance();
        pref.setString('reToken', responseData['data']['user']['api_token']);
        pref.setString('email', responseData['data']['user']['email']);
        print(pref.getString('reToken'));
        return responseData;
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future verifyCode(String code) async {
    final pref = await SharedPreferences.getInstance();
    final x = json.decode(pref.getString('userData'))['token'];
    _type = type;

    const url = 'https://mashghllkw.com/api/v1/user/phone-verify';
    print(code);
    try {
      final response = await http.post(url, body: {
        'code': code,
      }, headers: {
        'Authorization': 'Bearer $x',
      });
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData.containsKey('validation')) {
        List validation = [];
        validation = responseData['validation'];
        print(':::::::::validation::::::::::' + validation[0].toString());
        throw HttpException(validation[0]);
      } else {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print(responseData);
          notifyListeners();
          print(
              responseData['data'] != null && responseData['data'].isNotEmpty);
          if (responseData['data'] != null && responseData['data'].isNotEmpty)
            return true;
        } else {
//          print('obj $responseData');
          throw HttpException(responseData['message']);
        }
      }
    } catch (error) {
      print(_token);
//      throw error;
    }
    return false;
  }

  //-----------------------------VerifyNumber-----------------------------------
  Future<void> changePass(String newPassword, String confirmPassword) async {
    final pref = await SharedPreferences.getInstance();
    _token = pref.getString('reToken');
    final _email = pref.getString('email');
    print('no tokeeeeen $_token');
    print('no emaaaaail $_email');
    _type = type;
    const url = 'https://mashghllkw.com/api/v1/user/rechangepass';
    try {
      var body = json.encode(
        {
          'new_pass': newPassword,
          'confirm_pass': newPassword,
          'email': _email
        },
      );
      print(body);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      final responseData = json.decode(response.body);
      if (responseData.containsKey('validation')) {
        List validation = [];
        validation = responseData['validation'];
        print(':::::::::validation::::::::::' + validation[0].toString());
        throw HttpException(validation[0]);
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
        print(responseData);
        return responseData;
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }
  //----------------------------------------------------------------------------
}
