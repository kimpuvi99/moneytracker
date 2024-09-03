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

  void updateTransaction(String id, double newAmount, String newDescription, DateTime newDate) { // Add newDate as a parameter
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == id);
    if (transactionIndex != -1) {
      _transactions[transactionIndex] = Transaction(
        id: id,
        amount: newAmount,
        description: newDescription,
        type: _transactions[transactionIndex].type,
        date: newDate, // Use the passed newDate
      );
      notifyListeners();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }
}
