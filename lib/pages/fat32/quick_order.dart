import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/fat32_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';

import '_counter.dart';

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
  Widget getDishesPage(
      Stream<CurrentWithOrder> stream, int pageIndex, int dishIndex) {
    return Builder(builder: (BuildContext context) {
      final fat32Bloc = Provider.of<Fat32Bloc>(context);
      return StreamBuilder<CurrentWithOrder>(
          stream: stream,
          builder: (context, snapshot) {
            print("REBUILD: ${snapshot.hasData}");
            return !snapshot.hasData
                ? Container()
                : ListTile(
                    leading: Icon(Icons.local_dining, size: 32),
                    title: Text(snapshot.data.dish.name),
                    subtitle:
                        Text('${snapshot.data.dish.price.toString()} UAH'),
                    trailing: Counter(
                      initialValue: snapshot.data.quantity,
                      minValue: 0,
                      maxValue: 10,
                      step: 1,
                      decimalPlaces: 0,
                      buttonSize: 20,
                      textStyle:
                          TextStyle(fontFamily: 'Comfortaa', fontSize: 20),
                      onChanged: (value) {
                        // get the latest value from here
                        fat32Bloc.changeDishQuantityValue(
                            pageIndex, dishIndex, value);
                      },
                    ),
                  );
          });
    });
  }

  Widget _getPage(BuildContext context, AnnouncementPageViewWithStreams page,
      int pageIndex) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: StreamBuilder<AnnouncementPageDetails>(
              stream: page.detailsStream,
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(snapshot.data.orderBegin.day.toString(),
                              style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(WeekDays[snapshot.data.orderBegin.weekday - 1],
                              style: TextStyle(
                                  fontFamily: 'Railey', fontSize: 76)),
                          Text(snapshot.data.orderBegin.month.toString(),
                              style: TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      );
              }),
        ),
        StreamBuilder<AnnouncementPageDetails>(
            stream: page.detailsStream,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container()
                  : Row(
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
                    );
            }),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Center(
            child: OutlineButton(
                child: new Text("Schedule"),
                textColor: Colors.white,
                onPressed: () {},
                borderSide: BorderSide(
                  color: Colors.white, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 0.8, //width of the border
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: page.dishesSteam.length,
            itemBuilder: (BuildContext context, int dishIndex) {
              return getDishesPage(
                  page.dishesSteam[dishIndex], pageIndex, dishIndex);
            },
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final fat32Bloc = Provider.of<Fat32Bloc>(context);
    return StreamBuilder(
      stream: fat32Bloc.announcementResult,
      builder: (BuildContext context,
          AsyncSnapshot<AnnouncementPageViewsAsStreams> snapshot) {
        print(snapshot.hasData);
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        PageController controller =
            PageController(initialPage: snapshot.data.i);
        print('onbuild');
        print(snapshot.data);
        return PageView.builder(
          controller: controller,
          itemCount: snapshot.data.pages.length,
          itemBuilder: (BuildContext context, int pageIndex) {
            return _getPage(context, snapshot.data.pages[pageIndex], pageIndex);
          },
        );
      },
    );
  }
}
