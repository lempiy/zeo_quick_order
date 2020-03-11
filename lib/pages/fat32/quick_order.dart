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
              trailing: Icon(Icons.add_circle, size: 20, color: Colors.green),
            ))
        .toList();
  }

  List<Widget> _getPages(AnnouncementPageViews pages) {
    return pages.pages.map((p) => SingleChildScrollView(
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
                Text(p.orderBegin.day.toString(),
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text(WeekDays[p.orderBegin.weekday - 1],
                    style: TextStyle(fontFamily: 'Railey', fontSize: 76)),
                Text(p.orderBegin.month.toString(),
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
              Text("${p.limit} UAH",
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
              children: getDishesList(p.menu),
            ),
          )
        ],
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    final fat32Bloc = Provider.of<Fat32Bloc>(context);
    return StreamBuilder(
      stream: fat32Bloc.announcementResult,
      builder: (BuildContext context,
          AsyncSnapshot<AnnouncementPageViews> snapshot) {
        print(snapshot.hasData);
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        PageController controller = PageController(initialPage: snapshot.data.i);
        print('onbuild');
        print(snapshot.data);
        List<Widget> widgets = _getPages(snapshot.data) ?? [];
        return PageView(
          controller: controller,
          children: widgets,
        );
      },
    );
  }
}
