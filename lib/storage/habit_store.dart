import '../models/habit.dart';
import '../models/habit_log.dart';
import 'storage_service.dart';

class HabitStore {
  final StorageService _storage;
  final List<Habit> habits;
  final List<HabitLog> logs;

  HabitStore({
    required StorageService storage,
    required this.habits,
    required this.logs,
  }) : _storage = storage;

  static Future<HabitStore> load(StorageService storage) async {
    final data = await storage.load();
    return HabitStore(
      storage: storage,
      habits: (data['habits'] as List)
          .map((e) => Habit.fromJson(e as Map<String, dynamic>))
          .toList(),
      logs: (data['logs'] as List)
          .map((e) => HabitLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> _persist() => _storage.save({
        'habits': habits.map((h) => h.toJson()).toList(),
        'logs': logs.map((l) => l.toJson()).toList(),
      });

  Future<void> addHabit(String name) async {
    habits.add(Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    ));
    await _persist();
  }

  Future<void> deleteHabit(String id) async {
    habits.removeWhere((h) => h.id == id);
    logs.removeWhere((l) => l.habitId == id);
    await _persist();
  }

  Future<void> toggleLog(String habitId, String date) async {
    final idx = logs.indexWhere(
      (l) => l.habitId == habitId && l.date == date,
    );
    if (idx >= 0) {
      logs[idx] = logs[idx].copyWith(completed: !logs[idx].completed);
    } else {
      logs.add(HabitLog(habitId: habitId, date: date, completed: true));
    }
    await _persist();
  }

  bool isCompleted(String habitId, String date) =>
      logs.any((l) => l.habitId == habitId && l.date == date && l.completed);

  double summaryFraction(String date) {
    if (habits.isEmpty) return 0.0;
    final done = habits.where((h) => isCompleted(h.id, date)).length;
    return done / habits.length;
  }
}
