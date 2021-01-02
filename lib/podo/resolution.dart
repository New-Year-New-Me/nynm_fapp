class Resolution {
  String title;
  String description;
  ResolutionType type;

  DateTime expectedEndDate;

  Resolution(this.title, this.description, this.type, this.expectedEndDate)
      : assert(title != null),
        assert(type != null),
        assert(!(type == ResolutionType.ATTAINABLE && expectedEndDate == null));
}

enum ResolutionType { CONTINUOUS, ATTAINABLE }
