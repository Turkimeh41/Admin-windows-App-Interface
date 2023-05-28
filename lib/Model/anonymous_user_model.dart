class AnonymousUser {
  final String id;
  final String? providerAccountID;
  final double? balance;
  final String? label;
  final String qrURL;
  final DateTime? assignedDate;

  AnonymousUser({required this.id, required this.assignedDate, required this.qrURL, required this.providerAccountID, required this.balance, required this.label});
}
