// --- Placeholder for Theme (Create config/theme/app_theme.dart) ---
// You should create a separate file for this (e.g., lib/config/theme/app_theme.dart)
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    // Define other theme properties: appBarTheme, textTheme, etc.
    appBarTheme: const AppBarTheme(
      elevation: 1,
      // backgroundColor: Colors.white, // Or use scheme color
      // foregroundColor: Colors.black87,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // backgroundColor: Colors.white,
      // selectedItemColor: Colors.deepPurple, // Defined by colorScheme.primary usually
      // unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed, // Ensure labels are visible
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 2.0, // 设置全局进度条的粗细
      activeTrackColor: Colors.deepPurple, // 活跃部分颜色
      inactiveTrackColor: Colors.deepPurple.withOpacity(0.3), // 非活跃部分颜色
      thumbColor: Colors.deepPurple, // 滑块颜色
      overlayColor: Colors.deepPurple.withOpacity(0.2), // 滑块外圈颜色
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6.0, // 设置滑块的半径大小
      ),
    ),
  );

  // Optional: Define dark theme
  // static final ThemeData darkTheme = ThemeData(
  //    useMaterial3: true,
  //    brightness: Brightness.dark,
  //    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
  //    // ... other dark theme properties
  // );
}
