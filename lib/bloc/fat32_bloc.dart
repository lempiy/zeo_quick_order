import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/models/fat32/announcement.dart';
import 'package:zeointranet/models/fat32/fat32_api.dart';
import 'package:zeointranet/models/fat32/limit.dart';
import 'package:zeointranet/models/fat32/order.dart';
import 'package:zeointranet/models/notification/notification_api.dart';

const orderBeginTime = "11:00:00";
const originEndTime = "16:30:00";

class Fat32Bloc {
  final Fat32Api fat32Api;
  NotificationApi notificationApi;
  final SessionBloc sessionBloc;
  final LocalStorage _storage = LocalStorage("fat32.json");
  AnnouncementPageViews _state;
  AnnouncementResult _result;
  Map<String, List<Order>> _orders;
  List<List<BehaviorSubject<CurrentWithOrder>>> _dishStreams;

  Stream<AnnouncementPageViewsAsStreams> _announcementResult = Stream.empty();

  BehaviorSubject<AnnouncementPageQuery> _announcementQuery =
      BehaviorSubject.seeded(AnnouncementPageQuery(QueryCommand.init));

  Stream<AnnouncementPageViewsAsStreams> get announcementResult =>
      _announcementResult;
  Sink<AnnouncementPageQuery> get announcementRequest => _announcementQuery;

  Fat32Bloc(this.fat32Api, this.sessionBloc) {
    this.notificationApi = this.notificationApi ??
        NotificationApi(onSelectNotification: this.onSelectNotification,
            onDidReceiveLocalNotification: onDidReceiveNotification);
    _announcementResult =
        _announcementQuery.distinct().asyncMap((AnnouncementPageQuery q) async {
        switch (q.command) {
        case QueryCommand.get:
          return _getListOfData(q);
        case QueryCommand.init:
          return _start(q);
        default:
          throw 'AnnouncementQuery. Unknown command ${q.command}';
      }
    }).asBroadcastStream();
  }

  Future<dynamic> onSelectNotification(String data) {
    print('not get: $data');
  }

  Future<dynamic> onDidReceiveNotification(int id, String data, String a, String b) {
    print('receieve: $data');
  }
  
  Future <AnnouncementPageViewsAsStreams> _start(
      AnnouncementPageQuery q) async {
    print('before initi');
    await this.notificationApi.initialize();
    print('after initia');
    return await _getListOfData(q);
  }

  Future<AnnouncementPageViewsAsStreams> _getListOfData(
      AnnouncementPageQuery q) async {
    String cookies = this.sessionBloc.sessionValue.session.cookies;
    if (_state != null && q.command != QueryCommand.init)
      return _getListOfStreamsFromState();
    try {
      _result = await this.fat32Api.getAnnouncementResult(cookies);
      await _storage.ready;
    } catch (e) {
      throw e;
    }
    try {
      Map<String, dynamic> m = _storage.getItem("orders");
      if (m != null) {
        print('parse map');
        _orders = orderFromMap(m);
      }
      print('orders: $_orders');
      _state = _result.getForToday(_orders);
      return _getListOfStreamsFromState();
    } catch (e) {
      print('main: $e');
      throw e;
    }
  }

  Future<void> scheduleNotification(int id, DateTime date, String text, String payload) async {
    await notificationApi.cancel(id);
    return await notificationApi.schedule(
      id,
      date,
      'Fat32 Order Time',
      text,
      payload,
    );
  }

  void changeDishQuantityValue(int pageIndex, int dishIndex, int value) {
    CurrentWithDate page = _result.announcement[pageIndex];
    Current dish = _result.announcement[pageIndex].data[dishIndex];
    assert(page != null);
    assert(dish != null);
    _orders = _getChangedOrders(page.date, dish, value);
    _orders == null ?  _storage.deleteItem("orders") : _storage.setItem("orders", _orders);
    CurrentWithOrder newDish =
        _result.getForIndex(pageIndex, dishIndex, _orders);
    _dishStreams[pageIndex][dishIndex].add(newDish);
  }

  Map<String, List<Order>> _getChangedOrders(
      DateTime pageDate, Current dish, int value) {
    String key = pageDate.toIso8601String().substring(0, 10);
    int notificationId = (pageDate.millisecondsSinceEpoch / 1e5).floor();
    Map<String, List<Order>> orders = _orders;
    if (orders == null) {
      orders = {
        key: [Order(name: dish.name, quantity: value)]
      };
      if (value > 0) {
        DateTime dateToSchedule = DateTime.parse("$key $orderBeginTime");
        scheduleNotification(notificationId, dateToSchedule,
            "It's time do your quick order", key);
      }
      return orders;
    }
    List<Order> list = orders[key];
    if (list == null) {
      orders[key] = [Order(name: dish.name, quantity: value)];
      if (value > 0) {
        DateTime dateToSchedule = DateTime.parse("$key $orderBeginTime");
        scheduleNotification(notificationId, dateToSchedule,
        "It's time do your quick order", key);
      }
      return orders;
    }
    int index = list.indexWhere((o) =>
      o.name == dish.name);
    if (index != -1) {
      Order target = list[index];
      target.quantity = value;
      list[index] = target;
    } else {
      list.add(Order(name: dish.name, quantity: value));
    }
    orders[key] = list
        .where((o) => o.quantity > 0)
        .toList();
    print(notificationId);
    if (orders[key].length == 0) {
      notificationApi.cancel(notificationId);
      orders.remove(key);
    } else {
      DateTime dateToSchedule = DateTime.parse("$key $orderBeginTime");
      scheduleNotification(notificationId, dateToSchedule,
          "It's time do your quick order", key);
    }
    print("orders length: ${orders[key]}");
    return orders.length > 0 ? orders : null;
  }

  AnnouncementPageViewsAsStreams _getListOfStreamsFromState() {
    _dishStreams = Iterable<int>.generate(_state.pages.length)
        .map((pageIndex) =>
            Iterable<int>.generate(_state.pages[pageIndex].menu.length)
                .map((dishIndex) {
              CurrentWithOrder dish = _state.pages[pageIndex].menu[dishIndex];
              return BehaviorSubject<CurrentWithOrder>.seeded(dish);
            }).toList())
        .toList();
    List<AnnouncementPageViewWithStreams> pages =
        Iterable<int>.generate(_state.pages.length).map((pageIndex) {
      AnnouncementDayResult day = _state.pages[pageIndex];
      List<Stream<CurrentWithOrder>> subStreams = _dishStreams[pageIndex];
      return AnnouncementPageViewWithStreams(
        BehaviorSubject<AnnouncementPageDetails>.seeded(AnnouncementPageDetails(
            day.limit, QuickOrderStatus.waiting, day.orderBegin, day.orderEnd)),
        subStreams,
      );
    }).toList();
    return AnnouncementPageViewsAsStreams(pages, _state.i);
  }

  void dispose() {
    _announcementQuery.close();
  }
}

class AnnouncementResult {
  List<CurrentWithDate> announcement;
  LimitsData limits;
  int index;
  AnnouncementResult(this.announcement, this.limits, {int index})
      : this.index = index;

  AnnouncementPageViews getForToday(Map<String, List<Order>> orders) {
    DateTime day = DateTime.parse(DateTime.now().toIso8601String().substring(0, 10)+" 00:00:00");
    int i = announcement.indexWhere((d) => d.date == day);
    if (i == -1) {
      i = announcement.indexWhere((d) {
        return d.date.compareTo(day) >= 0;
      });
    }

    List<AnnouncementDayResult> pages = announcement.map((menu) {
      String key = menu.date.toIso8601String().substring(0, 10);
      ExceededLimits limit =
          limits.exceededLimits.firstWhere((l) => l.date == key,
              orElse: () => ExceededLimits(date: key, overLimit: 0));
      print('before');
      List<Order> order = orders != null ? orders[key] : null;
      print('after $order');
      List<CurrentWithOrder> orderMenu = menu.data
          .map((dish) => CurrentWithOrder(dish,
              order?.firstWhere((d) => d.name == dish.name,
                  orElse: () => Order(name: dish.name, quantity: 0))?.quantity ?? 0))
          .toList();
      print('here $orderMenu');
      AnnouncementDayResult r = AnnouncementDayResult(
        menu: orderMenu,
        limit: limit.overLimit,
        orderBegin: getOrderBeginTime(menu.date),
        orderEnd: getOrderEndTime(menu.date),
      );
      print('after gere $r');
      return r;
    }).toList();
    print('returrrn');
    return AnnouncementPageViews(
      pages,
      i,
    );
  }

  CurrentWithOrder getForIndex(
      int pageIndex, int dishIndex, Map<String, List<Order>> orders) {
    if (pageIndex < 0 || pageIndex >= announcement.length) {
      return null;
    }
    CurrentWithDate menu = announcement[pageIndex];
    String key = menu.date.toIso8601String().substring(0, 10);
    ExceededLimits limit =
        limits.exceededLimits.firstWhere((l) => l.date == key,
            orElse: () => ExceededLimits(overLimit: 0));
    if (limit == null) {
      limit = ExceededLimits(overLimit: 0);
    }
    List<Order> order = orders != null ? orders[key] : null;
    Current dish = menu.data[dishIndex];
    return CurrentWithOrder(
        dish, order?.firstWhere((d) => d.name == dish.name, orElse: () => Order(name: dish.name, quantity: 0))?.quantity ?? 0);
  }

  DateTime getOrderBeginTime(DateTime date) {
    return DateTime.parse(
        "${date.toIso8601String().substring(0, 10)} $orderBeginTime");
  }

  DateTime getOrderEndTime(DateTime date) {
    return DateTime.parse(
        "${date.toIso8601String().substring(0, 10)} $originEndTime");
  }
}

class AnnouncementPageViews {
  final List<AnnouncementDayResult> pages;
  final int i;
  AnnouncementPageViews(this.pages, this.i);
}

enum QuickOrderStatus {
  waiting,
  active,
}

class AnnouncementPageDetails {
  final int limit;
  final DateTime orderBegin;
  final DateTime orderEnd;
  final QuickOrderStatus status;
  AnnouncementPageDetails(
      this.limit, this.status, this.orderBegin, this.orderEnd);
}

class AnnouncementPageViewWithStreams {
  final Stream<AnnouncementPageDetails> detailsStream;
  final List<Stream<CurrentWithOrder>> dishesSteam;

  AnnouncementPageViewWithStreams(this.detailsStream, this.dishesSteam);
}

class AnnouncementPageViewsAsStreams {
  final List<AnnouncementPageViewWithStreams> pages;
  final int i;
  AnnouncementPageViewsAsStreams(this.pages, this.i);
}

class CurrentWithOrder {
  final Current dish;
  final int quantity;
  CurrentWithOrder(Current dish, int quantity)
      : quantity = quantity,
        dish = dish;
}

class AnnouncementDayResult {
  List<CurrentWithOrder> menu;
  DateTime orderBegin;
  DateTime orderEnd;
  int limit;
  AnnouncementDayResult(
      {List<CurrentWithOrder> menu,
      int limit,
      DateTime orderBegin,
      DateTime orderEnd})
      : orderEnd = orderEnd,
        orderBegin = orderBegin,
        limit = limit,
        menu = menu;
}

enum QueryCommand {
  init,
  get,
}

class AnnouncementPageQuery {
  final QueryCommand command;
  final int pageIndex;
  final int dishIndex;
  AnnouncementPageQuery(this.command, {int pageIndex, int dishIndex})
      : this.pageIndex = pageIndex,
        this.dishIndex = dishIndex;
}
