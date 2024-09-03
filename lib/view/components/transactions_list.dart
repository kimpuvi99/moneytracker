import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transactions_provider.dart';
import 'package:money_tracker/model/transaction.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  void _showEditTransactionDialog(BuildContext context, Transaction transaction) {
    final amountController = TextEditingController(text: transaction.amount.toStringAsFixed(2));
//    final categoryController = TextEditingController(text: transaction.description);
    final descriptionController = TextEditingController(text: transaction.description);
    DateTime selectedDate = transaction.date; 
    final dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectedDate));

    void presentDatePicker() {
      showDatePicker(
        context: context,
        
initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        selectedDate = pickedDate; 
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo para editar la cantidad
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              // Campo para editar la descripción
              // TextField(
              //   decoration: const InputDecoration(labelText: 'Category'),
              //   controller: categoryController,
//              ),
              // Campo para editar la fecha
              TextField(
                decoration: const InputDecoration(labelText: 'Date'),
                controller: dateController,              
                readOnly: true,
                onTap: presentDatePicker,
              ),
              // Campo para editar la descripción
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: descriptionController,
              ),              
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Eliminar la transacción
                Provider.of<TransactionsProvider>(context, listen: false)
                    .deleteTransaction(transaction.id);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                // Guardar cambios
                final updatedAmount = double.tryParse(amountController.text) ?? 0.0;
                Provider.of<TransactionsProvider>(context, listen: false)
                    .updateTransaction(
                  transaction.id,
                  updatedAmount,
                  descriptionController.text,
                  selectedDate, 
                );
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionsProvider>(context).transactions;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final type = transaction.type == TransactionType.income
                ? 'Income'
                : 'Expense';
            final value = transaction.type == TransactionType.expense
                ? '-€ ${transaction.amount.abs().toStringAsFixed(2)}'
                : '€ ${transaction.amount.toStringAsFixed(2)}';
            final color = transaction.type == TransactionType.expense
                ? Colors.red
                : Colors.teal;

            return GestureDetector(
              onTap: () {
                _showEditTransactionDialog(context, transaction);
              },
              child: ListTile(
                title: Text(transaction.description),
                subtitle: Text(type),
                trailing: Text(
                  value,
                  style: TextStyle(fontSize: 14, color: color),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

