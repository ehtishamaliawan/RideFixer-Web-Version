import 'package:flutter/material.dart';
import '../screens/add_bike_onboarding.dart';

/// Legacy wrapper kept for compatibility. Use `AddBikeOnboarding` for full-screen flow.
class AddBikeDialog extends StatelessWidget {
  final dynamic initialBike;
  const AddBikeDialog({super.key, this.initialBike});

  @override
  Widget build(BuildContext context) {
    // Immediately open the onboarding flow when this widget is used.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddBikeOnboarding(initialBike: initialBike),
        ),
      );
    });
    return const SizedBox.shrink();
  }
}
