enum TransactionType { income, expense }

class Transaction {
  final String id; 
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;

  Transaction({
    required this.id, 
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  }); 

  // Add the toMap() method:
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(), // Convert enum to string for database
      'amount': amount,
      'description': description,
      'date': date.millisecondsSinceEpoch, // Store date as milliseconds 
    };
  }
}
