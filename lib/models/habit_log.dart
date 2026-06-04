class HabitLog {
  final String habitId;
  final String date; // ISO "2026-06-04"
  final bool completed;

  const HabitLog({
    required this.habitId,
    required this.date,
    required this.completed,
  });

  HabitLog copyWith({bool? completed}) => HabitLog(
        habitId: habitId,
        date: date,
        completed: completed ?? this.completed,
      );

  factory HabitLog.fromJson(Map<String, dynamic> json) => HabitLog(
        habitId: json['habitId'] as String,
        date: json['date'] as String,
        completed: json['completed'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'date': date,
        'completed': completed,
      };
}

String formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
