import 'package:flutter/material.dart';

BottomNavigationBar getBottomBar(BuildContext context) =>
    BottomNavigationBar(elevation: 0, items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.watch),
          title: Text("Today"),
          activeIcon:
              Icon(Icons.access_time, color: Theme.of(context).accentColor)),
      BottomNavigationBarItem(
          icon: Icon(Icons.today),
          title: Text("Week"),
          activeIcon: Icon(Icons.today, color: Theme.of(context).accentColor)),
    ]);
