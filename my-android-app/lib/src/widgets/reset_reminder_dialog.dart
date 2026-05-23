import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bike_provider.dart';
import '../models/service_log.dart';
import '../services/service_log_provider.dart';
import '../models/reminder.dart';
import 'brand_button.dart';

class ResetReminderDialog extends StatefulWidget {
  final Reminder reminder;
  final Function(int, DateTime) onReset;

  const ResetReminderDialog({
    super.key,
    required this.reminder,
    required this.onReset,
  });

  @override
  State<ResetReminderDialog> createState() => _ResetReminderDialogState();
}

class _ResetReminderDialogState extends State<ResetReminderDialog> {
  late int _interval = 0;
  DateTime _newDate = DateTime.now();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();

  final List<int> _quickIntervals = [300, 500, 1000, 3000, 5000];

  @override
  void initState() {
    super.initState();
    // Default to a reasonable interval if the current reminder doesn't have a clear "cycle".
    // Since we don't track "cycle length" in the model yet, we'll default to 500 or just start with a sensible value.
    // If the user previously set it, we might want to keep it?
    // For now, let's default to 500 as a standard generic interval.
    _interval = 500;
    _newDate = DateTime.now().add(
      const Duration(days: 180),
    ); // Default 6 months
  }

  @override
  void dispose() {
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() => _interval += 100);
  }

  void _decrement() {
    setState(() {
      if (_interval > 50) _interval -= 50;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _newDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _newDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      elevation: 8,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.handyman_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Maintenance Complete!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great job keeping your bike in shape.\nWhen should this remind you again?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Interval Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'NEXT INTERVAL',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      '$_interval km',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: _increment,
                      icon: const Icon(Icons.add_circle_outline),
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _quickIntervals.map((km) {
                  final isSelected = _interval == km;
                  return ChoiceChip(
                    label: Text('${km}k'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _interval = km);
                    },
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: colorScheme.surface,
                    side: isSelected
                        ? BorderSide.none
                        : BorderSide(color: colorScheme.outlineVariant),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Date Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'NEXT DUE DATE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_newDate.day}/${_newDate.month}/${_newDate.year}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        'Change',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Service Details
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SERVICE DETAILS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Cost',
                        prefixText: '\$',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        hintText: 'e.g. Brand new ceramic pads',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: BrandButton.outline(
                      label: 'Cancel',
                      icon: Icons.close,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BrandButton.primary(
                      label: 'Confirm Reset',
                      icon: Icons.check_circle,
                      onPressed: () {
                        final log = ServiceLog(
                          bikeId: widget.reminder.bikeId,
                          title: widget.reminder.title,
                          date: DateTime.now(),
                          cost: double.tryParse(_costController.text) ?? 0.0,
                          notes: _notesController.text.isNotEmpty
                              ? _notesController.text
                              : null,
                        );
                        context.read<ServiceLogProvider>().addLog(log);

                        widget.onReset(_interval, _newDate);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
