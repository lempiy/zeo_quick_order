import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/models/session/credentials.dart';
import 'package:zeointranet/pages/app_bar.dart';
import 'package:zeointranet/pages/login.dart';

class LoggedInOnly extends StatelessWidget {
  final Widget child;
  LoggedInOnly({Key key, @required Widget child})
      : this.child = child,
        super(key: key);

  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of<SessionBloc>(context);
    return StreamBuilder(
      initialData: loginBloc.sessionValue,
      stream: loginBloc.sessionStatusChanges,
      builder: (BuildContext context, AsyncSnapshot<SessionWithAccessData> snapshot) {
        if (snapshot.hasError) {
          return
            Scaffold(
                body: Center(
                    child: Text('Error: ${snapshot.error}')
                )
            );
        }
        if (snapshot.hasData) {
          print(snapshot.data);
          switch (snapshot.data.session.status) {
            case "failed":
              return LoginPage();
            case "ok":
              return child;
          }
          return null;
        }
        return Scaffold(
            appBar: getAppBar(loginBloc),
            key: ValueKey("loading"),
            body: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }
}
