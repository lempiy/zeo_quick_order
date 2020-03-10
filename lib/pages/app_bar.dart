import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/bloc/session_bloc.dart';

AppBar getAppBar(SessionBloc sessionBloc) => AppBar(
  leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: sessionBloc.logout),
  elevation: 0.0,
  actions: <Widget>[
    IconButton(icon: Icon(Icons.access_alarm), onPressed: sessionBloc.logout),
  ],
  backgroundColor: Colors.transparent,
  centerTitle: true,
  title: SizedBox(
      width: 87.0,
      child: Padding(
          padding: EdgeInsets.all(18),
          child: Hero(
              tag: "logo",
              child: Image.asset('images/logo.png', fit: BoxFit.contain)
          ))),
);
