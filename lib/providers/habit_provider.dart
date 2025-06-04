import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  late Box<Habit> _habitsBox;
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;
  List<Habit> get todayHabits => _habits
      .where(
        (habit) =>
            habit.frequency == 'Daily' ||
            (habit.frequency == 'Weekly' && DateTime.now().weekday == 1) ||
            (habit.frequency == 'Custom' && habit.completedDates.isNotEmpty),
      )
      .toList();

  HabitProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    _habitsBox = await Hive.openBox<Habit>('habits');
    _loadHabits();
  }

  void _loadHabits() {
    _habits = _habitsBox.values.toList();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
    _loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
    _loadHabits();
  }

  Future<void> deleteHabit(String id) async {
    await _habitsBox.delete(id);
    _loadHabits();
  }

  Future<void> clearAllHabits() async {
    await _habitsBox.clear();
    _loadHabits();
  }

  void toggleHabitCompletion(String id) {
    final habit = _habitsBox.get(id);
    if (habit != null) {
      habit.toggleCompletion();
      _loadHabits();
    }
  }
}
