import 'dart:async';

import 'package:nocterm/nocterm.dart';

import '../storage/habit_store.dart';
import '../widgets/nav_bar.dart';

class ManageHabitsScreen extends StatefulComponent {
  final HabitStore store;

  const ManageHabitsScreen({required this.store, super.key});

  @override
  State<ManageHabitsScreen> createState() => _ManageHabitsScreenState();
}

class _ManageHabitsScreenState extends State<ManageHabitsScreen> {
  int _focusedIndex = 0;
  bool _addingNew = false;
  final _controller = TextEditingController();

  HabitStore get _store => component.store;

  void _moveFocus(int delta) {
    if (_store.habits.isEmpty) return;
    setState(() {
      _focusedIndex =
          (_focusedIndex + delta).clamp(0, _store.habits.length - 1);
    });
  }

  Future<void> _deleteSelected() async {
    if (_store.habits.isEmpty) return;
    final id = _store.habits[_focusedIndex].id;
    await _store.deleteHabit(id);
    if (mounted) {
      setState(() {
        _focusedIndex = _focusedIndex.clamp(0, _store.habits.length - 1);
      });
    }
  }

  Future<void> _submitNew(String name) async {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) {
      await _store.addHabit(trimmed);
    }
    _controller.clear();
    if (mounted) {
      setState(() {
        _addingNew = false;
        _focusedIndex = (_store.habits.length - 1).clamp(0, 9999);
      });
    }
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: !_addingNew,
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
        if (key == LogicalKey.keyD && _store.habits.isNotEmpty) {
          unawaited(_deleteSelected());
          return true;
        }
        if (key == LogicalKey.keyN || key == LogicalKey.enter) {
          setState(() => _addingNew = true);
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
                'Manage Habits',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _store.habits.isEmpty
                  ? Text(
                      'No habits yet. Press [n] to add one.',
                      style: TextStyle(color: Colors.gray),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < _store.habits.length; i++)
                          _HabitListRow(
                            name: _store.habits[i].name,
                            focused: !_addingNew && i == _focusedIndex,
                          ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _addingNew
                ? Row(
                    children: [
                      Text(
                        'New habit: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focused: true,
                          placeholder: 'e.g. Exercise',
                          onSubmitted: _submitNew,
                          onKeyEvent: (event) {
                            if (event.logicalKey == LogicalKey.escape) {
                              _controller.clear();
                              setState(() => _addingNew = false);
                              return true;
                            }
                            return false;
                          },
                        ),
                      ),
                    ],
                  )
                : Text(
                    'j/k or ↑↓ navigate   [n] add   ${_store.habits.isNotEmpty ? '[d] delete' : ''}',
                    style: TextStyle(color: Colors.gray),
                  ),
          ),
          const SizedBox(height: 1),
          const NavBar(currentRoute: '/habits'),
        ],
      ),
    );
  }
}

class _HabitListRow extends StatelessComponent {
  final String name;
  final bool focused;

  const _HabitListRow({required this.name, required this.focused});

  @override
  Component build(BuildContext context) {
    return Container(
      color: focused ? const Color.fromRGB(50, 50, 60) : null,
      child: Row(
        children: [
          Text(
            focused ? '> ' : '  ',
            style: TextStyle(color: Colors.green),
          ),
          Expanded(child: Text(name)),
          if (focused)
            Text(
              ' [d] delete',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
