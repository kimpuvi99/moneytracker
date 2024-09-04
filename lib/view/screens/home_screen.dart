import 'package:flutter/material.dart';
import '../components/add_transaction_dialog.dart';
import '../components/home_header.dart';
import '../components/transactions_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: const SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeHeader(),
            TransactionsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const AddTransactionDialog());
        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}