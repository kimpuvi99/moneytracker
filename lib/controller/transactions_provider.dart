import 'package:flutter/material.dart';
import 'package:money_tracker/model/transaction.dart';
import 'package:money_tracker/database/transaction_database.dart'; // Import for database

class TransactionsProvider extends ChangeNotifier {
  List<Transaction> _transactions = []; // Changed to non-final

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

  void addTransaction(Transaction transaction, String category) { // Añadido category como parámetro
    _transactions.add(transaction);
    notifyListeners();
  }

  void updateTransaction(String id, double newAmount, String newDescription, DateTime newDate, String newCategory) {  // Añadido newCategory como parámetro
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == id);
    if (transactionIndex != -1) {
      _transactions[transactionIndex] = Transaction(
        id: id,
        amount: newAmount,
        description: newDescription,
        type: _transactions[transactionIndex].type,
        date: newDate,
        category: newCategory,  // Usado newCategory aquí
      );
      notifyListeners();
    }
  }

  // Método modificado para borrar de la base de datos
  void deleteTransaction(String id) async {
    // 1. Borra la transacción de la base de datos
    await TransactionDatabase.instance.deleteTransaction(id); 

    // 2. Borra la transacción de la lista en memoria
    _transactions.removeWhere((transaction) => transaction.id == id);

    // 3. Notifica a los oyentes del cambio
    notifyListeners();
  }

  // Method to fetch transactions from the database
  Future<void> fetchTransactions() async {
    _transactions = await TransactionDatabase.instance.getTransactions();
    notifyListeners();
  }
}
