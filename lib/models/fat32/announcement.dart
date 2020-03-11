// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';

Announcement announcementFromJson(String str) =>
    Announcement.fromJson(json.decode(str));

String announcementToJson(Announcement data) => json.encode(data.toJson());

class Announcement {
  Map<String, List<Current>> current;
  Map<String, List<Current>> next;

  Announcement({
    this.current,
    this.next,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        current: json["current"] == null
            ? null
            : Map.from(json["current"]).map((k, v) =>
                MapEntry<String, List<Current>>(
                    k, List<Current>.from(v.map((x) => Current.fromJson(x))))),
        next: json["next"] == null
            ? null
            : Map.from(json["next"]).map((k, v) =>
                MapEntry<String, List<Current>>(
                    k, List<Current>.from(v.map((x) => Current.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "current": current == null
            ? null
            : Map.from(current).map((k, v) => MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "next": next == null
            ? null
            : Map.from(next).map((k, v) => MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };

  List<CurrentWithDate> getAsSortedList() {
    List<MapEntry<String, List<Current>>> defaultEntries = [];
    List<CurrentWithDate> result = ((current != null
            ? current.entries.toList()
            : defaultEntries)
          ..addAll(next != null ? next.entries : defaultEntries))
        .map((entry) =>
            CurrentWithDate(data: entry.value, date: DateTime.parse(entry.key)))
        .toList();
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }
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
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        markers:
            json["markers"] == null ? null : Markers.fromJson(json["markers"]),
        composition: json["composition"] == null
            ? null
            : Composition.fromJson(json["composition"]),
        shouldUseOldFunctionality: json["shouldUseOldFunctionality"] == null
            ? null
            : json["shouldUseOldFunctionality"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "markers": markers == null ? null : markers.toJson(),
        "composition": composition == null ? null : composition.toJson(),
        "shouldUseOldFunctionality": shouldUseOldFunctionality == null
            ? null
            : shouldUseOldFunctionality,
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
        prots: json["prots"] == null ? null : json["prots"],
        fats: json["fats"] == null ? null : json["fats"],
        carbs: json["carbs"] == null ? null : json["carbs"],
        calories: json["calories"] == null ? null : json["calories"],
      );

  Map<String, dynamic> toJson() => {
        "prots": prots == null ? null : prots,
        "fats": fats == null ? null : fats,
        "carbs": carbs == null ? null : carbs,
        "calories": calories == null ? null : calories,
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
        markersNew: json["new"] == null ? null : json["new"],
        vegan: json["vegan"] == null ? null : json["vegan"],
        lent: json["lent"] == null ? null : json["lent"],
      );

  Map<String, dynamic> toJson() => {
        "new": markersNew == null ? null : markersNew,
        "vegan": vegan == null ? null : vegan,
        "lent": lent == null ? null : lent,
      };
}

class CurrentWithDate {
  DateTime date;
  List<Current> data;
  CurrentWithDate({List<Current> data, DateTime date})
      : this.data = data,
        this.date = date;
}
