// ignore_for_file: non_constant_identifier_names

class Manager {
  Manager(
      {required this.id,
      required this.username,
      required this.enabled,
      required this.first_name,
      required this.last_name,
      required this.email_address,
      required this.phone,
      required this.img_link,
      required this.added});
  final String id;
  final String username;
  final String first_name;
  final String last_name;
  final String email_address;
  final String phone;
  final String img_link;
  bool enabled;
  final DateTime added;
}
