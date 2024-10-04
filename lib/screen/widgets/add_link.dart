import 'package:dept_book/business_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class LinkSubmitWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isLinkValid = ValueNotifier(false);

  LinkSubmitWidget({Key? key}) : super(key: key) {
    _controller.addListener(() {
      // Kiểm tra nếu TextField không rỗng thì bật nút "Submit"
      _isLinkValid.value = _controller.text.isNotEmpty;
    });
  }

  // Hàm khi nhấn submit
  void _onSubmit(BuildContext context) {
    final link = _controller.text;
    var controller = Get.find<ExpenseController>();
    controller.updateLink(link);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link đã được nhập: $link')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nhập link...',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
          ),
          SizedBox(width: 10),
          // Sử dụng ValueListenableBuilder để cập nhật nút "Submit"
          ValueListenableBuilder<bool>(
            valueListenable: _isLinkValid,
            builder: (context, isLinkValid, child) {
              return ElevatedButton(
                onPressed: () =>
                    _onSubmit(context), // Chỉ kích hoạt nếu link hợp lệ
                child: Text('Submit'),
              );
            },
          ),
        ],
      ),
    );
  }
}
