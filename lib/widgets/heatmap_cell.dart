import 'package:nocterm/nocterm.dart';

class HeatmapCell extends StatelessComponent {
  final Color color;

  const HeatmapCell({required this.color, super.key});

  @override
  Component build(BuildContext context) {
    return Container(width: 2, height: 1, color: color);
  }
}
