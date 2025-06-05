# Habit Ease

A clean and minimal daily habit tracker app built with Flutter.

## Description

**Habit Ease** helps you build better habits, track your progress, and stay motivated with streaks, reminders, and beautiful visual stats. Designed for simplicity and clarity, Habit Ease is your companion for daily self-improvement.

## Features

- **Onboarding**: Motivational screens with illustrations to get you started.
- **Dashboard**: See today's habits, mark them as complete, and view your current streaks.
- **Streak Tracking**: Inline streak display and automatic reset each day.
- **Reminders**: Set daily notifications for each habit (using `flutter_local_notifications`).
- **Visual Stats**: Weekly and monthly progress with charts (using `fl_chart`).
- **Create/Edit Habits**: Add habits with name, emoji, color, frequency, and reminders.
- **Habit Detail**: Calendar view of completions, stats, and editing options.
- **Settings**: Dark/Light mode, notification toggle, clear all habits, and about info.
- **Local Storage**: All data is stored locally using Hive and Shared Preferences.

## Architecture

- **State Management**: Provider
- **Storage**: Hive (habit data), Shared Preferences (settings)
- **Notifications**: flutter_local_notifications
- **Charts**: fl_chart
- **Folder Structure**:
  - `/models` — Data models (e.g., Habit)
  - `/providers` — State management
  - `/services` — Notifications, etc.
  - `/screens` — UI pages
  - `/themes` — App theming
  - `/assets/images/` — Onboarding illustrations

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone https://github.com/sabiqsabry/habit-tracker.git
   cd habit-tracker/habitease
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the app:**
   ```sh
   flutter run
   ```

## Screenshots

*Add screenshots here after running the app!*

## License

MIT
