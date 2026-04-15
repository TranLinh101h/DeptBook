import 'package:dept_book/business_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonDetailScreen extends StatelessWidget {
  final String personId;
  final ExpenseController expenseController = Get.find();

  PersonDetailScreen({required this.personId});

  @override
  Widget build(BuildContext context) {
    var indexPerson =
        expenseController.people.indexWhere((p) => p.id == personId);
    final person = expenseController.people[indexPerson];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          person.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          Obx(
            () => expenseController.people[indexPerson].expenses.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () => _confirmDelete(context, personId),
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Obx(() {
              String link = expenseController.linkImage.value;

              if (link.isNotEmpty) {
                return SizedBox.expand(
                  child: Image.network(
                    expenseController.linkImage.value,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return SizedBox();
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.86),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.savings_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tổng tiền: ${expenseController.people[indexPerson].balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount:
                        expenseController.people[indexPerson].expenses.length,
                    itemBuilder: (context, index) {
                      var expense =
                          expenseController.people[indexPerson].expenses[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          title: Text(expense.description),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Số tiền: ${expense.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                expense.dateCreated ?? '',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => expenseController.deleteExpense(
                                expenseController.people[indexPerson].id,
                                expense.id),
                          ),
                          onTap: () {
                            // _showEditExpenseDialog(
                            //     context,
                            //     expenseController.people.value[indexPerson].id,
                            //     expense);
                          },
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Xác nhận xóa
  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa Tất Cả?'),
          content: const Text('Xác nhận xoá tất cả chi tiết?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                expenseController
                    .deleteExpensePerson(id); // Xóa người và chi tiêu liên quan
                Navigator.pop(context); // Đóng dialog
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
