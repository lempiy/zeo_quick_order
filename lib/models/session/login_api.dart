import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:zeointranet/models/session/access.dart';
import 'package:zeointranet/models/session/parse_cookie.dart';

import 'package:zeointranet/models/session/credentials.dart';

class LoginApi {
  final Client _client = Client();
  static const String _csrf_url = 'https://intranet.zeoalliance.com/login';
  static const String _login_url = 'https://intranet.zeoalliance.com/login_check';
  static const String _access_url = 'https://intranet.zeoalliance.com/api/access/get';

  Future<PreLoginCredentials> getCSRF() async {
    List<String> data =
        await _client.get(Uri.parse(_csrf_url)).then((Response response) {
      if (response.statusCode != 200) {
        throw "Server returned status code ${response.statusCode}";
      }
      String cookie = response.headers["set-cookie"];
      return [response.body, cookie];
    });
    String responseBody = data[0];
    Map<String, CookieValue> cookies = parseCookie(data[1]);
    RegExp regexp = RegExp(
        r'name="_csrf_token"\s+value="([-A-Za-z0-9+/\.\=]+)"',
        caseSensitive: false,
        multiLine: false);
    var matches = regexp.allMatches(responseBody);
    var match = matches.elementAt(0);
    if (match == null) {
      throw "No match in HTML $responseBody";
    }
    String csrf = match.group(1);
    if (csrf == null) {
      throw "No csrf match in HTML $responseBody";
    }
    CookieValue sessionId = cookies['phpsessid'];
    if (sessionId == null) {
      throw "SessionId is missing after login page request";
    }
    return PreLoginCredentials(csrf, sessionId.value);
  }

  Future<AuthResult> login(String username, String password) async {
    PreLoginCredentials credentials = await this.getCSRF();
    Map<String, String> data = {
      "_csrf_token": credentials.csrfToken,
      "_username": username,
      "_password": password,
      "_remember_me": "on",
      "_target_path": "https://intranet.zeoalliance.com/login",
    };
    List<String> parts = [];
    data.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    Map<String, String> requestHeaders = Map<String, String>();
    requestHeaders.putIfAbsent('Content-Type',
        () => 'application/x-www-form-urlencoded; charset=UTF-8');
    requestHeaders.putIfAbsent(
        'Cookie', () => "PHPSESSID=${credentials.anonymousSession}");
      List<CookieValue> session = await _client
          .post(Uri.parse(_login_url), headers: requestHeaders, body: formData)
          .then((response) {
        if (response.statusCode >= 400) {
          throw response.body;
        }
        Map<String, CookieValue> cookies = parseCookie(
            response.headers["set-cookie"]);
        CookieValue userSession = cookies["phpsessid"];
        CookieValue rememberMe = cookies["rememberme"];
        return [userSession, rememberMe];
      });
      return AuthResult(
          session[0].value, session[1].expires.toUtc(), session[1].value);
  }

  Future<AccessData> getAccessData(Session session) async {
    Map<String, String> requestHeaders = Map<String, String>();
    requestHeaders.putIfAbsent('Content-Type',
            () => 'application/json; charset=UTF-8');
    requestHeaders.putIfAbsent(
        'Cookie', () => "PHPSESSID=${session.sessionId}; REMEMBERME=${session.rememberMe}");
    AccessData data = await _client.get(Uri.parse(_access_url), headers: requestHeaders)
        .then((response) => AccessData.fromJson(jsonDecode(response.body)));
    return data;
  }
}