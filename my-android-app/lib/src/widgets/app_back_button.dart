import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final String fallbackLocation;
  final VoidCallback? onPressed;
  final Color? color;

  const AppBackButton({
    super.key,
    this.fallbackLocation = '/home',
    this.onPressed,
    this.color,
  });

  void _defaultBack(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onPressed ?? () => _defaultBack(context),
      icon: const BackButtonIcon(),
      color: color,
    );
  }
}
