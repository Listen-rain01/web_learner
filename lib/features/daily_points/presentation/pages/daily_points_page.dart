import 'package:flutter/material.dart';

class DailyPointsPage extends StatelessWidget {
  const DailyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Points')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '每日积分模块占位，后续接入积分任务、流水和首页聚合展示。',
            ),
          ),
        ),
      ),
    );
  }
}
