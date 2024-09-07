import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transactions_provider.dart';
import 'package:money_tracker/model/transaction.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/database/transaction_database.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'; 
import 'package:money_tracker/view/screens/categories_screen.dart'; // Asegúrate de importar categories_screen.dart


class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({
    super.key,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  double
 amount = 0;
  String description = '';
  TransactionType type = TransactionType.income;
  DateTime? _selectedDate; 
  String selectedCategory = CategoriesScreen.getCategories().isNotEmpty ? CategoriesScreen.getCategories()[0] : '';

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 730,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const
 EdgeInsets.symmetric(horizontal: 16.0),
                  child: CupertinoSlidingSegmentedControl(
                    children: const {
                      0: Text('Expense'),
                      1: Text('Income'),
                    },
                    onValueChanged: (int? index) {
                      setState(() {
                        if (index == 0) {
                          type = TransactionType.expense;
                        } else {
                          type = TransactionType.income;
                        }
                      });
                    },
                    groupValue: type == TransactionType.expense ? 0 : 1,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'AMOUNT',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                TextField(
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(symbol: '€')
                  ],
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(hintText: '€ 0.00'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final cleanValue = value.replaceAll('€', '').replaceAll(',', '');
                    if (cleanValue.isNotEmpty) {
                      amount = double.parse(cleanValue);
                    }
                  },
                ),
               
                const SizedBox(height: 20),
              
                Text(
                  'ACCOUNT',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                const TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Select Account',
                    hintStyle: TextStyle(color: Colors.grey)
                  ),
                  keyboardType: TextInputType.text,
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'CATEGORY',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: CategoriesScreen.getCategories().map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Date Picker Field 
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: 'yyyy-MM-dd',                     
                    border:
 OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                      borderSide: BorderSide(color: Colors.grey[400]!), 
                    ),
                    filled: true,
                    fillColor: Colors.grey[100], 
                    prefixIcon: const Icon(Icons.calendar_today), 
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_drop_down), 
                      onPressed: _presentDatePicker, 
                    ),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                  readOnly: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, 
                  ),
                ),
                const SizedBox(height: 20),

                // Description Input Field
               Text(
                  'DESCRIPTION',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Enter description here',
                    hintStyle: TextStyle(color: Colors.grey)
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    description = value;
                  },
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () async { 
                    String newId = const Uuid().v4(); 

                    final transaction = Transaction(
                      id: newId, 
                      type: type,
                      amount: type == TransactionType.expense ? -amount : amount,
                      description: description,
                      date: _selectedDate ?? DateTime.now(), 
                      category: selectedCategory,
                    );

                    // Save to the database 
                    await TransactionDatabase.instance.insertTransaction(transaction, selectedCategory); 

                    // Update TransactionsProvider 
                    Provider.of<TransactionsProvider>(context, listen: false).addTransaction(transaction, selectedCategory); 

                    Navigator.pop(context); 
                  },
                  child: const Text('Add Transaction', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
