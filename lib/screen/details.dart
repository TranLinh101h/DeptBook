import 'package:dept_book/business_logic.dart';
import 'package:dept_book/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PersonDetailScreen extends StatelessWidget {
  final String personId;
  final ExpenseController expenseController = Get.find();

  PersonDetailScreen({required this.personId});

  @override
  Widget build(BuildContext context) {
    var person = expenseController.people.firstWhere((p) => p.id == personId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết chi tiêu: ${person.name}'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: person.expenses.length,
            itemBuilder: (context, index) {
              var expense = person.expenses[index];
              return Card(
                child: ListTile(
                  title: Text(expense.description),
                  subtitle:
                      Text('Số tiền: ${expense.amount.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        expenseController.deleteExpense(person.id, expense.id),
                  ),
                  onTap: () {
                    _showEditExpenseDialog(context, person.id, expense);
                  },
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  // Hiển thị dialog để sửa chi tiêu
  void _showEditExpenseDialog(
      BuildContext context, String personId, Expense expense) {
    final TextEditingController _descriptionController =
        TextEditingController(text: expense.description);
    final TextEditingController _amountController =
        TextEditingController(text: expense.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sửa chi tiêu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Số tiền'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                var updatedExpense = Expense(
                  id: expense.id,
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                );
                expenseController.editExpense(personId, updatedExpense);
                Navigator.pop(context); // Đóng dialog sau khi sửa xong
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
