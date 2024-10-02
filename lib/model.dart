class Person {
  final String id;
  String name;
  double balance;
  List<Expense> expenses;

  Person(
      {required this.id,
      required this.name,
      this.balance = 0.0,
      required this.expenses});

  factory Person.fromJson(Map<String, dynamic> json) {
    var expenseList = (json['expenses'] as List)
        .map((expenseJson) => Expense.fromJson(expenseJson))
        .toList();
    return Person(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
      expenses: expenseList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'expenses': expenses.map((e) => e.toJson()).toList(),
    };
  }
}

class Expense {
  final String id;
  String description;
  double amount;

  Expense({required this.id, required this.description, required this.amount});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
    };
  }
}
