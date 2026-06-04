import 'dart:async';

import 'package:nocterm/nocterm.dart';

import '../models/habit_log.dart';
import '../storage/habit_store.dart';
import '../widgets/nav_bar.dart';

class LogTodayScreen extends StatefulComponent {
  final HabitStore store;

  const LogTodayScreen({required this.store, super.key});

  @override
  State<LogTodayScreen> createState() => _LogTodayScreenState();
}

class _LogTodayScreenState extends State<LogTodayScreen> {
  int _focusedIndex = 0;

  String get _today => formatDate(DateTime.now());

  HabitStore get _store => component.store;

  void _moveFocus(int delta) {
    if (_store.habits.isEmpty) return;
    setState(() {
      _focusedIndex =
          (_focusedIndex + delta).clamp(0, _store.habits.length - 1);
    });
  }

  Future<void> _toggle() async {
    if (_store.habits.isEmpty) return;
    final habit = _store.habits[_focusedIndex];
    await _store.toggleLog(habit.id, _today);
    if (mounted) setState(() {});
  }

  @override
  Component build(BuildContext context) {
    final today = _today;

    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        final key = event.logicalKey;
        if (key == LogicalKey.arrowUp || key == LogicalKey.keyK) {
          _moveFocus(-1);
          return true;
        }
        if (key == LogicalKey.arrowDown || key == LogicalKey.keyJ) {
          _moveFocus(1);
          return true;
        }
        if (key == LogicalKey.space || key == LogicalKey.enter) {
          unawaited(_toggle());
          return true;
        }
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromRGB(40, 40, 45),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                'Log Today — $today',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: _store.habits.isEmpty
                ? Center(
                    child: Text(
                      'No habits yet. Press [3] to add some!',
                      style: TextStyle(color: Colors.gray),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < _store.habits.length; i++)
                          _HabitRow(
                            name: _store.habits[i].name,
                            done: _store.isCompleted(
                              _store.habits[i].id,
                              today,
                            ),
                            focused: i == _focusedIndex,
                          ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'j/k or ↑↓ navigate   Space/Enter toggle',
              style: TextStyle(color: Colors.gray),
            ),
          ),
          const NavBar(currentRoute: '/log'),
        ],
      ),
    );
  }
}

class _HabitRow extends StatelessComponent {
  final String name;
  final bool done;
  final bool focused;

  const _HabitRow({
    required this.name,
    required this.done,
    required this.focused,
  });

  @override
  Component build(BuildContext context) {
    return Row(
      children: [
        Text(
          focused ? '> ' : '  ',
          style: TextStyle(color: Colors.green),
        ),
        Text(
          done ? '[x] ' : '[ ] ',
          style: TextStyle(color: done ? Colors.green : Colors.gray),
        ),
        Text(
          name,
          style: focused
              ? TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              : null,
        ),
      ],
    );
  }
}
