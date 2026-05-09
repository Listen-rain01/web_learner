class ExamSession {
  const ExamSession({
    required this.examId,
    required this.title,
    required this.questionCount,
    this.remainingSeconds,
  });

  final String examId;
  final String title;
  final int questionCount;
  final int? remainingSeconds;
}
