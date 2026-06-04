import 'dart:io';

import 'package:habit_cli/models/habit.dart';
import 'package:habit_cli/models/habit_log.dart';
import 'package:habit_cli/storage/habit_store.dart';
import 'package:habit_cli/storage/storage_service.dart';
import 'package:habit_cli/widgets/heatmap_grid.dart';
import 'package:test/test.dart';

StorageService _testStorage(String dir) => StorageService(dataDirOverride: dir);

void main() {
  group('HabitStore.summaryFraction', () {
    late StorageService storage;
    late HabitStore store;

    setUp(() async {
      final tmp = await Directory.systemTemp.createTemp('habit_test_');
      storage = _testStorage(tmp.path);
      store = HabitStore(storage: storage, habits: [], logs: []);
    });

    test('returns 0.0 when no habits', () {
      expect(store.summaryFraction('2026-06-04'), 0.0);
    });

    test('returns 0.0 when no completions', () {
      store.habits.add(const Habit(id: '1', name: 'A'));
      expect(store.summaryFraction('2026-06-04'), 0.0);
    });

    test('returns 1.0 when all habits done', () {
      store.habits
        ..add(const Habit(id: '1', name: 'A'))
        ..add(const Habit(id: '2', name: 'B'));
      store.logs
        ..add(const HabitLog(habitId: '1', date: '2026-06-04', completed: true))
        ..add(const HabitLog(habitId: '2', date: '2026-06-04', completed: true));
      expect(store.summaryFraction('2026-06-04'), 1.0);
    });

    test('returns 0.5 when half done', () {
      store.habits
        ..add(const Habit(id: '1', name: 'A'))
        ..add(const Habit(id: '2', name: 'B'));
      store.logs.add(
        const HabitLog(habitId: '1', date: '2026-06-04', completed: true),
      );
      expect(store.summaryFraction('2026-06-04'), 0.5);
    });

    test('completed=false does not count', () {
      store.habits.add(const Habit(id: '1', name: 'A'));
      store.logs.add(
        const HabitLog(habitId: '1', date: '2026-06-04', completed: false),
      );
      expect(store.summaryFraction('2026-06-04'), 0.0);
    });
  });

  group('HabitStore.toggleLog', () {
    late HabitStore store;

    setUp(() async {
      final tmp = await Directory.systemTemp.createTemp('habit_test_');
      final storage = _testStorage(tmp.path);
      store = HabitStore(storage: storage, habits: [], logs: []);
      store.habits.add(const Habit(id: '1', name: 'A'));
    });

    test('creates a completed log on first toggle', () async {
      await store.toggleLog('1', '2026-06-04');
      expect(store.isCompleted('1', '2026-06-04'), isTrue);
    });

    test('flips to false on second toggle', () async {
      await store.toggleLog('1', '2026-06-04');
      await store.toggleLog('1', '2026-06-04');
      expect(store.isCompleted('1', '2026-06-04'), isFalse);
    });

    test('deleting habit removes its logs', () async {
      await store.toggleLog('1', '2026-06-04');
      expect(store.logs, hasLength(1));
      await store.deleteHabit('1');
      expect(store.logs, isEmpty);
      expect(store.habits, isEmpty);
    });
  });

  group('StorageService round-trip', () {
    test('persists and reloads habits and logs', () async {
      final tmp = await Directory.systemTemp.createTemp('habit_storage_test_');
      final storage = _testStorage(tmp.path);

      var store = await HabitStore.load(storage);
      await store.addHabit('Exercise');
      await store.toggleLog(store.habits.first.id, '2026-06-04');

      // Reload from disk
      store = await HabitStore.load(storage);
      expect(store.habits, hasLength(1));
      expect(store.habits.first.name, 'Exercise');
      expect(store.isCompleted(store.habits.first.id, '2026-06-04'), isTrue);
    });
  });

  group('HeatmapGrid date alignment', () {
    DateTime? dateForCell(
      DateTime today,
      int todayWeekday,
      int col,
      int row,
    ) {
      final daysAgo = (51 - col) * 7 + (todayWeekday - row);
      if (daysAgo < 0 || daysAgo > 363) return null;
      return today.subtract(Duration(days: daysAgo));
    }

    test('col=51, row=todayWeekday gives today', () {
      final today = DateTime(2026, 6, 4); // Thursday → weekday=4
      final todayWeekday = today.weekday == 7 ? 0 : today.weekday;
      final result = dateForCell(today, todayWeekday, 51, todayWeekday);
      expect(result, today);
    });

    test('future cells return null', () {
      final today = DateTime(2026, 6, 4);
      final todayWeekday = today.weekday == 7 ? 0 : today.weekday;
      // Rows below today's weekday in the last column are future
      if (todayWeekday < 6) {
        final result = dateForCell(today, todayWeekday, 51, todayWeekday + 1);
        expect(result, isNull);
      }
    });

    test('col=0 row=0 is 363 or fewer days ago', () {
      final today = DateTime(2026, 6, 4);
      final todayWeekday = today.weekday == 7 ? 0 : today.weekday;
      final result = dateForCell(today, todayWeekday, 0, 0);
      if (result != null) {
        final diff = today.difference(result).inDays;
        expect(diff, lessThanOrEqualTo(363));
        expect(diff, greaterThanOrEqualTo(0));
      }
    });
  });

  group('summaryColor', () {
    test('0.0 returns empty color', () {
      expect(summaryColor(0.0), heatmapEmpty);
    });

    test('1.0 returns brightest color', () {
      expect(summaryColor(1.0), heatmapLevel4);
    });

    test('levels increase with fraction', () {
      final l1 = summaryColor(0.1);
      final l2 = summaryColor(0.4);
      final l3 = summaryColor(0.6);
      final l4 = summaryColor(0.9);
      expect({l1, l2, l3, l4}, hasLength(4));
    });
  });
}
