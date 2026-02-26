import 'package:flutter/material.dart';

/// 应用主题配置
///
/// Material 3 使用 colorSchemeSeed 自动生成整套配色方案，
/// 包括 primary、secondary、tertiary、error、surface 等全部色彩。
/// M3 组件会自动使用 colorScheme 中的颜色，无需手动指定。
/// 我们只需自定义形状和尺寸。
class AppTheme {
  AppTheme._();

  /// 种子颜色 — M3 基于此自动生成完整配色
  static const Color _seedColor = Color(0xFF1565C0);

  // ==================== 公共主题配置 ====================

  /// AppBar 主题
  static const AppBarTheme _appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
  );

  /// ElevatedButton 主题
  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  /// OutlinedButton 主题
  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  /// 输入框主题
  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  );

  /// Card 主题
  static CardThemeData get _cardTheme => CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  /// SnackBar 主题
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  /// 创建主题数据
  static ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: brightness,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  // ==================== 亮色主题 ====================
  static ThemeData get light => _buildTheme(Brightness.light);

  // ==================== 暗色主题 ====================
  static ThemeData get dark => _buildTheme(Brightness.dark);
}