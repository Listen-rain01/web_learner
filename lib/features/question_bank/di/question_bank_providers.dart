import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/question_bank/domain/entities/question_bank_node.dart';

final questionBankBlueprintProvider = Provider<List<QuestionBankNode>>((ref) {
  return const [
    QuestionBankNode(
      label: 'Unit scope',
      code: 'unit',
      nodeType: QuestionBankNodeType.branch,
    ),
    QuestionBankNode(
      label: 'Top category',
      code: 'top-category',
      nodeType: QuestionBankNodeType.branch,
    ),
    QuestionBankNode(
      label: 'Child node',
      code: 'child-node',
      nodeType: QuestionBankNodeType.mixed,
    ),
    QuestionBankNode(
      label: 'Exam type list',
      code: 'exam-type',
      nodeType: QuestionBankNodeType.branch,
    ),
  ];
});
