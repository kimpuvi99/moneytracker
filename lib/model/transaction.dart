enum TransactionType { income, expense }

class Transaction {
  final String id; // Add the id property
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;

  Transaction({
    required this.id, // Make id a required positional parameter
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  }); // Remove the ID generation from the constructor 
}
