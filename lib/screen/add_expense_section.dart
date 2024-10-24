import 'package:dept_book/business_logic.dart';
import 'package:dept_book/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddExpenseSection extends StatefulWidget {
  final ExpenseController expenseController;

  const AddExpenseSection({
    Key? key,
    required this.expenseController,
  }) : super(key: key);

  @override
  _AddExpenseSectionState createState() => _AddExpenseSectionState();
}

class _AddExpenseSectionState extends State<AddExpenseSection> {
  late TextEditingController _descriptionController;
  late TextEditingController _expenseController;
  var _selectedPeople = <String>[].obs;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _expenseController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Mô tả chi tiêu',
            ),
          ),
          TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
              children: widget.expenseController.people.map((person) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).drawerTheme.backgroundColor,
            ),
          ),
          const SizedBox(height: 30),
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
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Thoát'),
          ),
        ],
      ),
    );
  }

  void onAdd(
    TextEditingController _descriptionController,
    TextEditingController _expenseController,
    RxList<String> _selectedPeople,
  ) {
    if (_descriptionController.text.isNotEmpty &&
        _expenseController.text.isNotEmpty &&
        _selectedPeople.value.isNotEmpty) {
      double totalAmount = double.parse(_expenseController.text);
      double splitAmount =
          totalAmount / _selectedPeople.value.length; // Chia đều số tiền

      // Thêm chi tiêu cho từng người được chọn
      for (var personName in _selectedPeople.value) {
        var person = widget.expenseController.people
            .firstWhere((p) => p.name == personName);
        var expense = Expense(
          id: Uuid().v4(),
          description: _descriptionController.text,
          amount: splitAmount,
        );
        widget.expenseController.addExpenseToPerson(person.id, expense);
      }

      _descriptionController.clear();
      _expenseController.clear();
    }
  }
}
