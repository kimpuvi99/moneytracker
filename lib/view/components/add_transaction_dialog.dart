import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transactions_provider.dart';
import 'package:money_tracker/model/transaction.dart';
import 'package:provider/provider.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({
    super.key,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  double amount = 0;
  String description = '';
  TransactionType type = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 680,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 6,
            width: 48,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: const Text(
              'New Transaction',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                TextField(
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(symbol: '\$')
                    ],
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration.collapsed(hintText: '\$0.00'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      print('Value: $value');
                      final cleanValue = value.replaceAll('\$', '');
                      final cleanValue2 = cleanValue.replaceAll(',', '');
                      print('Clean Value: $cleanValue2');
                      if (cleanValue2.isNotEmpty) {
                        amount = double.parse(cleanValue2);
                      }
                    }),
                const SizedBox(height: 20),
                Text(
                  'DESCRIPTION',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Enter description here',
                      hintStyle: TextStyle(color: Colors.grey)),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    description = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () {
                      // Add transaction
                      final transaction = Transaction(
                        type: type,
                        amount:
                            type == TransactionType.expense ? -amount : amount,
                        description: description,
                      );

                      Provider.of<TransactionsProvider>(context, listen: false)
                          .addTransaction(transaction);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
