import 'package:flutter_test/flutter_test.dart';
import 'package:web_learner/features/question_bank/domain/entities/question_bank_node.dart';

void main() {
  group('QuestionBankNode', () {
    test('supports mixed child nodes for real API hierarchies', () {
      const node = QuestionBankNode(
        label: 'Child layer',
        code: 'child',
        nodeType: QuestionBankNodeType.mixed,
      );

      expect(node.label, 'Child layer');
      expect(node.code, 'child');
      expect(node.nodeType, QuestionBankNodeType.mixed);
    });
  });
}
