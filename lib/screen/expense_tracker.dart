import 'package:dept_book/business_logic.dart';
import 'package:dept_book/main.dart';
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
    var homeController = Get.find<HomeController>();
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
      drawer: BuildDrawer(expenseController: expenseController),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.8, // Chiều cao nửa màn hình
              child: AddExpenseSection(
                expenseController: expenseController,
              ), // Thành phần thêm chi tiêu
            ),
          );
        },
        backgroundColor: homeController.colorApp.value, // Màu nền hiện đại
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Bo góc nút cho mềm mại
        ),
        elevation: 8, // Đổ bóng tạo chiều sâu
        splashColor: Colors.tealAccent, // Hiệu ứng gợn sóng khi nhấn
        child: Icon(
          Icons.attach_money,
          size: 30, // Kích thước biểu tượng lớn để dễ nhìn
          color: Colors.white, // Màu biểu tượng
        ),
        tooltip: 'Thêm chi tiêu', // Tooltip khi giữ nút
      ), // Menu Drawer hiển thị danh sách người
      body: Stack(
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
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (expenseController.people.isEmpty) {
                    return const Center(
                      child: Text(
                        "Không có người dùng, nhấn + để thêm.",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: expenseController.people.length,
                    itemBuilder: (context, index) {
                      var person = expenseController.people[index];
                      return Card(
                        color: Colors.white.withOpacity(0.6),
                        child: ListTile(
                          title: Text(person.name),
                          subtitle: Text(
                              'Số dư: ${person.balance.toStringAsFixed(2)}'),
                          onTap: () {
                            // Mở chi tiết chi tiêu của người này
                            Get.to(
                                () => PersonDetailScreen(personId: person.id));
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ver 1.0.2 Patch3",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
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
