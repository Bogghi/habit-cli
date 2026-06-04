import 'package:nocterm/nocterm.dart';

class NavBar extends StatelessComponent {
  final String currentRoute;

  const NavBar({required this.currentRoute, super.key});

  @override
  Component build(BuildContext context) {
    return Container(
      color: const Color.fromRGB(40, 40, 45),
      child: Row(
        children: [
          _tab('[1] Dashboard', '/'),
          _sep(),
          _tab('[2] Log Today', '/log'),
          _sep(),
          _tab('[3] Manage', '/habits'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              '[q] Quit',
              style: TextStyle(color: Colors.gray),
            ),
          ),
        ],
      ),
    );
  }

  Component _tab(String label, String route) {
    final active = route == currentRoute;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.green : Colors.gray,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Component _sep() {
    return Text(' │ ', style: TextStyle(color: Colors.brightBlack));
  }
}
