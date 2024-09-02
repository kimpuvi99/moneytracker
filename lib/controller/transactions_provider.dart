import 'package:flutter/material.dart';
import 'package:money_tracker/model/transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  double getTotalIncomes() {
    return _transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double getTotalExpenses() {
    return _transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double getBalance() {
    return getTotalIncomes() + getTotalExpenses();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
