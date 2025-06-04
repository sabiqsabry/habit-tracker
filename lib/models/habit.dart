import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? emoji;

  @HiveField(3)
  String frequency;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  TimeOfDay? reminderTime;

  @HiveField(6)
  List<DateTime> completedDates;

  @HiveField(7)
  bool notificationsEnabled;

  @HiveField(8)
  Color color;

  Habit({
    required this.id,
    required this.title,
    this.emoji,
    required this.frequency,
    required this.startDate,
    this.reminderTime,
    List<DateTime>? completedDates,
    this.notificationsEnabled = true,
    Color? color,
  }) : completedDates = completedDates ?? [],
       color = color ?? const Color(0xFF008080);

  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final today = DateTime.now();
    final sortedDates = completedDates.toList()..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime? lastDate = today;

    for (final date in sortedDates) {
      if (lastDate == null) break;

      final difference = lastDate.difference(date).inDays;
      if (difference == 1) {
        streak++;
        lastDate = date;
      } else if (difference == 0) {
        lastDate = date;
      } else {
        break;
      }
    }

    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = completedDates.toList()..sort();
    int currentStreak = 1;
    int longestStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final difference = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (difference == 1) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak
            ? currentStreak
            : longestStreak;
      } else if (difference > 1) {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  void toggleCompletion() {
    final today = DateTime.now();
    if (isCompletedToday()) {
      completedDates.removeWhere(
        (date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
    } else {
      completedDates.add(today);
    }
    save();
  }
}
