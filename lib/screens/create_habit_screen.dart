import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../services/notification_service.dart';

class CreateHabitScreen extends StatefulWidget {
  final Habit? habit;

  const CreateHabitScreen({super.key, this.habit});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late String _frequency;
  late TimeOfDay? _reminderTime;
  late bool _notificationsEnabled;
  late String? _emoji;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit?.title ?? '');
    _frequency = widget.habit?.frequency ?? 'Daily';
    _reminderTime = widget.habit?.reminderTime;
    _notificationsEnabled = widget.habit?.notificationsEnabled ?? true;
    _emoji = widget.habit?.emoji;
    _color = widget.habit?.color ?? const Color(0xFF008080);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    final habit = Habit(
      id: widget.habit?.id ?? const Uuid().v4(),
      title: _titleController.text,
      emoji: _emoji,
      frequency: _frequency,
      startDate: widget.habit?.startDate ?? DateTime.now(),
      reminderTime: _notificationsEnabled ? _reminderTime : null,
      notificationsEnabled: _notificationsEnabled,
      color: _color,
      completedDates: widget.habit?.completedDates ?? [],
    );

    if (widget.habit != null) {
      await context.read<HabitProvider>().updateHabit(habit);
    } else {
      await context.read<HabitProvider>().addHabit(habit);
    }

    if (_notificationsEnabled && _reminderTime != null) {
      await NotificationService().scheduleHabitReminder(
        id: habit.id.hashCode,
        title: habit.title,
        body: 'Time to complete your habit!',
        time: _reminderTime!,
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit != null ? 'Edit Habit' : 'Create Habit'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'Custom', child: Text('Custom')),
              ],
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Reminders'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            if (_notificationsEnabled) ...[
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Reminder Time'),
                subtitle: Text(_reminderTime?.format(context) ?? 'Not set'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _reminderTime = time;
                    });
                  }
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Text(
                widget.habit != null ? 'Update Habit' : 'Create Habit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
