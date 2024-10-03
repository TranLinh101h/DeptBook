import 'package:dept_book/business_logic.dart';
import 'package:dept_book/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddExpenseSection extends StatelessWidget {
  const AddExpenseSection({
    super.key,
    required this.expenseController,
  });

  final ExpenseController expenseController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _expenseController = TextEditingController();
    var _selectedPeople = <String>[].obs;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
            style: TextStyle(fontWeight: FontWeight.bold),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Mô tả chi tiêu',
            ),
          ),
          TextField(
            style: TextStyle(fontWeight: FontWeight.bold),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: _expenseController,
            decoration: InputDecoration(labelText: 'Số tiền'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Text('Chọn người chia sẻ chi tiêu:'),
          Obx(() {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              children: expenseController.people.map((person) {
                return ChoiceChip(
                  label: Text(person.name),
                  selected: _selectedPeople.value.contains(person.name),
                  onSelected: (selected) {
                    if (selected) {
                      _selectedPeople.value.add(person.name);
                    } else {
                      _selectedPeople.value.remove(person.name);
                    }
                    _selectedPeople.refresh();
                  },
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onAdd(
                _descriptionController,
                _expenseController,
                _selectedPeople,
              );
            },
            child: Text('Thêm chi tiêu'),
          ),
        ],
      ),
    );
  }

  void onAdd(
      TextEditingController _descriptionController,
      TextEditingController _expenseController,
      RxList<String> _selectedPeople) {
    if (_descriptionController.text.isNotEmpty &&
        _expenseController.text.isNotEmpty &&
        _selectedPeople.value.isNotEmpty) {
      double totalAmount = double.parse(_expenseController.text);
      double splitAmount =
          totalAmount / _selectedPeople.value.length; // Chia đều số tiền

      // Thêm chi tiêu cho từng người được chọn
      for (var personName in _selectedPeople.value) {
        var person =
            expenseController.people.firstWhere((p) => p.name == personName);
        var expense = Expense(
          id: Uuid().v4(),
          description: _descriptionController.text,
          amount: splitAmount,
        );
        expenseController.addExpenseToPerson(person.id, expense);
      }

      _descriptionController.clear();
      _expenseController.clear();
      _selectedPeople.clear();
    }
  }
}
