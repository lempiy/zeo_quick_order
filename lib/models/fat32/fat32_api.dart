import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:zeointranet/bloc/fat32_bloc.dart';
import 'package:zeointranet/models/fat32/announcement.dart';
import 'package:zeointranet/models/fat32/limit.dart';

class Fat32Api {
  final Client _client = Client();
  static const String _limit_url =
      'https://pacific-retreat-46679.herokuapp.com/api/fat32/exceeded-limits';
  static const String _announcement_url =
      'https://pacific-retreat-46679.herokuapp.com/api/fat32/announcement';

  Future<AnnouncementResult> getAnnouncementResult(
      String sessionCookies) async {
    return Future.wait([
      this._getLimits(sessionCookies),
      this._getAnnouncement(sessionCookies)
    ]).then((data) {
      print("getAnnouncementResult");
      print(data);
      return AnnouncementResult(data[1], data[0]);
    });
  }

  Future<LimitsData> _getLimits(String sessionCookies) async {
    Map<String, String> requestHeaders = Map<String, String>();
    requestHeaders.putIfAbsent(
        'Content-Type', () => 'application/json; charset=UTF-8');
    requestHeaders.putIfAbsent('Cookie', () => sessionCookies);
    print("getLimits");
    LimitsData data = await _client
        .get(Uri.parse(_limit_url), headers: requestHeaders)
        .then((response) {
      try {
        return LimitsData.fromJson(json.decode(response.body));
      } catch (e) {
        print("LimitsData.fromJson: $e");
        throw e;
      }
    });
    print(data);
    return data;
  }

  Future<List<CurrentWithDate>> _getAnnouncement(String sessionCookies) async {
    Map<String, String> requestHeaders = Map<String, String>();
    requestHeaders.putIfAbsent(
        'Content-Type', () => 'application/json; charset=UTF-8');
    requestHeaders.putIfAbsent('Cookie', () => sessionCookies);
    print("getAnnouncement");
    Announcement data = await _client
        .get(Uri.parse(_announcement_url), headers: requestHeaders)
        .then((response) {
      try {
        return announcementFromJson(response.body);
      } catch (e) {
        print("announcementFromJson: $e");
        throw e;
      }
    });
    return data.getAsSortedList();
  }
}
