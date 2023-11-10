// Create a new Dart file named 'expense.dart'
class Transaction {
  DateTime date;
  double amount;
  String category;
  String type;

  Transaction(
      {required this.date,
      required this.amount,
      required this.category,
      required this.type});
}
