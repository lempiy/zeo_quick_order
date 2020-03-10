import 'package:rxdart/rxdart.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/models/fat32/announcement.dart';
import 'package:zeointranet/models/fat32/fat32_api.dart';
import 'package:zeointranet/models/fat32/limit.dart';
import 'package:zeointranet/models/session/credentials.dart';

const orderBeginTime = "11:00:00";
const originEndTime = "12:00:00";

class AnnouncementResult {
  List<CurrentWithDate> announcement;
  LimitsData limits;
  int index;
  AnnouncementResult(this.announcement, this.limits, {int index}) : this.index = index;

  AnnouncementDayResult getForToday() {
    DateTime day =
        DateTime.parse(DateTime.now().toIso8601String().substring(0, 10));
    String key = day.toIso8601String().substring(0, 10);
    ExceededLimits limit =
        limits.exceededLimits.firstWhere((l) => l.date == key);
    if (limit == null) {
      limit = ExceededLimits(overLimit: 0);
    }
    int i = announcement.indexWhere((d) => d.date == day);
    if (i == -1) {
      i = announcement.indexWhere((d) {
        return day.compareTo(d.date) >= 0;
      });
    }
    CurrentWithDate menu =
        i >= 0 ? announcement[i] : CurrentWithDate(date: day, data: []);
    return AnnouncementDayResult(
      menu: menu.data,
      limit: limit.overLimit,
      orderBegin: getOrderBeginTime(menu.date),
      orderEnd: getOrderEndTime(menu.date),
      prev: i <= 0 ? null : i - 1,
      next: i == -1 || i >= menu.data.length ? null : i + 1,
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

class AnnouncementPageQuery {
  final bool forceRefresh;
  final index;
  AnnouncementPageQuery(this.forceRefresh, {int index}) : this.index = index;
}

class Fat32Bloc {
  final Fat32Api fat32Api;
  final SessionBloc sessionBloc;
  AnnouncementResult _lastAnnouncementResult;

  Stream<AnnouncementDayResult> _announcementResult = Stream.empty();

  BehaviorSubject<AnnouncementPageQuery> _announcementQuery = BehaviorSubject.seeded(AnnouncementPageQuery(true));

  Stream<AnnouncementDayResult> get announcementResult => _announcementResult;
  Sink<AnnouncementPageQuery> get announcementRequest => _announcementQuery;

  Fat32Bloc(this.fat32Api, this.sessionBloc) {
    _announcementResult = _announcementQuery.distinct().asyncMap((AnnouncementPageQuery q) async {
      String cookies = this.sessionBloc.sessionValue.session.cookies;
      print(cookies);
      if (_lastAnnouncementResult == null || q.forceRefresh) {
        try {
          AnnouncementResult result =
              await this.fat32Api.getAnnouncementResult(cookies);
          result.index = q.index;
          _lastAnnouncementResult = result;
          return result;
        } catch (e) {
          print(e);
        }
      }
      return _lastAnnouncementResult;
    }).map((result) {
      try {
        AnnouncementDayResult r = result.index == null
            ? result.getForToday()
            : result.getForIndex(result.index);
        return r;
      } catch (e) {
        print(e);
      }
      return null;
    }).asBroadcastStream();
  }

  void dispose() {
    _announcementQuery.close();
  }
}
