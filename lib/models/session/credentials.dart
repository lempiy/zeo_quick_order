import 'package:zeointranet/models/session/access.dart';

class PreLoginCredentials {
  final String csrfToken;
  final String anonymousSession;
  String _error;
  PreLoginCredentials(this.csrfToken, this.anonymousSession, {String error})
      : _error = error;

  String get error => _error;
}

class JsonDateTime {
  final DateTime value;
  JsonDateTime(this.value);

  String toJson() => value != null ? value.toIso8601String() : null;
}

class SessionWithAccessData {
  final Session session;
  final AccessData accessData;
  SessionWithAccessData(this.session, this.accessData);
}

class Session {
  final String status;
  final String sessionId;
  final DateTime sessionValidTo;
  final String rememberMe;
  Session(this.status, {sessionId, sessionValidTo, rememberMe})
      : this.sessionId = sessionId,
        this.sessionValidTo = sessionValidTo,
        this.rememberMe = rememberMe;
  Map toJson() => {
        'status': status,
        'sessionId': sessionId,
        'sessionValidTo': JsonDateTime(sessionValidTo),
        'rememberMe': rememberMe,
      };
  get cookies => 'PHPSESSID=$sessionId; REMEMBERME=$rememberMe';
  Session.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        sessionId = json['sessionId'],
        sessionValidTo = DateTime.parse(json['sessionValidTo']),
        rememberMe = json['rememberMe'];
}

class LoginRequest {
  String username;
  String password;
  LoginRequest(this.username, this.password);
}

class AuthResult {
  final String sessionId;
  final String rememberMeToken;
  final DateTime sessionValidTo;
  final String error;
  AuthResult(this.sessionId, this.sessionValidTo, this.rememberMeToken, {error})
      : this.error = error;
}
