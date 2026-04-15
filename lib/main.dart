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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quản lý chi tiêu',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: controller.colorApp.value,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F7FB),
          appBarTheme: AppBarTheme(
            backgroundColor: controller.colorApp.value,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: controller.colorApp.value,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white.withOpacity(0.88),
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: controller.colorApp.value.withOpacity(0.08),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: controller.colorApp.value.withOpacity(0.16),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: controller.colorApp.value,
                width: 1.5,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          chipTheme: ChipThemeData(
            selectedColor: controller.colorApp.value.withOpacity(0.18),
            side: BorderSide(
              color: controller.colorApp.value.withOpacity(0.22),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
