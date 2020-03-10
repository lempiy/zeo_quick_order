class AccessData {
  User user;
  Modules modules;
  String environment;
  String host;
  int revision;
  String captchaKey;

  AccessData(
      {this.user,
        this.modules,
        this.environment,
        this.host,
        this.revision,
        this.captchaKey});

  AccessData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    modules =
    json['modules'] != null ? new Modules.fromJson(json['modules']) : null;
    environment = json['environment'];
    host = json['host'];
    revision = json['revision'];
    captchaKey = json['captcha_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.modules != null) {
      data['modules'] = this.modules.toJson();
    }
    data['environment'] = this.environment;
    data['host'] = this.host;
    data['revision'] = this.revision;
    data['captcha_key'] = this.captchaKey;
    return data;
  }
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

  User(
      {this.id,
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
        this.isPhoneActualized});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    name = json['name'];
    mainPhone = json['mainPhone'] != null
        ? new MainPhone.fromJson(json['mainPhone'])
        : null;
    email = json['email'];
    roles = json['roles'].cast<String>();
    switchUserAbility = json['switchUserAbility'];
    isImpersonating = json['isImpersonating'];
    isLead = json['isLead'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
    position = json['position'] != null
        ? new Position.fromJson(json['position'])
        : null;
    mainOffice = json['mainOffice'] != null
        ? new MainOffice.fromJson(json['mainOffice'])
        : null;
    placeObjects = json['placeObjects'] != null
        ? new PlaceObjects.fromJson(json['placeObjects'])
        : null;
    counters = json['counters'] != null
        ? new Counters.fromJson(json['counters'])
        : null;
    websockets = json['websockets'] != null
        ? new Websockets.fromJson(json['websockets'])
        : null;
    isPhoneActualized = json['isPhoneActualized'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['name'] = this.name;
    if (this.mainPhone != null) {
      data['mainPhone'] = this.mainPhone.toJson();
    }
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['switchUserAbility'] = this.switchUserAbility;
    data['isImpersonating'] = this.isImpersonating;
    data['isLead'] = this.isLead;
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    if (this.position != null) {
      data['position'] = this.position.toJson();
    }
    if (this.mainOffice != null) {
      data['mainOffice'] = this.mainOffice.toJson();
    }
    if (this.placeObjects != null) {
      data['placeObjects'] = this.placeObjects.toJson();
    }
    if (this.counters != null) {
      data['counters'] = this.counters.toJson();
    }
    if (this.websockets != null) {
      data['websockets'] = this.websockets.toJson();
    }
    data['isPhoneActualized'] = this.isPhoneActualized;
    return data;
  }
}

class MainPhone {
  int id;
  String type;
  String contact;

  MainPhone({this.id, this.type, this.contact});

  MainPhone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['contact'] = this.contact;
    return data;
  }
}

class Position {
  int id;
  String name;
  String type;
  Company company;

  Position({this.id, this.name, this.type, this.company});

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    return data;
  }
}

class Company {
  int id;
  String slug;
  String name;
  String color;

  Company({this.id, this.slug, this.name, this.color});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }
}

class MainOffice {
  int id;
  String title;
  String shortTitle;

  MainOffice({this.id, this.title, this.shortTitle});

  MainOffice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortTitle = json['shortTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['shortTitle'] = this.shortTitle;
    return data;
  }
}

class PlaceObjects {
  Floor floor;

  PlaceObjects({this.floor});

  PlaceObjects.fromJson(Map<String, dynamic> json) {
    floor = json['floor'] != null ? new Floor.fromJson(json['floor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.floor != null) {
      data['floor'] = this.floor.toJson();
    }
    return data;
  }
}

class Floor {
  int id;
  String title;

  Floor({this.id, this.title});

  Floor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class Counters {
  int news;
  int help;
  Null fat32;

  Counters({this.news, this.help, this.fat32});

  Counters.fromJson(Map<String, dynamic> json) {
    news = json['news'];
    help = json['help'];
    fat32 = json['fat32'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news'] = this.news;
    data['help'] = this.help;
    data['fat32'] = this.fat32;
    return data;
  }
}

class Websockets {
  Key key;
  String url;

  Websockets({this.key, this.url});

  Websockets.fromJson(Map<String, dynamic> json) {
    key = json['key'] != null ? new Key.fromJson(json['key']) : null;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.key != null) {
      data['key'] = this.key.toJson();
    }
    data['url'] = this.url;
    return data;
  }
}

class Key {
  String key;
  String value;

  Key({this.key, this.value});

  Key.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
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
  IDP iDP;
  Ssi ssi;
  bool companyInfo;

  Modules(
      {this.myTime,
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
        this.iDP,
        this.ssi,
        this.companyInfo});

  Modules.fromJson(Map<String, dynamic> json) {
    myTime = json['myTime'];
    timetable = json['timetable'] != null
        ? new Timetable.fromJson(json['timetable'])
        : null;
    employees = json['employees'] != null
        ? new Employees.fromJson(json['employees'])
        : null;
    structure = json['structure'];
    news = json['news'];
    policies = json['policies'];
    programmerEvents = json['programmerEvents'];
    fat32 = json['fat32'];
    gym64 = json['gym64'];
    maps = json['maps'];
    myProfile = json['myProfile'];
    mailbox = json['mailbox'];
    taleo = json['taleo'];
    companyPolicies = json['companyPolicies'];
    zeoGuest = json['zeoGuest'];
    suggestionBox = json['suggestionBox'];
    managerPanel = json['managerPanel'];
    eventsSubscription = json['eventsSubscription'];
    changePassword = json['changePassword'];
    grading =
    json['grading'] != null ? new Grading.fromJson(json['grading']) : null;
    help = json['help'];
    performance = json['performance'] != null
        ? new Performance.fromJson(json['performance'])
        : null;
    dashboard = json['dashboard'];
    iDP = json['IDP'] != null ? new IDP.fromJson(json['IDP']) : null;
    ssi = json['ssi'] != null ? new Ssi.fromJson(json['ssi']) : null;
    companyInfo = json['companyInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myTime'] = this.myTime;
    if (this.timetable != null) {
      data['timetable'] = this.timetable.toJson();
    }
    if (this.employees != null) {
      data['employees'] = this.employees.toJson();
    }
    data['structure'] = this.structure;
    data['news'] = this.news;
    data['policies'] = this.policies;
    data['programmerEvents'] = this.programmerEvents;
    data['fat32'] = this.fat32;
    data['gym64'] = this.gym64;
    data['maps'] = this.maps;
    data['myProfile'] = this.myProfile;
    data['mailbox'] = this.mailbox;
    data['taleo'] = this.taleo;
    data['companyPolicies'] = this.companyPolicies;
    data['zeoGuest'] = this.zeoGuest;
    data['suggestionBox'] = this.suggestionBox;
    data['managerPanel'] = this.managerPanel;
    data['eventsSubscription'] = this.eventsSubscription;
    data['changePassword'] = this.changePassword;
    if (this.grading != null) {
      data['grading'] = this.grading.toJson();
    }
    data['help'] = this.help;
    if (this.performance != null) {
      data['performance'] = this.performance.toJson();
    }
    data['dashboard'] = this.dashboard;
    if (this.iDP != null) {
      data['IDP'] = this.iDP.toJson();
    }
    if (this.ssi != null) {
      data['ssi'] = this.ssi.toJson();
    }
    data['companyInfo'] = this.companyInfo;
    return data;
  }
}

class Timetable {
  bool generalAccess;
  bool addGroupEvent;
  bool addEventAllUsers;
  bool showAllCompanies;
  bool showFilters;
  bool showPendingFilters;

  Timetable(
      {this.generalAccess,
        this.addGroupEvent,
        this.addEventAllUsers,
        this.showAllCompanies,
        this.showFilters,
        this.showPendingFilters});

  Timetable.fromJson(Map<String, dynamic> json) {
    generalAccess = json['generalAccess'];
    addGroupEvent = json['addGroupEvent'];
    addEventAllUsers = json['addEventAllUsers'];
    showAllCompanies = json['showAllCompanies'];
    showFilters = json['showFilters'];
    showPendingFilters = json['showPendingFilters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generalAccess'] = this.generalAccess;
    data['addGroupEvent'] = this.addGroupEvent;
    data['addEventAllUsers'] = this.addEventAllUsers;
    data['showAllCompanies'] = this.showAllCompanies;
    data['showFilters'] = this.showFilters;
    data['showPendingFilters'] = this.showPendingFilters;
    return data;
  }
}

class Employees {
  bool generalAccess;
  bool canAddProfile;
  bool canSeeInactive;
  bool canSeeTrials;

  Employees(
      {this.generalAccess,
        this.canAddProfile,
        this.canSeeInactive,
        this.canSeeTrials});

  Employees.fromJson(Map<String, dynamic> json) {
    generalAccess = json['generalAccess'];
    canAddProfile = json['canAddProfile'];
    canSeeInactive = json['canSeeInactive'];
    canSeeTrials = json['canSeeTrials'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generalAccess'] = this.generalAccess;
    data['canAddProfile'] = this.canAddProfile;
    data['canSeeInactive'] = this.canSeeInactive;
    data['canSeeTrials'] = this.canSeeTrials;
    return data;
  }
}

class Grading {
  bool generalAccess;
  bool createApplicationAccess;
  bool showGradingInfo;

  Grading(
      {this.generalAccess, this.createApplicationAccess, this.showGradingInfo});

  Grading.fromJson(Map<String, dynamic> json) {
    generalAccess = json['generalAccess'];
    createApplicationAccess = json['createApplicationAccess'];
    showGradingInfo = json['showGradingInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generalAccess'] = this.generalAccess;
    data['createApplicationAccess'] = this.createApplicationAccess;
    data['showGradingInfo'] = this.showGradingInfo;
    return data;
  }
}

class Performance {
  bool generalAccess;
  bool frontProcessingAccess;
  bool statsAccess;
  bool companySelectForEmployeeStatic;

  Performance(
      {this.generalAccess,
        this.frontProcessingAccess,
        this.statsAccess,
        this.companySelectForEmployeeStatic});

  Performance.fromJson(Map<String, dynamic> json) {
    generalAccess = json['generalAccess'];
    frontProcessingAccess = json['frontProcessingAccess'];
    statsAccess = json['statsAccess'];
    companySelectForEmployeeStatic = json['companySelectForEmployeeStatic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generalAccess'] = this.generalAccess;
    data['frontProcessingAccess'] = this.frontProcessingAccess;
    data['statsAccess'] = this.statsAccess;
    data['companySelectForEmployeeStatic'] =
        this.companySelectForEmployeeStatic;
    return data;
  }
}

class IDP {
  bool managerAccess;

  IDP({this.managerAccess});

  IDP.fromJson(Map<String, dynamic> json) {
    managerAccess = json['managerAccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['managerAccess'] = this.managerAccess;
    return data;
  }
}

class Ssi {
  bool generalAccess;
  bool frontProcessingAccess;
  bool statsAccess;
  bool archiveAccess;
  bool companySelectForEmployeeStatic;

  Ssi(
      {this.generalAccess,
        this.frontProcessingAccess,
        this.statsAccess,
        this.archiveAccess,
        this.companySelectForEmployeeStatic});

  Ssi.fromJson(Map<String, dynamic> json) {
    generalAccess = json['generalAccess'];
    frontProcessingAccess = json['frontProcessingAccess'];
    statsAccess = json['statsAccess'];
    archiveAccess = json['archiveAccess'];
    companySelectForEmployeeStatic = json['companySelectForEmployeeStatic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generalAccess'] = this.generalAccess;
    data['frontProcessingAccess'] = this.frontProcessingAccess;
    data['statsAccess'] = this.statsAccess;
    data['archiveAccess'] = this.archiveAccess;
    data['companySelectForEmployeeStatic'] =
        this.companySelectForEmployeeStatic;
    return data;
  }
}
