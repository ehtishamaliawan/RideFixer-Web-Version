import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import '../theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/bike_provider.dart';
import '../services/reminder_provider.dart';
import 'dart:io';

class ScaffoldWithNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();

}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  DateTime? _lastBackHandled;
  DateTime? _firstBackAt;
  Timer? _exitResetTimer;
  bool _awaitingSecondBack = false;

  static const Duration _exitWindow = Duration(seconds: 2);
  // Filters out duplicate callbacks fired for a single physical back press.
  static const Duration _backDebounce = Duration(milliseconds: 120);

  void _resetExitCountdown() {
    _exitResetTimer?.cancel();
    _exitResetTimer = null;
    _firstBackAt = null;
    _awaitingSecondBack = false;
  }

  Future<void> _handleSystemBack() async {
    // Some Android builds (and predictive back) can trigger multiple back
    // callbacks for a single physical press. Debounce to avoid treating one
    // press as "double back".
    final now = DateTime.now();
    final lastHandled = _lastBackHandled;
    if (lastHandled != null && now.difference(lastHandled) <= _backDebounce) {
      return;
    }
    _lastBackHandled = now;

    final router = GoRouter.of(context);
    final currentPath = router.routeInformationProvider.value.uri.path;

    if (router.canPop()) {
      _resetExitCountdown();
      router.pop();
      return;
    }

    // If we're not on the Home root route, go to Home instead of exiting.
    if (currentPath != '/home' || widget.navigationShell.currentIndex != 0) {
      _resetExitCountdown();
      widget.navigationShell.goBranch(0, initialLocation: false);
      router.go('/home');
      return;
    }

    // We're on Home root. Never exit; just show the prompt once per window
    // and consume back presses.
    if (!Platform.isAndroid) return;

    if (!_awaitingSecondBack) {
      _awaitingSecondBack = true;
      _firstBackAt = now;
      _exitResetTimer?.cancel();
      _exitResetTimer = Timer(_exitWindow, _resetExitCountdown);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Second back within the window exits.
    final firstBackAt = _firstBackAt;
    if (firstBackAt != null && now.difference(firstBackAt) <= _exitWindow) {
      _resetExitCountdown();
      SystemNavigator.pop();
      return;
    }

    // Window expired; show the prompt again.
    _resetExitCountdown();
    _awaitingSecondBack = true;
    _firstBackAt = now;
    _exitResetTimer?.cancel();
    _exitResetTimer = Timer(_exitWindow, _resetExitCountdown);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Press back again to exit'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  NavigationDestination _buildNavItem(IconData icon, String label, int index) {
    final selected = widget.navigationShell.currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    return NavigationDestination(
      icon: Icon(icon, color: colorScheme.onSurfaceVariant.withOpacity(0.85)),
      selectedIcon: Icon(icon, color: colorScheme.primary, size: 30),
      label: label,
    );
  }

  void _onTap(BuildContext context, int index) {
    // Any explicit navigation should cancel a pending "double-back to exit".
    _resetExitCountdown();
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleSystemBack();
      },
      child: Scaffold(
        extendBody: true, // Important for floating effect
        body: AppWideRefresh(child: widget.navigationShell),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      colorScheme.surface.withOpacity(0.92),
                      colorScheme.surface.withOpacity(0.70),
                    ]
                  : AppTheme.glassGradient.colors,
            ),
            boxShadow: AppTheme.softShadow,
            border: Border.all(
              color: isDark
                  ? colorScheme.outlineVariant.withOpacity(0.55)
                  : colorScheme.outlineVariant.withOpacity(0.6),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: NavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: (int index) => _onTap(context, index),
              backgroundColor: Colors.transparent, // Let container bg show through
              indicatorColor: colorScheme.primary.withOpacity(0.12),
              height: 70,
              destinations: [
                _buildNavItem(Icons.home_rounded, 'Home', 0),
                _buildNavItem(Icons.directions_bike_rounded, 'Garage', 1),
                _buildNavItem(Icons.electrical_services, 'Errors', 2),
                _buildNavItem(Icons.settings_rounded, 'Settings', 3),
                _buildNavItem(Icons.store_mall_directory_rounded, 'Shops', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _exitResetTimer?.cancel();
    super.dispose();
  }
}

/// App-wide pull-to-refresh handler. Listens for overscroll at the top of any
/// scrollable and triggers provider reloads. Shows a small overlay spinner
/// while refreshing.
class AppWideRefresh extends StatefulWidget {
  final Widget child;
  const AppWideRefresh({required this.child, Key? key}) : super(key: key);

  @override
  State<AppWideRefresh> createState() => _AppWideRefreshState();
}

class _AppWideRefreshState extends State<AppWideRefresh> {
  bool _refreshing = false;
  bool _draggingFromTop = false;
  bool _triggeredThisDrag = false;
  double _pulledDistance = 0;

  static const double _kTriggerPulldown = 140.0;

  Future<void> _doRefresh() async {
    if (!mounted) return;
    setState(() => _refreshing = true);
    try {
      // Load bikes and reminders from providers at app level
      await Future.wait([
        // Use read to avoid rebuild storms
        Future.sync(() => context.read<BikeProvider>().loadBikes()),
        Future.sync(() => context.read<ReminderProvider>().loadReminders()),
      ]);
    } catch (_) {}
    if (!mounted) return;
    setState(() => _refreshing = false);
  }

  void _resetDrag() {
    _draggingFromTop = false;
    _triggeredThisDrag = false;
    _pulledDistance = 0;
  }

  bool _handleScrollNotification(ScrollNotification n) {
    if (_refreshing) return false;

    if (n is ScrollStartNotification) {
      // Only consider real user drags that start at the very top.
      if (n.dragDetails != null && n.metrics.extentBefore == 0) {
        _draggingFromTop = true;
        _triggeredThisDrag = false;
        _pulledDistance = 0;
      } else {
        _resetDrag();
      }
      return false;
    }

    if (n is ScrollEndNotification) {
      _resetDrag();
      return false;
    }

    if (n is UserScrollNotification && n.direction == ScrollDirection.idle) {
      _resetDrag();
      return false;
    }

    if (!_draggingFromTop || _triggeredThisDrag) return false;
    if (n.metrics.extentBefore != 0) return false;

    // Accumulate pull distance while the user drags down from the top.
    // Overscroll sign can vary across platforms/physics, so use abs().
    if (n is OverscrollNotification) {
      _pulledDistance += n.overscroll.abs();
      if (_pulledDistance >= _kTriggerPulldown) {
        _triggeredThisDrag = true;
        _doRefresh();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: widget.child,
        ),
        if (_refreshing)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
