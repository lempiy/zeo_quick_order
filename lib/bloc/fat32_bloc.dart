import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/models/fat32/announcement.dart';
import 'package:zeointranet/models/fat32/fat32_api.dart';
import 'package:zeointranet/models/fat32/limit.dart';
import 'package:zeointranet/models/fat32/order.dart';

const orderBeginTime = "11:00:00";
const originEndTime = "16:30:00";

class Fat32Bloc {
  final Fat32Api fat32Api;
  final SessionBloc sessionBloc;
  final LocalStorage _storage = LocalStorage("fat32.json");
  AnnouncementPageViews _state;
  AnnouncementResult _result;
  Map<String, List<Order>> _orders;
  List<List<BehaviorSubject<CurrentWithOrder>>> _dishStreams;

  Stream<AnnouncementPageViewsAsStreams> _announcementResult = Stream.empty();

  BehaviorSubject<AnnouncementPageQuery> _announcementQuery =
      BehaviorSubject.seeded(AnnouncementPageQuery(QueryCommand.request));

  Stream<AnnouncementPageViewsAsStreams> get announcementResult =>
      _announcementResult;
  Sink<AnnouncementPageQuery> get announcementRequest => _announcementQuery;

  Fat32Bloc(this.fat32Api, this.sessionBloc) {
    _announcementResult =
        _announcementQuery.distinct().asyncMap((AnnouncementPageQuery q) async {
      switch (q.command) {
        case QueryCommand.get:
        case QueryCommand.request:
          return _getListOfData(q);
        default:
          throw 'AnnouncementQuery. Unknown command ${q.command}';
      }
    }).asBroadcastStream();
  }

  Future<AnnouncementPageViewsAsStreams> _getListOfData(
      AnnouncementPageQuery q) async {
    String cookies = this.sessionBloc.sessionValue.session.cookies;
    print(cookies);
    if (_state != null && q.command != QueryCommand.request)
      return _getListOfStreamsFromState();
    try {
      _result = await this.fat32Api.getAnnouncementResult(cookies);
      await _storage.ready;
    } catch (e) {
      print(e);
      throw e;
    }
    try {
      _orders = _storage.getItem("orders");
      _state = _result.getForToday(_orders);
      return _getListOfStreamsFromState();
    } catch (e) {
      print('main: ${e}');
      throw e;
    }
  }

  void changeDishQuantityValue(int pageIndex, int dishIndex, int value) {
    CurrentWithDate page = _result.announcement[pageIndex];
    Current dish = _result.announcement[pageIndex].data[dishIndex];
    assert(page != null);
    assert(dish != null);
    String key = page.date.toIso8601String().substring(0, 10);
    _orders = _getChangedOrders(key, dish, value);
    CurrentWithOrder newDish =
        _result.getForIndex(pageIndex, dishIndex, _orders);
    _dishStreams[pageIndex][dishIndex].add(newDish);
  }

  Map<String, List<Order>> _getChangedOrders(
      String key, Current dish, int value) {
    Map<String, List<Order>> orders = _orders;
    if (orders == null) {
      orders = {
        key: [Order(name: dish.name, quantity: value)]
      };
      return orders;
    }
    List<Order> list = orders[key];
    if (list == null) {
      orders[key] = [Order(name: dish.name, quantity: value)];
      return orders;
    }
    orders[key] = list
        .map((o) =>
            o.name == dish.name ? Order(name: o.name, quantity: value) : o)
        .where((o) => o.quantity > 0)
        .toList();
    if (orders[key].length == 0) {
      orders.remove(key);
    }
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
    DateTime day = DateTime.now();
    int i = announcement.indexWhere((d) => d.date == day);
    if (i == -1) {
      i = announcement.indexWhere((d) {
        return day.compareTo(d.date) >= 0;
      });
    }

    List<AnnouncementDayResult> pages = announcement.map((menu) {
      String key = menu.date.toIso8601String().substring(0, 10);
      ExceededLimits limit =
          limits.exceededLimits.firstWhere((l) => l.date == key);
      List<Order> order = orders != null ? orders[key] : null;
      List<CurrentWithOrder> orderMenu = menu.data
          .map((dish) => CurrentWithOrder(dish,
              order?.firstWhere((d) => d.name == dish.name)?.quantity ?? 0))
          .toList();
      AnnouncementDayResult r = AnnouncementDayResult(
        menu: orderMenu,
        limit: limit.overLimit,
        orderBegin: getOrderBeginTime(menu.date),
        orderEnd: getOrderEndTime(menu.date),
      );
      return r;
    }).toList();
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
        limits.exceededLimits.firstWhere((l) => l.date == key);
    if (limit == null) {
      limit = ExceededLimits(overLimit: 0);
    }
    List<Order> order = orders != null ? orders[key] : null;
    Current dish = menu.data[dishIndex];
    return CurrentWithOrder(
        dish, order?.firstWhere((d) => d.name == dish.name)?.quantity ?? 0);
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
  request,
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
