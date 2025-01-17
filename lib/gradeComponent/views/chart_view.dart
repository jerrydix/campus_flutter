import 'dart:math';

import 'package:campus_flutter/base/helpers/card_with_padding.dart';
import 'package:campus_flutter/base/helpers/icon_text.dart';
import 'package:campus_flutter/base/helpers/string_parser.dart';
import 'package:campus_flutter/gradeComponent/viewModels/grade_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:campus_flutter/base/extensions/context.dart';

class ChartView extends ConsumerWidget {
  const ChartView({super.key, required this.studyID, required this.title});

  final String title;
  final String studyID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.read(gradeViewModel).chartDataForDegree(studyID);
    final averageGrade = ref.read(gradeViewModel).getAverageGrade();
    return CardWithPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton<String>(
            itemBuilder: (context) =>
                ref.read(gradeViewModel).getMenuEntries(context),
            onSelected: (selected) {
              ref.read(gradeViewModel).setSelectedDegree(selected);
            },
            child: IconText(
              iconData: Icons.keyboard_arrow_down,
              label:
                  "$title (${StringParser.degreeShortFromID(studyID, context)})",
              style: Theme.of(context).textTheme.bodyLarge,
              mainAxisAlignment: MainAxisAlignment.center,
              leadingIcon: false,
            ),
          ),
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: data.values.reduce(max).toDouble(),
              interval: 1,
            ),
            series: <CartesianSeries<MapEntry<dynamic, int>, String>>[
              ColumnSeries<MapEntry<dynamic, int>, String>(
                dataSource: data.entries.toList(),
                xValueMapper: (MapEntry<dynamic, int> data, _) =>
                    data.key.toString(),
                yValueMapper: (MapEntry<dynamic, int> data, _) => data.value,
                pointColorMapper: (MapEntry<dynamic, int> data, _) =>
                    GradeViewModel.getColor(data.key),
              ),
            ],
          ),
          if (averageGrade != null) ...[
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.localizations.averageGrade,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  averageGrade.averageGrade.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
