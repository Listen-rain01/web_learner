import 'package:flutter/material.dart';

/// 首页（占位，待开发）
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Center(
        child: Text(
          '首页 - 待开发',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

