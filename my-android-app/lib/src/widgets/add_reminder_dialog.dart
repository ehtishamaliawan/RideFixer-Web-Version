import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../services/reminder_provider.dart';
import '../services/bike_provider.dart';
import 'brand_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class AddReminderDialog extends StatefulWidget {
  final Reminder? reminder;
  final int? initialBikeId;
  const AddReminderDialog({super.key, this.reminder, this.initialBikeId});

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _distanceController = TextEditingController();
  int? _selectedBikeId;
  DateTime? _selectedDate;
  String? _selectedImageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _titleController.text = widget.reminder!.title;
      _distanceController.text = widget.reminder!.dueDistance.toString();
      _selectedBikeId = widget.reminder!.bikeId;
      _selectedDate = widget.reminder!.dueDate;
      _selectedImageBase64 = widget.reminder!.imagePath;
    } else if (widget.initialBikeId != null) {
      _selectedBikeId = widget.initialBikeId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate() && _selectedBikeId != null) {
      final reminderProvider = context.read<ReminderProvider>();
      final normalizedTitle = _titleController.text.trim();

      final isDuplicate = reminderProvider.hasDuplicateTitle(
        bikeId: _selectedBikeId!,
        title: normalizedTitle,
        excludeId: widget.reminder?.id,
      );

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'A part named "$normalizedTitle" already exists for this bike.',
            ),
          ),
        );
        return;
      }

      final reminder = Reminder(
        id: widget.reminder?.id, // Preserve ID if editing
        bikeId: _selectedBikeId!,
        title: normalizedTitle,
        dueDistance: double.tryParse(_distanceController.text) ?? 0.0,
        dueDate: _selectedDate,
        imagePath: _selectedImageBase64,
        isCompleted: widget.reminder?.isCompleted ?? false,
      );

      if (widget.reminder != null) {
        reminderProvider.updateReminder(reminder);
      } else {
        reminderProvider.addReminder(reminder);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bikes = context.watch<BikeProvider>().bikes;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: _selectedImageBase64 == null
                          ? const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFFF48FB1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: _selectedImageBase64 != null
                          ? DecorationImage(
                              image: MemoryImage(
                                base64Decode(_selectedImageBase64!),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImageBase64 == null
                        ? const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 40,
                          )
                        : null,
                  ),
                ),
                Text(
                  widget.reminder != null ? 'Edit Reminder' : 'Add Reminder',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap circle to upload part photo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 32),

                if (bikes.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please add a bike first.',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  DropdownButtonFormField<int>(
                    value: _selectedBikeId,
                    decoration: InputDecoration(
                      labelText: 'Select Bike',
                      prefixIcon: const Icon(
                        Icons.pedal_bike,
                        color: Color(0xFF6C63FF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF6C63FF),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    items: bikes.map((bike) {
                      return DropdownMenuItem(
                        value: bike.id,
                        child: Text(
                          bike.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBikeId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a bike' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g., Chain Lubrication',
                      prefixIcon: const Icon(
                        Icons.title,
                        color: Color(0xFF6C63FF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF6C63FF),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Due Distance (km)',
                      hintText: '500',
                      prefixIcon: const Icon(
                        Icons.speed,
                        color: Color(0xFF6C63FF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF6C63FF),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter distance'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due Date (Optional)',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedDate == null
                                      ? 'Tap to select date'
                                      : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedDate != null)
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: 20,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDate = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

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
                        label: widget.reminder != null
                            ? 'Save Changes'
                            : 'Add Reminder',
                        icon: Icons.save_rounded,
                        onPressed: bikes.isEmpty ? null : _saveReminder,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
