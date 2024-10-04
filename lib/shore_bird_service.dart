import 'package:dept_book/storage_mananger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShoreBirdService extends GetxController {
  final StorageManager storageManager = StorageManager();
  final _shorebirdCodePush = ShorebirdCodePush();
  var isShorebirdAvailable = false.obs;
  var currentPatchVersion = 0.obs;
  var isCheckingForUpdate = false.obs;

  @override
  void onInit() {
    super.onInit();
    isShorebirdAvailable.value = _shorebirdCodePush.isShorebirdAvailable();

    // Lấy phiên bản hiện tại của bản vá
    _shorebirdCodePush.currentPatchNumber().then((currentPatch) {
      currentPatchVersion.value = currentPatch ?? 0;

      // Kiểm tra và so sánh với phiên bản bản vá mới nhất
      _checkForPatchDifference();
    });
  }

  // Phương thức này sẽ kiểm tra sự khác biệt giữa bản vá hiện tại và bản vá mới nhất
  Future<void> _checkForPatchDifference() async {
    final isUpdateReadyToInstall =
        await _shorebirdCodePush.isNewPatchReadyToInstall();

    if (isUpdateReadyToInstall) {
      final newPatchNumber = await _shorebirdCodePush.currentPatchNumber();

      // Nếu bản vá hiện tại khác với bản vá mới nhất, khởi động lại ứng dụng
      if (currentPatchVersion.value != newPatchNumber) {
        Restart.restartApp();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          checkForUpdate(Get.context!, showError: false);
        });
      }
    }
  }

  Future<void> checkForUpdate(BuildContext context,
      {bool showError = true}) async {
    isCheckingForUpdate.value = true;

    // Hỏi các server của Shorebird nếu có bản cập nhật mới
    final isUpdateAvailable =
        await _shorebirdCodePush.isNewPatchAvailableForDownload();

    isCheckingForUpdate.value = false;

    if (isUpdateAvailable) {
      _showUpdateAvailableBanner(context);
    } else {
      if (showError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No update available'),
          ),
        );
      }
    }
  }

  // Hàm hiển thị thông báo cập nhật
  void _showUpdateAvailableBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('Update available'),
        actions: [
          TextButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              await _downloadUpdate(context);

              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadUpdate(BuildContext context) async {
    _showDownloadingBanner(context);

    await Future.wait([
      _shorebirdCodePush.downloadUpdateIfAvailable(),
      Future<void>.delayed(const Duration(milliseconds: 250)),
    ]);

    final isUpdateReadyToInstall =
        await _shorebirdCodePush.isNewPatchReadyToInstall();

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    if (isUpdateReadyToInstall) {
      // Khởi động lại ứng dụng nếu bản vá đã sẵn sàng để cài đặt
      Restart.restartApp();
    } else {
      _showErrorBanner(context);
    }
  }

  void _showDownloadingBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text('Downloading...'),
        actions: [
          SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('An error occurred while downloading the update.'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
