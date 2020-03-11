// To parse this JSON data, do
//
//     final accessData = accessDataFromJson(jsonString);

import 'dart:convert';

AccessData accessDataFromJson(String str) =>
    AccessData.fromJson(json.decode(str));

String accessDataToJson(AccessData data) => json.encode(data.toJson());

class AccessData {
  User user;
  Modules modules;
  String environment;
  String host;
  int revision;
  String captchaKey;

  AccessData({
    this.user,
    this.modules,
    this.environment,
    this.host,
    this.revision,
    this.captchaKey,
  });

  factory AccessData.fromJson(Map<String, dynamic> json) => AccessData(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        modules:
            json["modules"] == null ? null : Modules.fromJson(json["modules"]),
        environment: json["environment"] == null ? null : json["environment"],
        host: json["host"] == null ? null : json["host"],
        revision: json["revision"] == null ? null : json["revision"],
        captchaKey: json["captcha_key"] == null ? null : json["captcha_key"],
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
        "modules": modules == null ? null : modules.toJson(),
        "environment": environment == null ? null : environment,
        "host": host == null ? null : host,
        "revision": revision == null ? null : revision,
        "captcha_key": captchaKey == null ? null : captchaKey,
      };
}

class Modules {
  bool myTime;
  Timetable timetable;
  Employees employees;
  bool structure;
  bool news;
  bool policies;
  bool programmerEvents;
  bool fat32;
  bool gym64;
  bool maps;
  bool myProfile;
  bool mailbox;
  bool taleo;
  bool companyPolicies;
  bool zeoGuest;
  bool suggestionBox;
  bool managerPanel;
  bool eventsSubscription;
  bool changePassword;
  Grading grading;
  bool help;
  Performance performance;
  bool dashboard;
  Idp idp;
  Performance ssi;
  bool companyInfo;

  Modules({
    this.myTime,
    this.timetable,
    this.employees,
    this.structure,
    this.news,
    this.policies,
    this.programmerEvents,
    this.fat32,
    this.gym64,
    this.maps,
    this.myProfile,
    this.mailbox,
    this.taleo,
    this.companyPolicies,
    this.zeoGuest,
    this.suggestionBox,
    this.managerPanel,
    this.eventsSubscription,
    this.changePassword,
    this.grading,
    this.help,
    this.performance,
    this.dashboard,
    this.idp,
    this.ssi,
    this.companyInfo,
  });

  factory Modules.fromJson(Map<String, dynamic> json) => Modules(
        myTime: json["myTime"] == null ? null : json["myTime"],
        timetable: json["timetable"] == null
            ? null
            : Timetable.fromJson(json["timetable"]),
        employees: json["employees"] == null
            ? null
            : Employees.fromJson(json["employees"]),
        structure: json["structure"] == null ? null : json["structure"],
        news: json["news"] == null ? null : json["news"],
        policies: json["policies"] == null ? null : json["policies"],
        programmerEvents:
            json["programmerEvents"] == null ? null : json["programmerEvents"],
        fat32: json["fat32"] == null ? null : json["fat32"],
        gym64: json["gym64"] == null ? null : json["gym64"],
        maps: json["maps"] == null ? null : json["maps"],
        myProfile: json["myProfile"] == null ? null : json["myProfile"],
        mailbox: json["mailbox"] == null ? null : json["mailbox"],
        taleo: json["taleo"] == null ? null : json["taleo"],
        companyPolicies:
            json["companyPolicies"] == null ? null : json["companyPolicies"],
        zeoGuest: json["zeoGuest"] == null ? null : json["zeoGuest"],
        suggestionBox:
            json["suggestionBox"] == null ? null : json["suggestionBox"],
        managerPanel:
            json["managerPanel"] == null ? null : json["managerPanel"],
        eventsSubscription: json["eventsSubscription"] == null
            ? null
            : json["eventsSubscription"],
        changePassword:
            json["changePassword"] == null ? null : json["changePassword"],
        grading:
            json["grading"] == null ? null : Grading.fromJson(json["grading"]),
        help: json["help"] == null ? null : json["help"],
        performance: json["performance"] == null
            ? null
            : Performance.fromJson(json["performance"]),
        dashboard: json["dashboard"] == null ? null : json["dashboard"],
        idp: json["IDP"] == null ? null : Idp.fromJson(json["IDP"]),
        ssi: json["ssi"] == null ? null : Performance.fromJson(json["ssi"]),
        companyInfo: json["companyInfo"] == null ? null : json["companyInfo"],
      );

  Map<String, dynamic> toJson() => {
        "myTime": myTime == null ? null : myTime,
        "timetable": timetable == null ? null : timetable.toJson(),
        "employees": employees == null ? null : employees.toJson(),
        "structure": structure == null ? null : structure,
        "news": news == null ? null : news,
        "policies": policies == null ? null : policies,
        "programmerEvents": programmerEvents == null ? null : programmerEvents,
        "fat32": fat32 == null ? null : fat32,
        "gym64": gym64 == null ? null : gym64,
        "maps": maps == null ? null : maps,
        "myProfile": myProfile == null ? null : myProfile,
        "mailbox": mailbox == null ? null : mailbox,
        "taleo": taleo == null ? null : taleo,
        "companyPolicies": companyPolicies == null ? null : companyPolicies,
        "zeoGuest": zeoGuest == null ? null : zeoGuest,
        "suggestionBox": suggestionBox == null ? null : suggestionBox,
        "managerPanel": managerPanel == null ? null : managerPanel,
        "eventsSubscription":
            eventsSubscription == null ? null : eventsSubscription,
        "changePassword": changePassword == null ? null : changePassword,
        "grading": grading == null ? null : grading.toJson(),
        "help": help == null ? null : help,
        "performance": performance == null ? null : performance.toJson(),
        "dashboard": dashboard == null ? null : dashboard,
        "IDP": idp == null ? null : idp.toJson(),
        "ssi": ssi == null ? null : ssi.toJson(),
        "companyInfo": companyInfo == null ? null : companyInfo,
      };
}

class Employees {
  bool generalAccess;
  bool canAddProfile;
  bool canSeeInactive;
  bool canSeeTrials;

  Employees({
    this.generalAccess,
    this.canAddProfile,
    this.canSeeInactive,
    this.canSeeTrials,
  });

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        generalAccess:
            json["generalAccess"] == null ? null : json["generalAccess"],
        canAddProfile:
            json["canAddProfile"] == null ? null : json["canAddProfile"],
        canSeeInactive:
            json["canSeeInactive"] == null ? null : json["canSeeInactive"],
        canSeeTrials:
            json["canSeeTrials"] == null ? null : json["canSeeTrials"],
      );

  Map<String, dynamic> toJson() => {
        "generalAccess": generalAccess == null ? null : generalAccess,
        "canAddProfile": canAddProfile == null ? null : canAddProfile,
        "canSeeInactive": canSeeInactive == null ? null : canSeeInactive,
        "canSeeTrials": canSeeTrials == null ? null : canSeeTrials,
      };
}

class Grading {
  bool generalAccess;
  bool createApplicationAccess;
  bool showGradingInfo;

  Grading({
    this.generalAccess,
    this.createApplicationAccess,
    this.showGradingInfo,
  });

  factory Grading.fromJson(Map<String, dynamic> json) => Grading(
        generalAccess:
            json["generalAccess"] == null ? null : json["generalAccess"],
        createApplicationAccess: json["createApplicationAccess"] == null
            ? null
            : json["createApplicationAccess"],
        showGradingInfo:
            json["showGradingInfo"] == null ? null : json["showGradingInfo"],
      );

  Map<String, dynamic> toJson() => {
        "generalAccess": generalAccess == null ? null : generalAccess,
        "createApplicationAccess":
            createApplicationAccess == null ? null : createApplicationAccess,
        "showGradingInfo": showGradingInfo == null ? null : showGradingInfo,
      };
}

class Idp {
  bool managerAccess;

  Idp({
    this.managerAccess,
  });

  factory Idp.fromJson(Map<String, dynamic> json) => Idp(
        managerAccess:
            json["managerAccess"] == null ? null : json["managerAccess"],
      );

  Map<String, dynamic> toJson() => {
        "managerAccess": managerAccess == null ? null : managerAccess,
      };
}

class Performance {
  bool generalAccess;
  bool frontProcessingAccess;
  bool statsAccess;
  bool companySelectForEmployeeStatic;
  bool archiveAccess;

  Performance({
    this.generalAccess,
    this.frontProcessingAccess,
    this.statsAccess,
    this.companySelectForEmployeeStatic,
    this.archiveAccess,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        generalAccess:
            json["generalAccess"] == null ? null : json["generalAccess"],
        frontProcessingAccess: json["frontProcessingAccess"] == null
            ? null
            : json["frontProcessingAccess"],
        statsAccess: json["statsAccess"] == null ? null : json["statsAccess"],
        companySelectForEmployeeStatic:
            json["companySelectForEmployeeStatic"] == null
                ? null
                : json["companySelectForEmployeeStatic"],
        archiveAccess:
            json["archiveAccess"] == null ? null : json["archiveAccess"],
      );

  Map<String, dynamic> toJson() => {
        "generalAccess": generalAccess == null ? null : generalAccess,
        "frontProcessingAccess":
            frontProcessingAccess == null ? null : frontProcessingAccess,
        "statsAccess": statsAccess == null ? null : statsAccess,
        "companySelectForEmployeeStatic": companySelectForEmployeeStatic == null
            ? null
            : companySelectForEmployeeStatic,
        "archiveAccess": archiveAccess == null ? null : archiveAccess,
      };
}

class Timetable {
  bool generalAccess;
  bool addGroupEvent;
  bool addEventAllUsers;
  bool showAllCompanies;
  bool showFilters;
  bool showPendingFilters;

  Timetable({
    this.generalAccess,
    this.addGroupEvent,
    this.addEventAllUsers,
    this.showAllCompanies,
    this.showFilters,
    this.showPendingFilters,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) => Timetable(
        generalAccess:
            json["generalAccess"] == null ? null : json["generalAccess"],
        addGroupEvent:
            json["addGroupEvent"] == null ? null : json["addGroupEvent"],
        addEventAllUsers:
            json["addEventAllUsers"] == null ? null : json["addEventAllUsers"],
        showAllCompanies:
            json["showAllCompanies"] == null ? null : json["showAllCompanies"],
        showFilters: json["showFilters"] == null ? null : json["showFilters"],
        showPendingFilters: json["showPendingFilters"] == null
            ? null
            : json["showPendingFilters"],
      );

  Map<String, dynamic> toJson() => {
        "generalAccess": generalAccess == null ? null : generalAccess,
        "addGroupEvent": addGroupEvent == null ? null : addGroupEvent,
        "addEventAllUsers": addEventAllUsers == null ? null : addEventAllUsers,
        "showAllCompanies": showAllCompanies == null ? null : showAllCompanies,
        "showFilters": showFilters == null ? null : showFilters,
        "showPendingFilters":
            showPendingFilters == null ? null : showPendingFilters,
      };
}

class User {
  int id;
  String nickname;
  String name;
  MainPhone mainPhone;
  String email;
  List<String> roles;
  bool switchUserAbility;
  bool isImpersonating;
  bool isLead;
  Company company;
  Position position;
  MainOffice mainOffice;
  PlaceObjects placeObjects;
  Counters counters;
  Websockets websockets;
  bool isPhoneActualized;

  User({
    this.id,
    this.nickname,
    this.name,
    this.mainPhone,
    this.email,
    this.roles,
    this.switchUserAbility,
    this.isImpersonating,
    this.isLead,
    this.company,
    this.position,
    this.mainOffice,
    this.placeObjects,
    this.counters,
    this.websockets,
    this.isPhoneActualized,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        name: json["name"] == null ? null : json["name"],
        mainPhone: json["mainPhone"] == null
            ? null
            : MainPhone.fromJson(json["mainPhone"]),
        email: json["email"] == null ? null : json["email"],
        roles: json["roles"] == null
            ? null
            : List<String>.from(json["roles"].map((x) => x)),
        switchUserAbility: json["switchUserAbility"] == null
            ? null
            : json["switchUserAbility"],
        isImpersonating:
            json["isImpersonating"] == null ? null : json["isImpersonating"],
        isLead: json["isLead"] == null ? null : json["isLead"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        position: json["position"] == null
            ? null
            : Position.fromJson(json["position"]),
        mainOffice: json["mainOffice"] == null
            ? null
            : MainOffice.fromJson(json["mainOffice"]),
        placeObjects: json["placeObjects"] == null
            ? null
            : PlaceObjects.fromJson(json["placeObjects"]),
        counters: json["counters"] == null
            ? null
            : Counters.fromJson(json["counters"]),
        websockets: json["websockets"] == null
            ? null
            : Websockets.fromJson(json["websockets"]),
        isPhoneActualized: json["isPhoneActualized"] == null
            ? null
            : json["isPhoneActualized"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nickname": nickname == null ? null : nickname,
        "name": name == null ? null : name,
        "mainPhone": mainPhone == null ? null : mainPhone.toJson(),
        "email": email == null ? null : email,
        "roles": roles == null ? null : List<dynamic>.from(roles.map((x) => x)),
        "switchUserAbility":
            switchUserAbility == null ? null : switchUserAbility,
        "isImpersonating": isImpersonating == null ? null : isImpersonating,
        "isLead": isLead == null ? null : isLead,
        "company": company == null ? null : company.toJson(),
        "position": position == null ? null : position.toJson(),
        "mainOffice": mainOffice == null ? null : mainOffice.toJson(),
        "placeObjects": placeObjects == null ? null : placeObjects.toJson(),
        "counters": counters == null ? null : counters.toJson(),
        "websockets": websockets == null ? null : websockets.toJson(),
        "isPhoneActualized":
            isPhoneActualized == null ? null : isPhoneActualized,
      };
}

class Company {
  int id;
  String slug;
  String name;
  String color;

  Company({
    this.id,
    this.slug,
    this.name,
    this.color,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        slug: json["slug"] == null ? null : json["slug"],
        name: json["name"] == null ? null : json["name"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "slug": slug == null ? null : slug,
        "name": name == null ? null : name,
        "color": color == null ? null : color,
      };
}

class Counters {
  int news;
  int help;
  String fat32;

  Counters({
    this.news,
    this.help,
    this.fat32,
  });

  factory Counters.fromJson(Map<String, dynamic> json) => Counters(
        news: json["news"] == null ? null : json["news"],
        help: json["help"] == null ? null : json["help"],
        fat32: json["fat32"] == null ? null : json["fat32"],
      );

  Map<String, dynamic> toJson() => {
        "news": news == null ? null : news,
        "help": help == null ? null : help,
        "fat32": fat32 == null ? null : fat32,
      };
}

class MainOffice {
  int id;
  String title;
  String shortTitle;

  MainOffice({
    this.id,
    this.title,
    this.shortTitle,
  });

  factory MainOffice.fromJson(Map<String, dynamic> json) => MainOffice(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        shortTitle: json["shortTitle"] == null ? null : json["shortTitle"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "shortTitle": shortTitle == null ? null : shortTitle,
      };
}

class MainPhone {
  int id;
  String type;
  String contact;

  MainPhone({
    this.id,
    this.type,
    this.contact,
  });

  factory MainPhone.fromJson(Map<String, dynamic> json) => MainPhone(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        contact: json["contact"] == null ? null : json["contact"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "contact": contact == null ? null : contact,
      };
}

class PlaceObjects {
  Floor floor;

  PlaceObjects({
    this.floor,
  });

  factory PlaceObjects.fromJson(Map<String, dynamic> json) => PlaceObjects(
        floor: json["floor"] == null ? null : Floor.fromJson(json["floor"]),
      );

  Map<String, dynamic> toJson() => {
        "floor": floor == null ? null : floor.toJson(),
      };
}

class Floor {
  int id;
  String title;

  Floor({
    this.id,
    this.title,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
      };
}

class Position {
  int id;
  String name;
  String type;
  Company company;

  Position({
    this.id,
    this.name,
    this.type,
    this.company,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "company": company == null ? null : company.toJson(),
      };
}

class Websockets {
  Key key;
  String url;

  Websockets({
    this.key,
    this.url,
  });

  factory Websockets.fromJson(Map<String, dynamic> json) => Websockets(
        key: json["key"] == null ? null : Key.fromJson(json["key"]),
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key.toJson(),
        "url": url == null ? null : url,
      };
}

class Key {
  String key;
  String value;

  Key({
    this.key,
    this.value,
  });

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        key: json["key"] == null ? null : json["key"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "value": value == null ? null : value,
      };
}
