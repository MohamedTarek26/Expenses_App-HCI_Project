import 'package:expenses_hci/Statistics.dart';
import 'package:expenses_hci/currency_convertor.dart';
import 'package:expenses_hci/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_transaction.dart';
import 'transaction.dart' as trans;
import 'under_construction.dart';
import 'scanning_page.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_hci/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<trans.Transaction> transactions = [];
  int incomes_value = 0;
  int expenses_value = 0;
  int budget = 0;
  String username = 'Asser';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    // Load transactions from local storage when the widget is created
    await loadTransactions();

    // Update the username and set it to the 'username' property
    String updatedUsername = await updateUsername();

    // Update the state with the fetched username
    setState(() {
      username = updatedUsername;
    });
  }
  Future<String?> getUserNamesFromLS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String> updateUsername() async {
   return await getUserNamesFromLS() ?? '';
  }
  

  // Load transactions from local storage
  Future<void> loadTransactions() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsJson = prefs.getString('transactions') ?? '[]';
    print('transactionsJson: $transactionsJson');
    try {
      List<Map<String, dynamic>> transactionsMapList =
          List<Map<String, dynamic>>.from(
              json.decode(transactionsJson) as List<dynamic>);

      setState(() {
        transactions = transactionsMapList
            .map((transactionMap) => trans.Transaction.fromJson(transactionMap))
            .toList();
        print('transactions: $transactions');
        // Calculate incomes, expenses, and budget
        calculateSummary();
      });
    } catch (e) {
      print('Error decoding transactions: $e');
      // Handle the error as needed, e.g., show an error message to the user.
    }
  }

Future<void> saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsJson =
    json.encode(transactions.map((t) => t.toJson()).toList());
    print('transactionsJson: $transactionsJson');
    prefs.setString('transactions', transactionsJson);
    List< Map<String, dynamic>> dummy=[];
    print(transactions.length);
    for(int i=0;i<transactions.length;i++){
      dummy.add(transactions[i].toJson());
    }
    print(dummy);
    String userEmail = prefs.getString('userEmail') ?? '';
    String password = '';

    try {
      // Retrieve the document snapshot
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Retrieve the 'password' field from the document
        password = docSnapshot.get('password') ?? '';
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error retrieving password: $e');
    }
    await _firestore.collection('users').doc(userEmail).update({
      'username': prefs.getString('username'),
      'fullName': prefs.getString('fullName'),
      'userEmail': prefs.getString('userEmail'),
      'password': password??'',
      'transactions': dummy,
    });
    print('Saving ....... transactionsJson: $transactionsJson');
  }

  // Add this method to handle adding transactions
  void addTransaction(trans.Transaction transaction) {
    setState(() {
      transactions.add(transaction);
      // Calculate incomes, expenses, and budget
      calculateSummary();

      // Save transactions to local storage
      saveTransactions();
      print("added transaction: $transaction");
    });
  }

//   Widget _getImageWidget() {
//   // Check if the image is null (you can replace this condition with your own)
//   if (/*profilePage.get_image()*/null == null) {
//     // If the image is null, return the Icon
//     return Icon(
//       Icons.person,
//       size: 70,
//     );
//   } else {
//     // If the image is available, return the Image
//     return Image.asset(
//       'assets/your_image.png', // Replace with the path to your image asset
//       width: 40, // Set the width of the image as needed
//       height: 40, // Set the height of the image as needed
//     );
//   }
// }

  // Calculate incomes, expenses, and budget
  void calculateSummary() {
    incomes_value = transactions
        .where((transaction) => transaction.type == 'income')
        .fold(0, (sum, transaction) => sum + transaction.amount.toInt());

    expenses_value = transactions
        .where((transaction) => transaction.type == 'expense')
        .fold(0, (sum, transaction) => sum + transaction.amount.toInt());

    budget = incomes_value - expenses_value;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => /*CurrencyConvertor()*/CurrencyConvertor()),
              );
            },
            icon: const Icon(Icons.currency_exchange_sharp,
                color: Colors.black, size: 33),
          ),
        ],
        title: Text('Spendio'
          ,style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          )),
        backgroundColor: Color.fromARGB(255, 56, 208, 213),
        elevation: 0.0,
      ),
      body: Column(
        
        children: [
          
Padding(
  padding: const EdgeInsets.all(16.0),
  child: FutureBuilder<String>(
    future: updateUsername(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        String updatedUsername = snapshot.data ?? '';
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 150,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 56, 208, 213),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person,
                     size: 70,
                     )
                ),
              ),
              Text(
                updatedUsername,
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 56, 208, 213),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Center(
            // Show a loading indicator while the future is not complete
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  ),
),

          SizedBox(height: 16),
          Container(
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
              // color: Color.fromARGB(255, 2, 85, 238),
              // gradient: const LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [Colors.deepPurple, Colors.blue], // Define your gradient colors
              //   ),
              color: Color.fromARGB(255, 5, 153, 158),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              // width: MediaQuery.of(context).size.width*0.8, // Set your desired width here
              // decoration: BoxDecoration(
              //   // color: const Color.fromARGB(255, 2, 85, 238),
              //   gradient: const LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [Colors.deepPurple, Colors.blue], // Define your gradient colors
              //   ),
                // borderRadius: BorderRadius.circular(10.0),
              // ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '\$${budget.toString()}',
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Expense',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      '\$${expenses_value.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Income',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      '\$${incomes_value.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                // borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final expense = transactions[index];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${expense.category}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          expense.type == 'income'
                              ? '+\$${expense.amount}'
                              : '-\$${expense.amount}',
                          style: TextStyle(
                            color: expense.type == 'income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
        
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 56, 208, 213),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 40,
                  color: Color.lerp(
                    Color.fromARGB(255, 97, 97, 97),
                    Color.fromARGB(255, 0, 0, 0),
                    0.5,
                  ),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(
                        transactions: transactions,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.receipt_long_outlined, size: 40),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanningPage(
                        onAddTransaction: (transaction) {
                          addTransaction(transaction);
                        },
                      ),
                    ),
                  );
                  print("result $result");
                },
              ),
              IconButton(
                icon: Icon(Icons.person, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        // ),
      ),
      // ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionPage(
                onAddTransaction: (transaction) {
                  addTransaction(transaction);
                },
              ),
            ),
          );
          print(result);
        },
        child: Icon(Icons.add),
        
        backgroundColor: Color.fromARGB(255, 56, 208, 213), // Change the background color
        elevation: 15.0, // Adjust the elevation (shadow)
        tooltip: 'Add Transaction', // Add a tooltip
        shape: RoundedRectangleBorder( // Customize the shape
          borderRadius: BorderRadius.circular(50.0),
  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

