import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../services/bike_provider.dart';
import '../services/reminder_provider.dart';
import '../models/bike.dart';
import '../models/reminder.dart';
import '../config/parts_config.dart';

class AddBikeOnboarding extends StatefulWidget {
  final Bike? initialBike;
  const AddBikeOnboarding({super.key, this.initialBike});

  @override
  State<AddBikeOnboarding> createState() => _AddBikeOnboardingState();
}

class _AddBikeOnboardingState extends State<AddBikeOnboarding> {
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _imageBase64;
  String _selectedType = 'E-Bike';
  final PageController _pageController = PageController();
  int _page = 0;
  // animation duration for controls
  static const _kAnimDuration = Duration(milliseconds: 360);

  List<Map<String, dynamic>> _previewParts = [];
  final Map<String, bool> _previewSelected = {};

  bool get isEditing => widget.initialBike != null;
  int get _baseMileage => isEditing ? widget.initialBike!.totalDistance.round() : 0;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final b = widget.initialBike!;
      _nameController.text = b.name;
      _imageBase64 = b.imagePath;
      _selectedType = b.type;
    }
    // keep UI reactive to name changes for validation
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
    _recomputePreview();
  }
  bool get _hasName => _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? f = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (f != null) {
      final bytes = await f.readAsBytes();
      setState(() => _imageBase64 = base64Encode(bytes));
    }
  }

  void _recomputePreview() {
    final mileage = _baseMileage;
    final parts = partsConfig[_selectedType] ?? partsConfig['Bike']!;
    _previewParts = parts.map((p) {
      final delta = (p['distance'] is num)
          ? (p['distance'] as num).toDouble()
          : 0.0;
      final months = (p['months'] is int)
          ? p['months'] as int
          : (p['months'] is num ? (p['months'] as num).toInt() : 0);
      return {
        'title': p['title'] as String,
        'dueDistance': mileage + delta,
        'dueDate': months > 0
            ? DateTime.now().add(Duration(days: months * 30))
            : null,
      };
    }).toList();
    for (final p in _previewParts) {
      _previewSelected.putIfAbsent(p['title'] as String, () => true);
    }
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final mileage = _baseMileage;
    final provider = Provider.of<BikeProvider>(context, listen: false);
    final reminderProvider = Provider.of<ReminderProvider>(
      context,
      listen: false,
    );

    if (isEditing) {
      final original = widget.initialBike!;
      final updated = original.copyWith(
        name: name,
        imagePath: _imageBase64,
        type: _selectedType,
      );
      await provider.updateBike(updated);
    } else {
      final newBike = Bike(
        name: name,
        type: _selectedType,
        totalDistance: 0.0,
        imagePath: _imageBase64,
      );
      final bikeId = await provider.addBike(newBike);
      final now = DateTime.now();
      final parts = partsConfig[_selectedType] ?? partsConfig['Bike']!;
      for (final p in parts) {
        final title = p['title'] as String;
        if (_previewSelected.containsKey(title) && !_previewSelected[title]!) {
          continue;
        }
        final double delta = (p['distance'] is num)
            ? (p['distance'] as num).toDouble()
            : 0.0;
        final int months = (p['months'] is int)
            ? p['months'] as int
            : (p['months'] is num ? (p['months'] as num).toInt() : 0);
        final dueDate = months > 0
            ? now.add(Duration(days: months * 30))
            : null;
        await reminderProvider.addReminder(
          Reminder(
            bikeId: bikeId,
            title: title,
            dueDistance: mileage + delta,
            dueDate: dueDate,
          ),
        );
      }
    }

    if (mounted) Navigator.of(context).pop();
  }

  void _next() {
    if (_page < 3) {
      _page++;
      _pageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }

  void _back() {
    if (_page > 0) {
      _page--;
      _pageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isEditing ? 'Edit Bike' : 'Add Bike'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.primary.withOpacity(0.06), colorScheme.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top progress / header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, _) {
                          final val = (_pageController.hasClients && _pageController.page != null)
                              ? (_pageController.page!.clamp(0.0, 3.0))
                              : _page.toDouble();
                          return Row(
                            children: List.generate(4, (i) {
                              final active = (val.round() == i);
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: active ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${_page + 1}/4', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                  // Step 1: Name & Photo (styled card)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Material(
                          elevation: isDark ? 0 : 6,
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: _kAnimDuration,
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: colorScheme.surface,
                              border: Border.all(color: colorScheme.outlineVariant),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name & Photo',
                                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Bike name',
                                      filled: true,
                                      fillColor: colorScheme.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      prefixIcon: const Icon(Icons.pedal_bike),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Add a photo (optional)', style: theme.textTheme.bodyLarge),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: 160,
                                        width: double.infinity,
                                        color: colorScheme.surfaceVariant,
                                        child: _imageBase64 == null
                                            ? Center(
                                                child: Icon(Icons.camera_alt, size: 44, color: colorScheme.onSurface.withOpacity(0.6)),
                                              )
                                            : Image.memory(base64Decode(_imageBase64!), fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Step 2: Type (card)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                          child: Material(
                          elevation: isDark ? 0 : 6,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: colorScheme.surface,
                              border: Border.all(color: colorScheme.outlineVariant),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bike type',
                                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    value: _selectedType,
                                    items: const [
                                      DropdownMenuItem(value: 'Bike', child: Text('Bike / Cycle')),
                                      DropdownMenuItem(value: 'E-Bike', child: Text('E-Bike')),
                                    ],
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() => _selectedType = v);
                                        _recomputePreview();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colorScheme.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  // Short hint about reminders; avoid mentioning editable mileage.
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.build_circle_outlined, color: colorScheme.primary),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'We’ll set up maintenance reminders tailored to this vehicle type.',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: colorScheme.onSurface.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Step 3: Preview Reminders (carded list with status)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: Material(
                            elevation: isDark ? 0 : 6,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: colorScheme.surface,
                                border: Border.all(color: colorScheme.outlineVariant),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Preview reminders',
                                      style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _previewParts.length,
                                    separatorBuilder: (context, index) => const Divider(height: 1),
                                    itemBuilder: (context, i) {
                                      final p = _previewParts[i];
                                      final title = p['title'] as String;
                                      final dueDate = p['dueDate'] as DateTime?;
                                      final dueDistance = ((p['dueDistance'] ?? 0) as num).round();
                                      Color statusColor = Colors.grey;
                                      String dueText = '';
                                      if (dueDate != null) {
                                        final days = dueDate.difference(DateTime.now()).inDays;
                                        if (days <= 3) {
                                          statusColor = Colors.red;
                                        } else if (days <= 14) {
                                          statusColor = Colors.orange;
                                        } else {
                                          statusColor = Colors.green;
                                        }
                                        dueText = dueDate.toLocal().toString().split(' ').first;
                                      } else {
                                        dueText = '$dueDistance km';
                                      }

                                      return CheckboxListTile(
                                        value: _previewSelected[title] ?? true,
                                        onChanged: (v) => setState(() => _previewSelected[title] = v ?? false),
                                        title: Text(title, style: theme.textTheme.bodyLarge),
                                        subtitle: Row(
                                          children: dueDate != null
                                              ? [
                                                  Icon(Icons.calendar_today, size: 14, color: statusColor),
                                                  const SizedBox(width: 6),
                                                  Text(dueText, style: TextStyle(color: statusColor)),
                                                  const SizedBox(width: 12),
                                                  Text('• $dueDistance km'),
                                                ]
                                              : [
                                                  Icon(Icons.directions_bike, size: 14, color: colorScheme.onSurface.withOpacity(0.6)),
                                                  const SizedBox(width: 6),
                                                  Text('$dueDistance km'),
                                                ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Step 4: Confirm
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Material(
                          elevation: isDark ? 0 : 6,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: colorScheme.surface,
                              border: Border.all(color: colorScheme.outlineVariant),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Confirm', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  ListTile(
                                    leading: const Icon(Icons.pedal_bike),
                                    title: const Text('Name'),
                                    subtitle: Text(_nameController.text.trim()),
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.category),
                                    title: const Text('Type'),
                                    subtitle: Text(_selectedType),
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  if (isEditing)
                                    ListTile(
                                      leading: const Icon(Icons.speed),
                                      title: const Text('Mileage'),
                                      subtitle: Text('$_baseMileage km'),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _back,
                          icon: const BackButtonIcon(),
                          label: const Text('Back'),
                        ),
                      ),
                      const Spacer(),
                      AnimatedSwitcher(
                        duration: _kAnimDuration,
                        child: _page == 3
                            ? SizedBox(
                                key: const ValueKey('create'),
                                height: 48,
                                child: FilledButton.icon(
                                  onPressed: _submit,
                                  icon: const Icon(Icons.check),
                                  label: Text(isEditing ? 'Save' : 'Create'),
                                ),
                              )
                            : SizedBox(
                                key: const ValueKey('next'),
                                height: 48,
                                child: FilledButton(
                                  onPressed: (_page == 0 && !_hasName) ? null : _next,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text('Next'),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
