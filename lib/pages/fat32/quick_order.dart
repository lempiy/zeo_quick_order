import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/fat32_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/models/fat32/announcement.dart';

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
  List<Widget> getDishesList(List<Stream<Current>> streams) {
    print('${streams}');
    return streams
        .map((stream) => Builder(builder: (BuildContext context) {
          print('pre REBUILD');
          return StreamBuilder<Current>(
            stream: stream,
            builder: (context, snapshot) {
              print("REBUILD: ${snapshot.hasData}");
              return !snapshot.hasData
                  ? Container()
                  : ListTile(
                      leading: Icon(Icons.local_dining, size: 32),
                      title: Text(snapshot.data.name),
                      subtitle: Text('${snapshot.data.price.toString()} UAH'),
                      trailing: Counter(
                        initialValue: 0,
                        minValue: 0,
                        maxValue: 10,
                        step: 1,
                        decimalPlaces: 0,
                        buttonSize: 20,
                        textStyle:
                            TextStyle(fontFamily: 'Comfortaa', fontSize: 20),
                        onChanged: (value) {
                          // get the latest value from here
                          print(value);
                        },
                      ),
                    );
            });
        }))
        .toList();
  }

  List<Widget> _getPages(AnnouncementPageViewsAsStreams pages) {
    print('pages call get');
    return pages.pages
        .map((p) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: StreamBuilder<AnnouncementPageDetails>(
                        stream: p.detailsStream,
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                        snapshot.data.orderBegin.day.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Comfortaa',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(
                                        WeekDays[
                                            snapshot.data.orderBegin.weekday -
                                                1],
                                        style: TextStyle(
                                            fontFamily: 'Railey',
                                            fontSize: 76)),
                                    Text(
                                        snapshot.data.orderBegin.month
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Comfortaa',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ],
                                );
                        }),
                  ),
                  StreamBuilder<AnnouncementPageDetails>(
                      stream: p.detailsStream,
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: getDishesList(p.dishesSteam),
                    ),
                  )
                ],
              ),
            ))
        .toList();
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
        List<Widget> widgets = _getPages(snapshot.data) ?? [];
        print('pages length ${widgets.length}');
        return PageView(
          controller: controller,
          children: widgets,
        );
      },
    );
  }
}
