import 'package:dept_book/business_logic.dart';
import 'package:dept_book/model.dart';
import 'package:dept_book/screen/add_expense_section.dart';
import 'package:dept_book/screen/build_drawer.dart';
import 'package:dept_book/screen/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ExpenseTracker extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                _showAddPersonDialog(context), // Gọi dialog để thêm người
            tooltip: "Thêm người",
          ),
        ],
      ),
      drawer: BuildDrawer(
          expenseController:
              expenseController), // Menu Drawer hiển thị danh sách người
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (expenseController.people.isEmpty) {
                return const Center(
                  child: Text(
                    "Không có người dùng, nhấn + để thêm.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: expenseController.people.length,
                itemBuilder: (context, index) {
                  var person = expenseController.people[index];
                  return Card(
                    child: ListTile(
                      title: Text(person.name),
                      subtitle:
                          Text('Số dư: ${person.balance.toStringAsFixed(2)}'),
                      onTap: () {
                        // Mở chi tiết chi tiêu của người này
                        Get.to(PersonDetailScreen(personId: person.id));
                      },
                    ),
                  );
                },
              );
            }),
          ),
          AddExpenseSection(
              expenseController: expenseController), // Thành phần thêm chi tiêu
        ],
      ),
    );
  }

  // Dialog để thêm người mới
  void _showAddPersonDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm người mới'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Tên người dùng'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  var person = Person(
                    id: Uuid().v4(),
                    name: _nameController.text,
                    expenses: [],
                  );
                  expenseController
                      .addPerson(person); // Thêm người vào danh sách
                  Navigator.pop(context); // Đóng dialog sau khi thêm
                }
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  // Phần thêm chi tiêu vào màn hình chính
}
