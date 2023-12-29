import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transaction.dart'; // Import your Transaction class or relevant model

class StatisticsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const StatisticsPage({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;

    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];

    final List<int> daysInMonth = [
      31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ];

    List<double> incomeList =
    List.filled(daysInMonth[currentMonth - 1], 0); // Initialize list for the current month
    List<double> expenseList =
    List.filled(daysInMonth[currentMonth - 1], 0); // Initialize list for the current month

    List<Transaction> incomeGroupedList =
    _groupTransactionsByTypeAndDate('income', currentMonth);
    List<Transaction> expenseGroupedList =
    _groupTransactionsByTypeAndDate('expense', currentMonth);

    // Update the index and expense lists based on grouped incomes and expenses
    _updateListsFromGroupedTransactions(incomeList, incomeGroupedList);
    _updateListsFromGroupedTransactions(expenseList, expenseGroupedList);

    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];

    incomeList.asMap().forEach((index, transaction) {
      incomeSpots.add(FlSpot(index.toDouble() + 1, transaction)); // Index from 1
    });

    expenseList.asMap().forEach((index, transaction) {
      expenseSpots.add(FlSpot(index.toDouble() + 1, transaction)); // Index from 1
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics - ${months[currentMonth - 1]}'), // Display month name
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: false,
                      colors: [Colors.blue],
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.blue.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: false,
                      colors: [Colors.red],
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.red.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  borderData: FlBorderData(
                    border:
                    const Border(bottom: BorderSide(), left: BorderSide()),
                  ),
                  minY: 0,
                  maxY: _calculateMaxY(incomeSpots, expenseSpots) +
                      _calculateMaxY(incomeSpots, expenseSpots) * 0.5,
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        final int intValue = value.toInt();
                        if (intValue > 0 && intValue <= daysInMonth[currentMonth - 1]) {
                          return intValue.toString();
                        }
                        return '';
                      },
                    ),
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY(List<FlSpot> incomeSpots, List<FlSpot> expenseSpots) {
    double maxIncome = incomeSpots.isNotEmpty
        ? incomeSpots.reduce((curr, next) => curr.y > next.y ? curr : next).y
        : 0;
    double maxExpense = expenseSpots.isNotEmpty
        ? expenseSpots.reduce((curr, next) => curr.y > next.y ? curr : next).y
        : 0;

    return maxIncome > maxExpense ? maxIncome : maxExpense;
  }

  List<Transaction> _groupTransactionsByTypeAndDate(
      String type, int currentMonth) {
    return transactions.where((transaction) {
      return transaction.type == type && transaction.date.month == currentMonth;
    }).toList();
  }

  void _updateListsFromGroupedTransactions(
      List<double> targetList, List<Transaction> groupedTransactions) {
    for (var transaction in groupedTransactions) {
      int index = transaction.date.day - 1;
      if (index >= 0 && index < targetList.length) {
        targetList[index] += transaction.amount;
      }
    }
  }
}
