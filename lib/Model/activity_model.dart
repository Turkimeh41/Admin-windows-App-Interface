// ignore_for_file: non_constant_identifier_names

class Activity {
  String id;
  String name;
  double price;
  String type;
  int duration;
  final DateTime created_date;
  String imgURL;
  final int multiplier;
  int played;
  int seats;
  bool enabled;

  Activity(
      {required this.id,
      required this.name,
      required this.price,
      required this.type,
      required this.duration,
      required this.created_date,
      required this.imgURL,
      required this.multiplier,
      required this.played,
      required this.seats,
      required this.enabled});
}
