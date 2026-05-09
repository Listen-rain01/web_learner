import 'package:flutter/material.dart';

class MockExamPage extends StatelessWidget {
  const MockExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Exam')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '模拟考试模块占位，后续承接组卷、计时、提交与成绩回显流程。',
            ),
          ),
        ),
      ),
    );
  }
}
