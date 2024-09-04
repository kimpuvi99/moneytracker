import 'package:money_tracker/model/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_tracker/model/transaction.dart' as myTransaction;

class TransactionDatabase {
  static final TransactionDatabase instance = TransactionDatabase._init();
  static Database? _database;

  TransactionDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'transactions.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            type TEXT, 
            amount REAL,
            description TEXT,
            date INTEGER 
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> insertTransaction(myTransaction.Transaction transaction) async {
    final db = await instance.database;
    try {
      await db.insert('transactions', transaction.toMap());
    } catch (e) {
      // Manejo de errores: registra el error o muestra un mensaje al usuario
 //     print('Error al insertar transacción: $e');
    }
  }

  Future<List<myTransaction.Transaction>> getTransactions() async {
    final db = await instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('transactions');

      return List.generate(maps.length, (i) {
        return myTransaction.Transaction(
          id: maps[i]['id'],
          type: _parseTransactionType(maps[i]['type']),
          amount: maps[i]['amount'],
          description: maps[i]['description'],
          date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
        );
      });
    } catch (e) {
      // Manejo de errores: registra el error o muestra un mensaje al usuario
//      print('Error al obtener transacciones: $e');
      return []; // Devuelve una lista vacía en caso de error
    }
  }

  // Helper function to parse TransactionType from string
  TransactionType _parseTransactionType(String typeString) {
    if (typeString.contains('TransactionType.expense')) {
      return TransactionType.expense;
    } else {
      return TransactionType.income;
    }
  }

  // Método para borrar una transacción de la base de datos
  Future<void> deleteTransaction(String id) async {
    final db = await instance.database;
    try {
      await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
 //     print('Error al borrar transacción: $e');
    }
  }

  // Método para cerrar la base de datos (opcional)
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
