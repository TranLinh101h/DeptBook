import 'package:dept_book/business_logic.dart';
import 'package:dept_book/main.dart';
import 'package:dept_book/model.dart';
import 'package:dept_book/screen/widgets/add_link.dart';
import 'package:dept_book/shore_bird_service.dart';
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
    var shoreBird = Get.put(ShoreBirdService());

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                LinkSubmitWidget(),
                DrawerHeader(
                  child: Text(
                    'Danh sách người',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: expenseController.people.length,
                    itemBuilder: (context, index) {
                      var person = expenseController.people[index];
                      return ListTile(
                        title: Text(person.name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmDeletePerson(context, person);
                          },
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
            margin: EdgeInsets.only(bottom: 20),
            height: 100,
            child: ListView.builder(
              itemCount: modernColors.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => CupertinoButton(
                onPressed: () {
                  var contrOller = Get.find<HomeController>();
                  contrOller.changeColor(modernColors[index]);
                  contrOller.updateIndexColor(index);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: modernColors[index],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  width: 80,
                  height: 80,
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
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                expenseController
                    .deletePerson(person.id); // Xóa người và chi tiêu liên quan
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
