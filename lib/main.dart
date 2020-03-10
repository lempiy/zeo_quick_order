import 'package:flutter/material.dart';
import 'package:zeointranet/pages/home.dart';
import 'package:zeointranet/pages/login.dart';
import 'package:zeointranet/router/router.dart';

import 'bloc/session_bloc.dart';
import 'bloc/provider.dart';
import 'models/session/login_api.dart';

void main() => runApp(ZeoApp());

class ZeoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionBloc>(
        builder: (_, bloc) => bloc ?? SessionBloc(LoginApi()),
        onDispose: (_, bloc) => bloc.dispose(),
        child: MaterialApp(
          title: 'ZEO Quick Order',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
            ),
            brightness: Brightness.dark,
            primaryColor: Color(0xFF040404),
            accentColor: Colors.deepOrange,
            fontFamily: 'Comfortaa',
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          home: HomePage(),
          debugShowCheckedModeBanner: false,
          routes: routes,
        ));
  }
}
