import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/fat32_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/models/fat32/announcement.dart';

const WeekDays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

class QuickOrder extends StatelessWidget {
  List<Widget> getDishesList(List<Current> list) {
    return list
        .map((dish) => ListTile(
              leading: Icon(Icons.local_dining, size: 34),
              title: Text(dish.name),
              subtitle: Text('${dish.price.toString()} UAH'),
              trailing: Icon(Icons.add_circle, size: 20),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final fat32Bloc = Provider.of<Fat32Bloc>(context);
    return StreamBuilder(
      stream: fat32Bloc.announcementResult,
      builder: (BuildContext context,
          AsyncSnapshot<AnnouncementDayResult> snapshot) {
        print(snapshot.hasData);
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        print('onbuild');
        print(snapshot.data);
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(snapshot.data.orderBegin.day.toString(),
                        style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    Text(WeekDays[snapshot.data.orderBegin.weekday - 1],
                        style: TextStyle(fontFamily: 'Railey', fontSize: 76)),
                    Text(snapshot.data.orderBegin.month.toString(),
                        style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.account_balance_wallet),
                  ),
                  Text("${snapshot.data.limit} UAH",
                      style: TextStyle(
                        fontSize: 20,
                      ))
                ],
              ),
//              Row(
//                children: <Widget>[
//                  Padding(
//                      padding: const EdgeInsets.symmetric(
//                        horizontal: 20,
//                        vertical: 10,
//                      ),
//                      child: ListView(
//                        primary: false,
//                        shrinkWrap: true,
//                        physics: NeverScrollableScrollPhysics(),
//                        children: getDishesList(snapshot.data.menu),
//                      )
//                  )
//                ],
//              )
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: getDishesList(snapshot.data.menu),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
