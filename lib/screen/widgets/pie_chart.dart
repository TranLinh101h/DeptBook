import 'dart:math';

import 'package:dept_book/business_logic.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuilPieChart extends StatefulWidget {
  const BuilPieChart({super.key});

  @override
  State<StatefulWidget> createState() => BuilPieChartState();
}

class BuilPieChartState extends State {
  final ExpenseController expenseController = Get.put(ExpenseController());

  int touchedIndex = -1;

  final listColor = [
    AppColors.contentColorBlue,
    AppColors.contentColorYellow,
    Colors.deepOrangeAccent,
    Colors.green.shade800,
    Color(0xFF50E4FF),
    Color(0xFFE80054)
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Obx(
              () => PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // setState(() {
                      //   if (!event.isInterestedForInteractions ||
                      //       pieTouchResponse == null ||
                      //       pieTouchResponse.touchedSection == null) {
                      //     touchedIndex = -1;
                      //     return;
                      //   }
                      //   touchedIndex = pieTouchResponse
                      //       .touchedSection!.touchedSectionIndex;
                      // });
                    },
                  ),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 1,
                  centerSpaceRadius: 30,
                  sections: List.generate(
                    expenseController.people.value.length,
                    (i) {
                      final isTouched = i == touchedIndex;
                      var people = expenseController.people.value[i];
                      final color = listColor[Random().nextInt(6)];
                      final total = expenseController.people.value
                          .map((element) => element.balance)
                          .reduce((value, element) => value + element);
                      final percent =
                          (people.balance / total * 100).roundToDouble();

                      return PieChartSectionData(
                        color: color,
                        value: percent,
                        title: "$percent%\n${people.name.toString()}",
                        titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        radius: 100,
                        titlePositionPercentageOffset: 0.55,
                        borderSide: isTouched
                            ? const BorderSide(
                                color: AppColors.contentColorWhite, width: 6)
                            : BorderSide(
                                color:
                                    AppColors.contentColorWhite.withOpacity(0)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PieChartSectionData buildSection() {
  //   return;
  // }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
