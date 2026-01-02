# Tasky - Task Manager & Habit Tracker

A personal task management and habit tracking app built with Flutter.

## Features

### 📋 Task Management
- **Daily Tasks**: View and manage today's tasks
- **Priority Levels**: High, Medium, Low priority with color coding
- **Progress Tracking**: Visual progress indicator for daily completion
- **Task Operations**: Add, edit, delete, and mark tasks as complete

### 🎯 Habit Tracking
- **Date-wise Tracking**: Navigate through dates to track habits
- **Habit Streaks**: Visual streak counter for motivation
- **Completion Status**: Mark habits as complete for specific dates
- **Habit Management**: Add and delete habits with descriptions

### 🎨 UI/UX
- **Material 3 Design**: Modern, clean interface
- **Dark/Light Mode**: Toggle between themes
- **Responsive Layout**: Optimized for mobile devices
- **Intuitive Navigation**: Tab-based interface for easy switching

### 💾 Data Persistence
- **Local Storage**: Uses Hive for fast, local data storage
- **No Cloud Dependency**: All data stays on your device
- **Reliable**: Data persists between app sessions

## Technical Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: Provider
- **Local Storage**: Hive
- **Icons**: Lucide Icons
- **Architecture**: Clean folder structure with separation of concerns

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── task.dart            # Task model with Hive annotations
│   └── habit.dart           # Habit and HabitLog models
├── providers/               # State management
│   ├── task_provider.dart   # Task state management
│   ├── habit_provider.dart  # Habit state management
│   └── theme_provider.dart  # Theme state management
├── services/                # Business logic
│   └── storage_service.dart # Hive database operations
├── views/                   # Screen widgets
│   ├── home_screen.dart     # Main app screen with tabs
│   ├── tasks_tab.dart       # Tasks tab content
│   └── habits_tab.dart      # Habits tab content
└── widgets/                 # Reusable UI components
    ├── task_card.dart       # Individual task display
    ├── habit_card.dart      # Individual habit display
    ├── date_picker_row.dart # Horizontal date picker
    ├── add_task_dialog.dart # Task creation/editing dialog
    └── add_habit_dialog.dart # Habit creation dialog
```

## Getting Started

1. **Prerequisites**: Ensure Flutter 3.7.2+ is installed
2. **Dependencies**: Run `flutter pub get`
3. **Code Generation**: Run `flutter packages pub run build_runner build`
4. **Launch**: Run `flutter run`

## Key Features Implementation

### Task Management
- Tasks are created with title, priority, and automatic timestamp
- Today's tasks are filtered and sorted by priority
- Progress tracking shows completion percentage
- Tasks can be edited, deleted, or marked complete

### Habit Tracking
- Habits can be created with name and optional description
- Date picker allows navigation through different dates
- Habit completion is tracked per date with HabitLog entries
- Streak calculation motivates consistent habit building

### Data Persistence
- Hive provides fast, local NoSQL database
- Type-safe with generated adapters
- Automatic data serialization/deserialization
- Efficient storage with minimal overhead

### Theme Support
- Material 3 design system
- Dynamic color schemes for light/dark modes
- Persistent theme preference storage
- Smooth theme transitions

This app is designed for personal productivity, focusing on simplicity and effectiveness in managing daily tasks and building positive habits.
