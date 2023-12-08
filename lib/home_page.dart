import 'package:expenses_hci/currency_convertor.dart';
import 'package:expenses_hci/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_transaction.dart';
import 'transaction.dart';
import 'under_construction.dart';
import 'scanning_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> transactions = [];
  int incomes_value = 0;
  int expenses_value = 0;
  int budget = 0;
  String username = 'Hello, Asser!';

  @override
  void initState() {
    super.initState();
    // Load transactions from local storage when the widget is created
    loadTransactions();
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
            .map((transactionMap) => Transaction.fromJson(transactionMap))
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

  // Save transactions to local storage
  Future<void> saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsJson =
        json.encode(transactions.map((t) => t.toJson()).toList());
    prefs.setString('transactions', transactionsJson);
    print('Saving ....... transactionsJson: $transactionsJson');
  }

  // Add this method to handle adding transactions
  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
      // Calculate incomes, expenses, and budget
      calculateSummary();

      // Save transactions to local storage
      saveTransactions();
      print("added transaction: $transaction");
    });
  }

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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConvertor()),
              );
            },
            icon: const Icon(Icons.currency_exchange_sharp,
                color: Colors.black, size: 33),
          ),
        ],
        backgroundColor: Colors.grey[300],
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 60,
            right: 50,
            child: Container(
              width: 310,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person,
                        size: 70,
                      ),
                    ),
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Container(
                width: 240,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 15),
                    Text(
                      budget.toString() + ' \$',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 170.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Today\'s Expense',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        Text(
                          expenses_value.toString() + ' \$',
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 170,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Today\'s Income',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        Text(
                          incomes_value.toString() + ' \$',
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 460,
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
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
                          expense.type == 'income'
                              ? '+' + '\$ ${expense.amount}'
                              : '-' + '\$ ${expense.amount}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: expense.type == 'income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        )
                      ],
                    ),
                    subtitle: Text(
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
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home,
                    size: 40,
                    color: Color.lerp(
                        const Color(0xFF31CEC5), const Color(0xFF314BCE), 0.5)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnderConstruction(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.receipt_long_outlined, size: 40),
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
                icon: const Icon(Icons.person, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 40,
            child: FloatingActionButton(
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
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
