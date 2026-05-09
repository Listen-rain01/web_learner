import 'package:flutter/material.dart';

class MobileExamPage extends StatelessWidget {
  const MobileExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Exam')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '手机考试模块占位，后续承接 exam_core 的通用答题与提交流程。',
            ),
          ),
        ),
      ),
    );
  }
}
