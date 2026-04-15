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
    const Color(0xFF50E4FF),
    const Color(0xFFE80054),

    // Additional colors:
    Colors.indigo, // deep purple-blue
    Colors.teal.shade700, // rich teal
    Colors.redAccent.shade700, // strong red
    Colors.blueGrey.shade800, // dark bluish grey
    const Color(0xFF6A1B9A), // deep purple
    const Color(0xFFD84315), // burnt orange
    const Color(0xFF2E7D32), // dark green
    const Color(0xFF00897B), // teal
    const Color(0xFF303F9F), // dark indigo
    const Color(0xFF5D4037), // dark brown
    const Color(0xFF7B1FA2), // deep violet
    const Color(0xFFC2185B), // dark pink
    const Color(0xFF00695C), // cyan-green
    const Color(0xFF1A237E), // very dark blue
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
                  centerSpaceRadius: 34,
                  sections: List.generate(
                    expenseController.people.length,
                    (i) {
                      final isTouched = i == touchedIndex;
                      var people = expenseController.people[i];
                      final color = listColor[i % listColor.length];
                      final total = expenseController.people
                          .map((element) => element.balance)
                          .reduce((value, element) => value + element);
                      final percent = total == 0
                          ? 0.0
                          : (people.balance / total * 100).roundToDouble();

                      return PieChartSectionData(
                        color: color,
                        value: percent,
                        title: "$percent%\n${people.name}",
                        titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                        radius: isTouched ? 104 : 98,
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
