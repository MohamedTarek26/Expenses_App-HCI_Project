import 'package:expenses_hci/transaction.dart';

class User {
  String username;
  String email;
  List<Transaction> transactions;
  double totalBalance;

  User({
    required this.username,
    required this.email,
    required this.transactions,
    required this.totalBalance,
  });

}