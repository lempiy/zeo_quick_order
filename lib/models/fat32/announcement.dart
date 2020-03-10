// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Announcement announcementFromJson(String str) => Announcement.fromJson(json.decode(str));

String announcementToJson(Announcement data) => json.encode(data.toJson());

class Announcement {
  Map<String, List<Current>> current;
  Map<String, List<Current>> next;

  Announcement({
    this.current,
    this.next,
  });

  List<CurrentWithDate> getAsSortedList() {
    List<MapEntry<String, List<Current>>> defaultEntries = [];
    List<CurrentWithDate> result = ((current != null ? current.entries.toList() : defaultEntries)..addAll(next != null ? next.entries : defaultEntries))
        .map((entry) => CurrentWithDate(data: entry.value, date: DateTime.parse(entry.key))).toList();
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    current: Map.from(json["current"]).map((k, v) => MapEntry<String, List<Current>>(k, List<Current>.from(v.map((x) => Current.fromJson(x))))),
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "current": Map.from(current).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    "next": next,
  };
}

class CurrentWithDate {
  DateTime date;
  List<Current> data;
  CurrentWithDate({List<Current> data, DateTime date}) : this.data = data, this.date = date;
}

class Current {
  String name;
  int price;
  String description;
  String image;
  Markers markers;
  Composition composition;
  bool shouldUseOldFunctionality;

  Current({
    this.name,
    this.price,
    this.description,
    this.image,
    this.markers,
    this.composition,
    this.shouldUseOldFunctionality,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    name: json["name"],
    price: json["price"],
    description: json["description"],
    image: json["image"] == null ? null : json["image"],
    markers: Markers.fromJson(json["markers"]),
    composition: Composition.fromJson(json["composition"]),
    shouldUseOldFunctionality: json["shouldUseOldFunctionality"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "description": description,
    "image": image == null ? null : image,
    "markers": markers.toJson(),
    "composition": composition.toJson(),
    "shouldUseOldFunctionality": shouldUseOldFunctionality,
  };
}

class Composition {
  int prots;
  int fats;
  int carbs;
  int calories;

  Composition({
    this.prots,
    this.fats,
    this.carbs,
    this.calories,
  });

  factory Composition.fromJson(Map<String, dynamic> json) => Composition(
    prots: json["prots"],
    fats: json["fats"],
    carbs: json["carbs"],
    calories: json["calories"],
  );

  Map<String, dynamic> toJson() => {
    "prots": prots,
    "fats": fats,
    "carbs": carbs,
    "calories": calories,
  };
}

class Markers {
  bool markersNew;
  bool vegan;
  bool lent;

  Markers({
    this.markersNew,
    this.vegan,
    this.lent,
  });

  factory Markers.fromJson(Map<String, dynamic> json) => Markers(
    markersNew: json["new"],
    vegan: json["vegan"],
    lent: json["lent"],
  );

  Map<String, dynamic> toJson() => {
    "new": markersNew,
    "vegan": vegan,
    "lent": lent,
  };
}
