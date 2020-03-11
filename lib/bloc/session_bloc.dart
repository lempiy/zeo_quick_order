import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zeointranet/models/session/access.dart';
import 'package:zeointranet/models/session/credentials.dart';
import 'package:zeointranet/models/session/login_api.dart';

class SessionBloc {
  final LoginApi loginApi;
  final LocalStorage _storage = LocalStorage("login");
  Session _lastSessionValue;
  AccessData _lastAccessData;
  Timer _logoutTimer;

  Stream<AuthResult> _loginResult = Stream.empty();
  Stream<SessionWithAccessData> _sessionStatus = Stream.empty();
  BehaviorSubject<Session> _sessionChange = BehaviorSubject<Session>();

  PublishSubject<LoginRequest> _listenLoginRequest =
      PublishSubject<LoginRequest>();

  Stream<AuthResult> get loginResult => _loginResult;
  Sink<LoginRequest> get loginRequest => _listenLoginRequest;

  SessionBloc(this.loginApi) {
    _loginResult = _listenLoginRequest.asyncMap((credentials) async {
      print(credentials.username);
      try {
        AuthResult result = await this
            .loginApi
            .login(credentials.username, credentials.password);
        Session _session = Session("ok",
            sessionId: result.sessionId,
            sessionValidTo: result.sessionValidTo,
            rememberMe: result.rememberMeToken);
        _logoutTimer = Timer(
            _session.sessionValidTo.difference(DateTime.now().toUtc()), logout);
        print(
            "Start timer ${_session.sessionValidTo.difference(DateTime.now().toUtc())}");
        _storage.setItem("session", _session);
        _sessionChange.add(_session);
        return result;
      } catch (e) {
        return AuthResult(null, null, null, error: e.toString());
      }
    }).asBroadcastStream();

    _sessionStatus = _sessionChange.mergeWith([
      Stream.fromFuture(_storage.ready).asyncMap((ok) async {
        Map<String, dynamic> map = _storage.getItem("session");
        if (map != null && map['status'] == "ok") {
          Session parsedSession = Session.fromJson(map);
          DateTime sessionTimeout = (parsedSession.sessionValidTo);
          _logoutTimer =
              Timer(sessionTimeout.difference(DateTime.now().toUtc()), logout);

          print(
              "Start timer ${sessionTimeout.difference(DateTime.now().toUtc())}");
          return parsedSession;
        }
        return Session("failed");
      })
    ]).asyncMap((s) async {
      print(s.status);
      _lastSessionValue = s;
      print("getAccessData");
      if (s.status == 'ok') {
        _lastAccessData = await loginApi.getAccessData(s);
      }
      print(_lastAccessData);
      return SessionWithAccessData(s, _lastAccessData);
    }).asBroadcastStream();
  }

  logout() {
    if (_logoutTimer != null) _logoutTimer.cancel();
    _storage.deleteItem("session");
    _sessionChange.add(Session("failed"));
  }

  SessionWithAccessData get sessionValue => _lastSessionValue != null
      ? SessionWithAccessData(_lastSessionValue, _lastAccessData)
      : null;
  Stream<SessionWithAccessData> get sessionStatusChanges => _sessionStatus;

  void dispose() {
    _listenLoginRequest.close();
  }
}
