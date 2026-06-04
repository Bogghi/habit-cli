class Habit {
  final String id;
  final String name;

  const Habit({required this.id, required this.name});

  Habit copyWith({String? name}) => Habit(id: id, name: name ?? this.name);

  factory Habit.fromJson(Map<String, dynamic> json) =>
      Habit(id: json['id'] as String, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
