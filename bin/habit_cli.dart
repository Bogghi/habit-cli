import 'package:habit_cli/habit_cli.dart';
import 'package:habit_cli/storage/habit_store.dart';
import 'package:habit_cli/storage/storage_service.dart';
import 'package:nocterm/nocterm.dart';

Future<void> main() async {
  final store = await HabitStore.load(StorageService());
  runApp(HabitApp(store: store));
}
