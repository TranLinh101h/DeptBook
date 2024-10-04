import 'package:dept_book/business_logic.dart';
import 'package:dept_book/main.dart';
import 'package:dept_book/model.dart';
import 'package:dept_book/screen/add_expense_section.dart';
import 'package:dept_book/screen/build_drawer.dart';
import 'package:dept_book/screen/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../shore_bird_service.dart';

class ExpenseTracker extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    var homeController = Get.find<HomeController>();
    var shoreBird = Get.put(ShoreBirdService());
    shoreBird.checkForUpdate(context, showError: false);

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
      floatingActionButton: _buildFloatingActionButton(
        shoreBird,
        context,
        homeController,
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
          SafeArea(
            child: Column(
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
                              Get.to(() =>
                                  PersonDetailScreen(personId: person.id));
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          "V1.0.3 Patch ${shoreBird.currentPatchVersion.value}",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildFloatingActionButton(ShoreBirdService shoreBird,
      BuildContext context, HomeController homeController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //CHECK UPDATE
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Obx(
            () => shoreBird.isShorebirdAvailable.value
                ? FloatingActionButton(
                    tooltip: 'Check update',
                    onPressed: () => shoreBird.isCheckingForUpdate.value
                        ? null
                        : shoreBird.checkForUpdate(context),
                    backgroundColor:
                        homeController.colorApp.value, // Màu nền hiện đại
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Bo góc nút cho mềm mại
                    ),
                    elevation: 8, // Đổ bóng tạo chiều sâu
                    splashColor:
                        Colors.tealAccent, // Hiệu ứng gợn sóng khi nhấn
                    child: shoreBird.isCheckingForUpdate.value
                        ? const _LoadingIndicator()
                        : const Icon(
                            Icons.update,
                            color: Colors.white,
                            size: 30,
                          ),
                  )
                : const SizedBox(),
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
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
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 1.5, // Chiều cao nửa màn hình
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border(
                top: BorderSide(
                  width: 3,
                  color: Theme.of(context).drawerTheme.backgroundColor!,
                ),
              ),
              color: Theme.of(context)
                  .drawerTheme
                  .backgroundColor!
                  .withOpacity(0.5)),
          child: AddExpenseSection(
            expenseController: expenseController,
          ),
        ), // Thành phần thêm chi tiêu
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

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 14,
      width: 14,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
