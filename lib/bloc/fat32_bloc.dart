import 'package:rxdart/rxdart.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/models/fat32/announcement.dart';
import 'package:zeointranet/models/fat32/fat32_api.dart';
import 'package:zeointranet/models/fat32/limit.dart';

const orderBeginTime = "11:00:00";
const originEndTime = "16:30:00";

class Fat32Bloc {
  final Fat32Api fat32Api;
  final SessionBloc sessionBloc;
  AnnouncementPageViews _state;
  List<List<Stream<Current>>> _dishStreams;

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
    AnnouncementResult result;
    try {
      result = await this.fat32Api.getAnnouncementResult(cookies);
    } catch (e) {
      print(e);
      throw e;
    }
    try {
      _state = result.getForToday();
      return _getListOfStreamsFromState();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  AnnouncementPageViewsAsStreams _getListOfStreamsFromState() {
    _dishStreams = Iterable<int>.generate(_state.pages.length)
        .map((pageIndex) =>
            Iterable<int>.generate(_state.pages[pageIndex].menu.length)
                .map((dishIndex) {
              Current dish = _state.pages[pageIndex].menu[dishIndex];
              return BehaviorSubject<Current>.seeded(dish);
            }).toList())
        .toList();
    List<AnnouncementPageViewWithStreams> pages =
        Iterable<int>.generate(_state.pages.length).map((pageIndex) {
      AnnouncementDayResult day = _state.pages[pageIndex];
      List<Stream<Current>> subStreams = _dishStreams[pageIndex];
      return AnnouncementPageViewWithStreams(
        BehaviorSubject<AnnouncementPageDetails>.seeded(AnnouncementPageDetails(
                day.limit,
                QuickOrderStatus.waiting,
                day.orderBegin,
                day.orderEnd)),
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

  AnnouncementPageViews getForToday() {
    DateTime day = DateTime.now();
    int i = announcement.indexWhere((d) => d.date == day);
    if (i == -1) {
      i = announcement.indexWhere((d) {
        return day.compareTo(d.date) >= 0;
      });
    }
    int currentIndex = 0;
    List<AnnouncementDayResult> pages = announcement.map((menu) {
      String key = menu.date.toIso8601String().substring(0, 10);
      ExceededLimits limit =
          limits.exceededLimits.firstWhere((l) => l.date == key);
      AnnouncementDayResult r = AnnouncementDayResult(
        menu: menu.data,
        limit: limit.overLimit,
        orderBegin: getOrderBeginTime(menu.date),
        orderEnd: getOrderEndTime(menu.date),
        prev: currentIndex <= 0 ? null : currentIndex - 1,
        next: currentIndex == -1 || currentIndex >= menu.data.length
            ? null
            : currentIndex + 1,
      );
      currentIndex++;
      return r;
    }).toList();
    return AnnouncementPageViews(
      pages,
      i,
    );
  }

  AnnouncementDayResult getForIndex(int i) {
    if (i < 0 || i >= announcement.length) {
      return null;
    }
    CurrentWithDate menu = announcement[i];
    String key = menu.date.toIso8601String().substring(0, 10);
    ExceededLimits limit =
        limits.exceededLimits.firstWhere((l) => l.date == key);
    if (limit == null) {
      limit = ExceededLimits(overLimit: 0);
    }
    return AnnouncementDayResult(
      menu: menu.data,
      limit: limit.overLimit,
      orderBegin: getOrderBeginTime(menu.date),
      orderEnd: getOrderEndTime(menu.date),
      prev: i <= 0 ? null : i - 1,
      next: i == -1 || i >= menu.data.length ? null : i + 1,
    );
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
  final List<Stream<Current>> dishesSteam;

  AnnouncementPageViewWithStreams(this.detailsStream, this.dishesSteam);
}

class AnnouncementPageViewsAsStreams {
  final List<AnnouncementPageViewWithStreams> pages;
  final int i;
  AnnouncementPageViewsAsStreams(this.pages, this.i);
}

class AnnouncementDayResult {
  List<Current> menu;
  DateTime orderBegin;
  DateTime orderEnd;
  int limit;
  int next;
  int prev;
  AnnouncementDayResult(
      {List<Current> menu,
      int limit,
      DateTime orderBegin,
      DateTime orderEnd,
      int prev,
      int next})
      : orderEnd = orderEnd,
        orderBegin = orderBegin,
        limit = limit,
        prev = prev,
        next = next,
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
