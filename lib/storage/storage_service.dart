import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

class StorageService {
  /// Optional override for the data directory — used in tests.
  final String? dataDirOverride;

  const StorageService({this.dataDirOverride});

  String get _dataDir {
    if (dataDirOverride != null) return dataDirOverride!;
    final appData = Platform.environment['APPDATA'];
    if (appData != null) return p.join(appData, 'habit_cli');
    final home = Platform.environment['HOME'] ?? '.';
    return p.join(home, '.habit_cli');
  }

  String get _dataPath => p.join(_dataDir, 'data.json');

  Future<Map<String, dynamic>> load() async {
    final file = File(_dataPath);
    if (!await file.exists()) return {'habits': [], 'logs': []};
    final raw = await file.readAsString();
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> save(Map<String, dynamic> data) async {
    final dir = Directory(_dataDir);
    if (!await dir.exists()) await dir.create(recursive: true);
    await File(_dataPath).writeAsString(jsonEncode(data));
  }
}
