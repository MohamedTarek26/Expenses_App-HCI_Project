class Transaction {
  DateTime date;
  double amount;
  String category;
  String type;
  
  Transaction({
    required this.date,
    required this.amount,
    required this.category,
    required this.type,
  });
  

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      category: json['category'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category,
      'type': type,
    };
  }
}
