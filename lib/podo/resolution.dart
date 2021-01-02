class Resolution {
  String title;
  ResolutionType type;

  DateTime endDate;

  Resolution(this.title, this.type, this.endDate)
      : assert(title != null),
        assert(type != null),
        assert(!(type == ResolutionType.ATTAINABLE && endDate == null));

  Map toMap() {
    return {
      "title": title,
      "type": type.toString(),
      "endDate": endDate.toIso8601String(),
    };
  }

  Resolution.fromMap(Map map) {
    title = map["title"];
    type = map["type"] == "ResolutionType.CONTINUOUS"
        ? ResolutionType.CONTINUOUS
        : ResolutionType.ATTAINABLE;
    endDate = map["endDate"];
  }
}

enum ResolutionType { CONTINUOUS, ATTAINABLE }
