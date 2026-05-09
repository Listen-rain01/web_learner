import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/question_bank_providers.dart';
import '../../domain/entities/question_bank_node.dart';
import '../../domain/entities/question_bank_step.dart';

class QuestionBankPage extends ConsumerWidget {
  const QuestionBankPage({super.key});

  static const routeName = 'question-bank';
  static const routePath = '/question-bank';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blueprint = ref.watch(questionBankBlueprintProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Question Bank')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flow scaffold',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This feature is prepared for the real unit -> category -> child node -> exam type workflow described in your docs. '
                    'The child node layer is modeled as mixed on purpose so it can represent years, middle categories, or both.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Planned steps',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...QuestionBankStep.values.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(_stepTitle(step)),
                  subtitle: Text(_stepSummary(step)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Blueprint nodes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...blueprint.map(
            (node) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(node.label),
                  subtitle: Text(_nodeTypeLabel(node.nodeType)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _stepTitle(QuestionBankStep step) {
    switch (step) {
      case QuestionBankStep.pickUnit:
        return 'Pick unit scope';
      case QuestionBankStep.pickTopCategory:
        return 'Pick top category';
      case QuestionBankStep.pickChildNode:
        return 'Resolve child node';
      case QuestionBankStep.pickExamType:
        return 'Pick exam type';
      case QuestionBankStep.confirmSelection:
        return 'Persist selection';
    }
  }

  static String _stepSummary(QuestionBankStep step) {
    switch (step) {
      case QuestionBankStep.pickUnit:
        return 'Backed by the unit list returned when entering the module.';
      case QuestionBankStep.pickTopCategory:
        return 'Maps to the first-level style/category request.';
      case QuestionBankStep.pickChildNode:
        return 'Supports years, intermediate categories, or a mixed response.';
      case QuestionBankStep.pickExamType:
        return 'Loads the final exam-type list for the current branch.';
      case QuestionBankStep.confirmSelection:
        return 'Saves the selected exam type and refreshes current learning context.';
    }
  }

  static String _nodeTypeLabel(QuestionBankNodeType type) {
    switch (type) {
      case QuestionBankNodeType.branch:
        return 'Branch node';
      case QuestionBankNodeType.year:
        return 'Year node';
      case QuestionBankNodeType.mixed:
        return 'Mixed node';
    }
  }
}
