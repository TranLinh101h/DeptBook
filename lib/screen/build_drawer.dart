import 'package:dept_book/business_logic.dart';
import 'package:dept_book/main.dart';
import 'package:dept_book/model.dart';
import 'package:dept_book/screen/widgets/add_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({
    super.key,
    required this.expenseController,
  });

  final ExpenseController expenseController;

  @override
  Widget build(BuildContext context) {
    // var shoreBird = Get.put(ShoreBirdService());
    final homeController = Get.find<HomeController>();

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        homeController.colorApp.value,
                        homeController.colorApp.value.withOpacity(0.65),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        Icon(Icons.tune_rounded, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Tùy chỉnh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                LinkSubmitWidget(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text(
                    'Danh sách người',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expenseController.people.length,
                    itemBuilder: (context, index) {
                      var person = expenseController.people[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                homeController.colorApp.value.withOpacity(0.15),
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () {
                              _confirmDeletePerson(context, person);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          //
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 18),
            padding: const EdgeInsets.only(top: 10),
            height: 116,
            child: ListView.builder(
              itemCount: modernColors.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  var contrOller = Get.find<HomeController>();
                  contrOller.changeColor(modernColors[index]);
                  contrOller.updateIndexColor(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: modernColors[index],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 2.5,
                      color: index == homeController.indexColor.value
                          ? Colors.black87
                          : Colors.white,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  width: 68,
                  height: 68,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Xác nhận xóa người với Dialog
  void _confirmDeletePerson(BuildContext context, Person person) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa ${person.name}?'),
          content: Text(
              'Bạn có chắc chắn muốn xóa ${person.name} và toàn bộ chi tiêu của họ?'),
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
                    .deletePerson(person.id); // Xóa người và chi tiêu liên quan
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
