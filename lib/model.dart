import 'package:flutter/material.dart';

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

//

//
List<Color> modernColors = [
  Colors.blue, // #2196F3
  Colors.teal, // #009688
  Colors.deepPurple, // #673AB7
  Colors.amber, // #FFC107
  Colors.lightGreen, // #8BC34A
  Colors.indigo, // #3F51B5
  Colors.orange, // #FF9800
  Colors.pink, // #E91E63
  Colors.lime, // #CDDC39
  Colors.cyan, // #00BCD4
  Colors.grey, // #9E9E9E
  Colors.brown, // #795548
  Colors.red, // #F44336
  Colors.purple, // #9C27B0
  Colors.green, // #4CAF50
  Colors.white, // #FFFFFF
  Color(0xFF6A5ACD), // Slate Blue
  Color(0xFF2E8B57), // Sea Green
  Color(0xFFFF7F50), // Coral
];
