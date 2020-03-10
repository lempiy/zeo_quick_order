class LimitsData {
  String billingStartDate;
  String billingEndDate;
  List<ExceededLimits> exceededLimits;
  int total;

  LimitsData(
      {this.billingStartDate,
        this.billingEndDate,
        this.exceededLimits,
        this.total});

  LimitsData.fromJson(Map<String, dynamic> json) {
    billingStartDate = json['billingStartDate'];
    billingEndDate = json['billingEndDate'];
    if (json['exceededLimits'] != null) {
      exceededLimits = new List<ExceededLimits>();
      json['exceededLimits'].forEach((v) {
        exceededLimits.add(new ExceededLimits.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billingStartDate'] = this.billingStartDate;
    data['billingEndDate'] = this.billingEndDate;
    if (this.exceededLimits != null) {
      data['exceededLimits'] =
          this.exceededLimits.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ExceededLimits {
  String date;
  int overLimit;

  ExceededLimits({this.date, this.overLimit});

  ExceededLimits.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    overLimit = json['overLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['overLimit'] = this.overLimit;
    return data;
  }
}
