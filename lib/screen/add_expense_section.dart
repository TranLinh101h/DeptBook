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
  final RxList<String> _selectedPeople = <String>[].obs;

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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Thêm khoản chi mới',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _expenseController,
            decoration: const InputDecoration(
              labelText: 'Số tiền',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Mô tả chi tiêu',
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chọn người chia sẻ chi tiêu',
            style: TextStyle(
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            return Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: widget.expenseController.people.map((person) {
                return ChoiceChip(
                  label: Text(person.name),
                  selected: _selectedPeople.contains(person.name),
                  showCheckmark: true,
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  onSelected: (selected) {
                    if (selected) {
                      _selectedPeople.add(person.name);
                    } else {
                      _selectedPeople.remove(person.name);
                    }
                    _selectedPeople.refresh();
                  },
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Divider(thickness: 1, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              onAdd(
                _descriptionController,
                _expenseController,
                _selectedPeople,
              );
            },
            child: const Text('Thêm chi tiêu'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Thoát'),
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
        _selectedPeople.isNotEmpty) {
      double totalAmount = double.parse(_expenseController.text);
      double splitAmount =
          totalAmount / _selectedPeople.length; // Chia đều số tiền

      // Thêm chi tiêu cho từng người được chọn
      for (var personName in _selectedPeople) {
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
