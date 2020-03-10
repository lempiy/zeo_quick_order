import 'package:flutter/widgets.dart';
import 'package:zeointranet/pages/home.dart';
import 'package:zeointranet/pages/login.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder> {
  '/home': (BuildContext context) => HomePage(),
  '/login': (BuildContext context) => LoginPage(),
};
