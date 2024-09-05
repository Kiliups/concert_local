class Concert {
  int? id;
  String name;
  DateTime date;
  String location;
  String? ticketRef;
  String? imageRef;

  Concert(this.name, this.date, this.location, this.ticketRef, this.imageRef);

  Concert.id(this.id, this.name, this.date, this.location, this.ticketRef,
      this.imageRef);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'location': location,
      'ticketRef': ticketRef,
      'imageRef': imageRef
    };
  }
}
