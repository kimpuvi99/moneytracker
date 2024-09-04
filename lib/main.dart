import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transactions_provider.dart';
import 'package:money_tracker/database/transaction_database.dart'; // Importa la base de datos
import 'package:money_tracker/view/screens/categories_screen.dart';
import 'package:provider/provider.dart';
import 'view/screens/home_screen.dart';
import 'view/screens/accounts_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @
override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionsProvider()..fetchTransactions(),
      child: MaterialApp(
        title: 'Money Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const NavigationHomeScreenContainer(), // Nuevo widget contenedor
      ),
    );
  }
}

// Nuevo widget contenedor para NavigationHomeScreen
class NavigationHomeScreenContainer extends StatefulWidget {
  const NavigationHomeScreenContainer({super.key});

  @override
  State<NavigationHomeScreenContainer> createState() => _NavigationHomeScreenContainerState();
}

class _NavigationHomeScreenContainerState extends State<NavigationHomeScreenContainer> {
  @override
  Widget build(BuildContext context) {
    return const NavigationHomeScreen(); // Retorna el NavigationHomeScreen original
  }

  @override
  void dispose() {
    TransactionDatabase.instance.close(); // Cierra la base de datos
    super.dispose();
  }
}

// Nueva clase para manejar la navegación con el Drawer (sin cambios)

class NavigationHomeScreen extends StatelessWidget {
  const NavigationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Colors.teal,
      ),
      drawer: SizedBox(
        child: Drawer(        
          child: ListView(   
            padding: EdgeInsets.zero, 
            children: [
              const SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),   
                  child: Text('Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),                        
                ),
              ),

              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('Accounts'),
                onTap: () {
                  Navigator.pop(context); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories'),
                onTap: () {
                  Navigator.pop(context); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: const HomeScreen(), 
    );
  }
}
