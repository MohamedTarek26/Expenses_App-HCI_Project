class User {
  String username;
  String email;
  List<double> expenses;
  List<double> income;
  double totalBalance;

  User({
    required this.username,
    required this.email,
    required this.expenses,
    required this.income,
    required this.totalBalance,
  });

  // factory User.fromFirebaseUser(FirebaseUser firebaseUser) {
  //   // Logic to transform Firebase User to User class
  //   return User(
  //     username: firebaseUser.displayName ?? '',
  //     email: firebaseUser.email ?? '',
  //     expenses: [],
  //     income: [],
  //     totalBalance: 0.0,
  //   );
  // }

  // Map<String, dynamic> toFirebaseUser() {
  //   // Logic to transform User class to Firebase User
  //   return {
  //     'username': username,
  //     'email': email,
  //     'expenses': expenses,
  //     'income': income,
  //     'totalBalance': totalBalance,
  //   };
  // }

}