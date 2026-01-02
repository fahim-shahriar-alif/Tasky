import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'views/home_screen.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService.init();
  
  runApp(const TaskyApp());
}

class TaskyApp extends StatefulWidget {
  const TaskyApp({super.key});

  @override
  State<TaskyApp> createState() => _TaskyAppState();
}

class _TaskyAppState extends State<TaskyApp> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
        ChangeNotifierProvider(create: (_) => HabitProvider()..loadHabits()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Tasky - Task Manager & Habit Tracker',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: _isInitialized 
                ? const HomeScreen()
                : SplashScreen(
                    onInitializationComplete: () {
                      setState(() {
                        _isInitialized = true;
                      });
                    },
                  ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}