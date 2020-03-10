import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/models/session/credentials.dart';
import 'package:zeointranet/pages/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String error;
  StreamSubscription<AuthResult> _loginSubscription;
  LoginRequest _data = LoginRequest("", "");

  @override
  void initState() {
    super.initState();
  }

  void _subscribe(SessionBloc bloc) {
    _loginSubscription = _loginSubscription ??
        bloc.loginResult.listen((credentials) {
          if (credentials.error != null) {
            this.setState(() {
              _isLoading = false;
              error = credentials.error;
            });
            return;
          }
          _isLoading = false;
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) => HomePage()));
        });
  }

  void _login(SessionBloc bloc) {
    if (_formKey.currentState.validate()) {
      this.setState(() {
        _isLoading = true;
        _formKey.currentState.save();
        bloc.loginRequest.add(_data);
      });
    }
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  void _close() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  void _clearError() {
    setState(() {
      error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of<SessionBloc>(context);

    _subscribe(loginBloc);
    if (error != null) {
      return AlertDialog(
          title: Text("Error happened"),
          content: Text(error),
          actions: <Widget>[
            FlatButton(child: Text("OK"), onPressed: _clearError),
          ]);
    }

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 150,
                      child: Hero(
                          tag: "logo",
                          child: Image.asset('images/logo.png',
                              fit: BoxFit.contain))),
                  SizedBox(
                    width: 220,
                    child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Theme.of(context).accentColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter username';
                          }
//                                if (!value.contains("@")) {
//                                  return 'Username should be an email';
//                                }
                          return null;
                        },
                        onSaved: (String value) {
                          this._data.username = value;
                        },
                        decoration: new InputDecoration(
                            hintText: 'you@domain.com',
                            labelText: 'ZEO Login')),
                  ),
                  SizedBox(
                    width: 220,
                    child: TextFormField(
                        obscureText: true,
                        cursorColor: Theme.of(context).accentColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          this._data.password = value;
                        },
                        decoration: new InputDecoration(
                            hintText: 'Password',
                            labelText: 'Enter your password')),
                  ),
                  ButtonBar(
                    layoutBehavior: ButtonBarLayoutBehavior.padded,
                    children: (_isLoading
                        ? <Widget>[]
                        : <Widget>[
                            MaterialButton(
                              onPressed: _close,
                              minWidth: 80,
                              height: 40,
                              child: Text("EXIT",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  )),
                            ),
                            MaterialButton(
                              elevation: 0.4,
                              minWidth: 80,
                              height: 40,
                              onPressed: () => _login(loginBloc),
                              textColor: Theme.of(context).accentColor,
                              child: Text("LOGIN"),
                            )
                          ]),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
