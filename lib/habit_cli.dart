import 'package:nocterm/nocterm.dart';

import 'screens/dashboard_screen.dart';
import 'screens/log_today_screen.dart';
import 'screens/manage_habits_screen.dart';
import 'storage/habit_store.dart';

class _RouteObserver extends NavigatorObserver {
  String currentRoute = '/';

  @override
  void didPush(Route route, Route? previousRoute) {
    currentRoute = route.settings.name ?? currentRoute;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    currentRoute = newRoute?.settings.name ?? currentRoute;
  }
}

class HabitApp extends StatefulComponent {
  final HabitStore store;

  const HabitApp({required this.store, super.key});

  @override
  State<HabitApp> createState() => _HabitAppState();
}

class _HabitAppState extends State<HabitApp> {
  final _navKey = GlobalKey<NavigatorState>();
  final _routeObserver = _RouteObserver();

  void _navigate(String route) {
    _navKey.currentState?.pushReplacementNamed(route);
  }

  @override
  Component build(BuildContext context) {
    final store = component.store;
    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (key) {
        if (key == LogicalKey.keyQ) {
          shutdownApp();
          return true;
        }
        if (key == LogicalKey.digit1) {
          _navigate('/');
          return true;
        }
        if (key == LogicalKey.digit2) {
          _navigate('/log');
          return true;
        }
        if (key == LogicalKey.digit3) {
          _navigate('/habits');
          return true;
        }
        if (key == LogicalKey.tab) {
          const routes = ['/', '/log', '/habits'];
          final idx = routes.indexOf(_routeObserver.currentRoute);
          _navigate(routes[(idx + 1) % routes.length]);
          return true;
        }
        return false;
      },
      child: NoctermApp(
        title: 'Habit Tracker',
        navigatorKey: _navKey,
        navigatorObservers: [_routeObserver],
        routes: {
          '/': (_) => DashboardScreen(store: store),
          '/log': (_) => LogTodayScreen(store: store),
          '/habits': (_) => ManageHabitsScreen(store: store),
        },
        initialRoute: '/',
      ),
    );
  }
}
