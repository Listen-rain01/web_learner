import 'package:web_learner/features/question_bank/domain/entities/question_bank_node.dart';
import 'package:web_learner/features/question_bank/domain/entities/question_bank_step.dart';

class QuestionBankFlowState {
  const QuestionBankFlowState({
    required this.currentStep,
    required this.breadcrumbs,
  });

  final QuestionBankStep currentStep;
  final List<QuestionBankNode> breadcrumbs;
}
