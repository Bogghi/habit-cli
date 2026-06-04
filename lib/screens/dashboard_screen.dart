import 'package:nocterm/nocterm.dart';

import '../models/habit_log.dart';
import '../storage/habit_store.dart';
import '../widgets/heatmap_grid.dart';
import '../widgets/nav_bar.dart';

class DashboardScreen extends StatelessComponent {
  final HabitStore store;

  const DashboardScreen({required this.store, super.key});

  @override
  Component build(BuildContext context) {
    if (store.habits.isEmpty) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'No habits yet. Press [3] to add some!',
                style: TextStyle(color: Colors.gray),
              ),
            ),
          ),
          const NavBar(currentRoute: '/'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: const Color.fromRGB(40, 40, 45),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'Habit Heatmaps',
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'All Habits',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              HeatmapGrid(
                colorForDate: (date) {
                  if (date == null) return heatmapEmpty;
                  return summaryColor(store.summaryFraction(formatDate(date)));
                },
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            keyboardScrollable: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final habit in store.habits) ...[
                    Text(
                      habit.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    HeatmapGrid(
                      colorForDate: (date) {
                        if (date == null) return heatmapEmpty;
                        return habitColor(
                          store.isCompleted(habit.id, formatDate(date)),
                        );
                      },
                    ),
                    const SizedBox(height: 1),
                  ],
                ],
              ),
            ),
          ),
        ),
        const NavBar(currentRoute: '/'),
      ],
    );
  }
}
