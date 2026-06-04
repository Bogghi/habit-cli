import 'package:nocterm/nocterm.dart';

import 'heatmap_cell.dart';

const Color heatmapEmpty = Color.fromRGB(30, 30, 30);
const Color heatmapLevel1 = Color.fromRGB(14, 68, 41);
const Color heatmapLevel2 = Color.fromRGB(0, 109, 50);
const Color heatmapLevel3 = Color.fromRGB(38, 166, 65);
const Color heatmapLevel4 = Color.fromRGB(57, 211, 83);

Color summaryColor(double fraction) {
  if (fraction == 0) return heatmapEmpty;
  if (fraction <= 0.25) return heatmapLevel1;
  if (fraction <= 0.50) return heatmapLevel2;
  if (fraction <= 0.75) return heatmapLevel3;
  return heatmapLevel4;
}

Color habitColor(bool done) => done ? heatmapLevel4 : heatmapEmpty;

class HeatmapGrid extends StatelessComponent {
  final Color Function(DateTime? date) colorForDate;

  const HeatmapGrid({required this.colorForDate, super.key});

  DateTime? _dateForCell(DateTime today, int todayWeekday, int col, int row) {
    final daysAgo = (51 - col) * 7 + (todayWeekday - row);
    if (daysAgo < 0 || daysAgo > 363) return null;
    return today.subtract(Duration(days: daysAgo));
  }

  @override
  Component build(BuildContext context) {
    final today = DateTime.now();
    // Dart: Mon=1..Sun=7. We want Sun=0..Sat=6.
    final todayWeekday = today.weekday == 7 ? 0 : today.weekday;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int col = 0; col < 52; col++)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int row = 0; row < 7; row++)
                HeatmapCell(
                  color: colorForDate(
                    _dateForCell(today, todayWeekday, col, row),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
