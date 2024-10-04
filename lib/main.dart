import 'package:dept_book/model.dart';
import 'package:dept_book/screen/expense_tracker.dart';
import 'package:dept_book/storage_mananger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

// User Interface (UI)
void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quản lý chi tiêu',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: controller.colorApp.value, // Màu nền của AppBar
            foregroundColor: Colors.white, // Màu chữ trên AppBar
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: controller.colorApp.value, // Màu nền của Drawer
          ),
        ),
        home: ExpenseTracker(),
      ),
    );
  }
}

class HomeController extends GetxController {
  final StorageManager storageManager = StorageManager();
  var colorApp = (Colors.teal as Color).obs;
  var indexColor = 0.obs;

  @override
  void onInit() {
    super.onInit();
    indexColor.value = storageManager.getData("indexColor") ?? 0;
    changeColor(modernColors[indexColor.value]);
  }

  changeColor(Color color) => colorApp.value = color;

  updateIndexColor(int index) {
    indexColor.value = index;
    storageManager.saveData("indexColor", index);
  }
}
