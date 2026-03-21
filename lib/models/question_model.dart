class QuestionOption {
  final int value; // 1 to 5
  final String text; // option label

  const QuestionOption({required this.value, required this.text});
}

class StressQuestion {
  final int id;
  final String question;
  final List<QuestionOption> options;

  const StressQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}
