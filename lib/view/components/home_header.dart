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
          const SizedBox(height: 12),
          Text(
            'MONEY TRACKER',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.teal.shade900, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Balance:',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white.withOpacity(0.5))),
          Text('\$ ${balance.toStringAsFixed(2)}',
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
                const SizedBox(width: 12),
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
