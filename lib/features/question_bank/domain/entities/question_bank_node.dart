enum QuestionBankNodeType { branch, year, mixed }

class QuestionBankNode {
  const QuestionBankNode({
    required this.label,
    required this.code,
    required this.nodeType,
  });

  final String label;
  final String code;
  final QuestionBankNodeType nodeType;
}
