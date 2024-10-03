import 'package:dept_book/business_logic.dart';
import 'package:dept_book/main.dart';
import 'package:dept_book/model.dart';
import 'package:dept_book/screen/add_link.dart';
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
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: modernColors[index],
                      borderRadius: BorderRadius.circular(20)),
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

//
List<Color> modernColors = [
  Colors.blue, // #2196F3
  Colors.teal, // #009688
  Colors.deepPurple, // #673AB7
  Colors.amber, // #FFC107
  Colors.lightGreen, // #8BC34A
  Colors.indigo, // #3F51B5
  Colors.orange, // #FF9800
  Colors.pink, // #E91E63
  Colors.lime, // #CDDC39
  Colors.cyan, // #00BCD4
  Colors.grey, // #9E9E9E
  Colors.brown, // #795548
  Colors.red, // #F44336
  Colors.purple, // #9C27B0
  Colors.green, // #4CAF50
  Colors.white, // #FFFFFF
  Color(0xFF6A5ACD), // Slate Blue
  Color(0xFF2E8B57), // Sea Green
  Color(0xFFFF7F50), // Coral
];
