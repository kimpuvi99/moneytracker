import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transactions_provider.dart';
import 'package:money_tracker/view/widgets/header_card.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionsProvider>(context);
    final balance = provider.getBalance();
    final incomes = provider.getTotalIncomes();
    final expenses = provider.getTotalExpenses();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.teal,
      ),
      child: Column(
        children: [
          Text('Balance',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          Text('€ ${balance.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                HeaderCard(
                  icon: const Icon(
                    Icons.attach_money,
                    color: Colors.teal,
                  ),
                  title: 'Incomes',
                  value: incomes,
                ),
                const SizedBox(width: 15),
                HeaderCard(
                  icon: const Icon(
                    Icons.money_off,
                    color: Colors.red,
                  ),
                  title: 'Expenses',
                  value: expenses,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}