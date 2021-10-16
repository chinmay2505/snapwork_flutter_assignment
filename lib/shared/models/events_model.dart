class Events {
  late List<Years> years;

  Events({required this.years});

  Events.fromJson(Map<String, dynamic> json) {
    if (json['years'] != null) {
      years = <Years>[];
      json['years'].forEach((v) {
        years.add(Years.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['years'] = this.years.map((v) => v.toJson()).toList();
    return data;
  }
}

class Years {
  late int year;
  late List<Months> months;

  Years({required this.year, required this.months});

  Years.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    if (json['months'] != null) {
      months = <Months>[];
      json['months'].forEach((v) {
        months.add(Months.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['year'] = this.year;
    data['months'] = this.months.map((v) => v.toJson()).toList();
    return data;
  }
}

class Months {
  late int month;
  late List<Days> days;

  Months({required this.month, required this.days});

  Months.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days.add(Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['month'] = this.month;
    data['days'] = this.days.map((v) => v.toJson()).toList();
    return data;
  }
}

class Days {
  late int day;
  late String title;
  String? time;
  String? description;

  Days({required this.day, required this.title, this.time, this.description});

  Days.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
