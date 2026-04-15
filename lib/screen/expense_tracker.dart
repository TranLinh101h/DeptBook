import 'package:dept_book/business_logic.dart';
import 'package:dept_book/main.dart';
import 'package:dept_book/model.dart';
import 'package:dept_book/screen/add_expense_section.dart';
import 'package:dept_book/screen/build_drawer.dart';
import 'package:dept_book/screen/details.dart';
import 'package:dept_book/screen/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ExpenseTracker extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    var homeController = Get.find<HomeController>();
    // var shoreBird = Get.put(ShoreBirdService());
    // shoreBird.checkForUpdate(context, showError: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Quản lý chi tiêu',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () =>
                _showAddPersonDialog(context), // Gọi dialog để thêm người
            tooltip: "Thêm người",
          ),
        ],
      ),
      drawer: BuildDrawer(expenseController: expenseController),
      floatingActionButton: _buildFloatingActionButton(
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.86),
                        border: Border.all(
                          color: homeController.colorApp.value.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: homeController.colorApp.value
                                  .withOpacity(0.16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.groups_2_rounded,
                              color: homeController.colorApp.value,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tổng số người: ${expenseController.people.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 3,
                    child: Obx(() {
                      if (expenseController.people.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.84),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Không có người dùng, nhấn nút + để thêm.',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: expenseController.people.length,
                        itemBuilder: (context, index) {
                          var person = expenseController.people[index];
                          final balance = person.balance;
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: homeController.colorApp.value
                                    .withOpacity(0.16),
                                child: Text(
                                  person.name.characters.first.toUpperCase(),
                                  style: TextStyle(
                                    color: homeController.colorApp.value,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                person.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                'Số dư: ${balance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: balance >= 0
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                Get.to(() =>
                                    PersonDetailScreen(personId: person.id));
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.86),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: homeController.colorApp.value.withOpacity(0.2),
                        ),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 210,
                          height: 210,
                          child: BuilPieChart(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Container(
                  //   margin: EdgeInsets.all(20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Obx(
                  //         () => Text(
                  //           "V1.0.4 Patch ${shoreBird.currentPatchVersion.value}",
                  //           style: TextStyle(
                  //               color: Colors.blue, fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildFloatingActionButton(
      BuildContext context, HomeController homeController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //CHECK UPDATE
        // Container(
        //   margin: EdgeInsets.only(bottom: 10),
        //   child: Obx(
        //     () => shoreBird.isShorebirdAvailable.value
        //         ? FloatingActionButton(
        //             tooltip: 'Check update',
        //             onPressed: () => shoreBird.isCheckingForUpdate.value
        //                 ? null
        //                 : shoreBird.checkForUpdate(context),
        //             backgroundColor:
        //                 homeController.colorApp.value, // Màu nền hiện đại
        //             shape: RoundedRectangleBorder(
        //               borderRadius:
        //                   BorderRadius.circular(15), // Bo góc nút cho mềm mại
        //             ),
        //             elevation: 8, // Đổ bóng tạo chiều sâu
        //             splashColor:
        //                 Colors.tealAccent, // Hiệu ứng gợn sóng khi nhấn
        //             child: shoreBird.isCheckingForUpdate.value
        //                 ? const _LoadingIndicator()
        //                 : const Icon(
        //                     Icons.update,
        //                     color: Colors.white,
        //                     size: 30,
        //                   ),
        //           )
        //         : const SizedBox(),
        //   ),
        // ),
        FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          backgroundColor: homeController.colorApp.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 6,
          splashColor: Colors.tealAccent,
          child: const Icon(
            Icons.attach_money,
            size: 30,
            color: Colors.white,
          ),
          tooltip: 'Thêm chi tiêu',
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    final borderColor =
        Theme.of(context).drawerTheme.backgroundColor!.withOpacity(0.28);
    showModalBottomSheet(
      barrierColor: Colors.black26,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.94,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border(
                top: BorderSide(
                  width: 3,
                  color: borderColor,
                ),
              ),
              color: Colors.white.withOpacity(0.96)),
          child: AddExpenseSection(
            expenseController: expenseController,
          ),
        ),
      ),
    );
  }

  // Dialog để thêm người mới
  void _showAddPersonDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm người mới'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Tên người dùng'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  var person = Person(
                    id: Uuid().v4(),
                    name: nameController.text,
                    expenses: [],
                  );
                  expenseController
                      .addPerson(person); // Thêm người vào danh sách
                  Navigator.pop(context); // Đóng dialog sau khi thêm
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  // Phần thêm chi tiêu vào màn hình chính
}
