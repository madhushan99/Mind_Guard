import '../models/question_model.dart';

class QuestionBank {
  // Singleton
  static final QuestionBank _instance = QuestionBank._internal();
  factory QuestionBank() => _instance;
  QuestionBank._internal();

  // Standard 5 options used for all questions
  static const List<QuestionOption> _standardOptions = [
    QuestionOption(value: 1, text: 'Never'),
    QuestionOption(value: 2, text: 'Rarely'),
    QuestionOption(value: 3, text: 'Sometimes'),
    QuestionOption(value: 4, text: 'Often'),
    QuestionOption(value: 5, text: 'Always'),
  ];

  // ── 50 Questions Library ─────────────────────────────────────
  // You can replace these with your real 50 questions later

  final List<StressQuestion> _allQuestions = const [
    StressQuestion(
        id: 1,
        question:
            'How often do you feel overwhelmed by your daily responsibilities?',
        options: _standardOptions),
    StressQuestion(
        id: 2,
        question: 'How often do you have trouble falling asleep due to worry?',
        options: _standardOptions),
    StressQuestion(
        id: 3,
        question:
            'How often do you feel nervous or anxious without a clear reason?',
        options: _standardOptions),
    StressQuestion(
        id: 4,
        question:
            'How often do you feel that your workload is too much to handle?',
        options: _standardOptions),
    StressQuestion(
        id: 5,
        question:
            'How often do you feel physically tense or have muscle tightness?',
        options: _standardOptions),
    StressQuestion(
        id: 6,
        question: 'How often do you feel irritable or easily angered?',
        options: _standardOptions),
    StressQuestion(
        id: 7,
        question: 'How often do you feel that you have no time for yourself?',
        options: _standardOptions),
    StressQuestion(
        id: 8,
        question:
            'How often do you feel emotionally drained after a normal day?',
        options: _standardOptions),
    StressQuestion(
        id: 9,
        question: 'How often do you find it hard to concentrate on tasks?',
        options: _standardOptions),
    StressQuestion(
        id: 10,
        question: 'How often do you feel that things are out of your control?',
        options: _standardOptions),
    StressQuestion(
        id: 11,
        question: 'How often do you experience headaches due to stress?',
        options: _standardOptions),
    StressQuestion(
        id: 12,
        question: 'How often do you feel lonely or isolated?',
        options: _standardOptions),
    StressQuestion(
        id: 13,
        question: 'How often do you skip meals because you are too busy?',
        options: _standardOptions),
    StressQuestion(
        id: 14,
        question:
            'How often do you feel that your relationships are suffering?',
        options: _standardOptions),
    StressQuestion(
        id: 15,
        question: 'How often do you feel unmotivated to start tasks?',
        options: _standardOptions),
    StressQuestion(
        id: 16,
        question: 'How often do you worry about your future?',
        options: _standardOptions),
    StressQuestion(
        id: 17,
        question: 'How often do you feel that you disappoint others?',
        options: _standardOptions),
    StressQuestion(
        id: 18,
        question: 'How often do you feel restless or unable to relax?',
        options: _standardOptions),
    StressQuestion(
        id: 19,
        question: 'How often do you feel that your efforts go unnoticed?',
        options: _standardOptions),
    StressQuestion(
        id: 20,
        question: 'How often do you feel rushed or pressed for time?',
        options: _standardOptions),
    StressQuestion(
        id: 21,
        question: 'How often do you feel sadness without a clear reason?',
        options: _standardOptions),
    StressQuestion(
        id: 22,
        question: 'How often do you feel unable to cope with problems?',
        options: _standardOptions),
    StressQuestion(
        id: 23,
        question: 'How often do you forget things due to mental overload?',
        options: _standardOptions),
    StressQuestion(
        id: 24,
        question: 'How often do you feel that your sleep is not refreshing?',
        options: _standardOptions),
    StressQuestion(
        id: 25,
        question: 'How often do you avoid social situations due to stress?',
        options: _standardOptions),
    StressQuestion(
        id: 26,
        question:
            'How often do you feel that you have too many decisions to make?',
        options: _standardOptions),
    StressQuestion(
        id: 27,
        question: 'How often do you experience stomach issues due to stress?',
        options: _standardOptions),
    StressQuestion(
        id: 28,
        question: 'How often do you feel that you are falling behind in life?',
        options: _standardOptions),
    StressQuestion(
        id: 29,
        question: 'How often do you feel hopeless about a situation?',
        options: _standardOptions),
    StressQuestion(
        id: 30,
        question: 'How often do you feel that nobody understands you?',
        options: _standardOptions),
    StressQuestion(
        id: 31,
        question:
            'How often do you feel mentally exhausted by the end of the day?',
        options: _standardOptions),
    StressQuestion(
        id: 32,
        question:
            'How often do you feel that your emotions are out of control?',
        options: _standardOptions),
    StressQuestion(
        id: 33,
        question: 'How often do you feel that you cannot say no to others?',
        options: _standardOptions),
    StressQuestion(
        id: 34,
        question: 'How often do you feel pressure from family or friends?',
        options: _standardOptions),
    StressQuestion(
        id: 35,
        question: 'How often do you feel that you are not good enough?',
        options: _standardOptions),
    StressQuestion(
        id: 36,
        question:
            'How often do you feel that your personal goals are not progressing?',
        options: _standardOptions),
    StressQuestion(
        id: 37,
        question: 'How often do you feel fearful about upcoming events?',
        options: _standardOptions),
    StressQuestion(
        id: 38,
        question: 'How often do you feel that you lack support from others?',
        options: _standardOptions),
    StressQuestion(
        id: 39,
        question:
            'How often do you feel that your health is being affected by stress?',
        options: _standardOptions),
    StressQuestion(
        id: 40,
        question:
            'How often do you feel that small problems become overwhelming?',
        options: _standardOptions),
    StressQuestion(
        id: 41,
        question:
            'How often do you feel that you cannot enjoy things you used to enjoy?',
        options: _standardOptions),
    StressQuestion(
        id: 42,
        question:
            'How often do you feel that your mind does not stop thinking at night?',
        options: _standardOptions),
    StressQuestion(
        id: 43,
        question:
            'How often do you feel that you are carrying the weight of the world?',
        options: _standardOptions),
    StressQuestion(
        id: 44,
        question:
            'How often do you feel that you react too strongly to minor issues?',
        options: _standardOptions),
    StressQuestion(
        id: 45,
        question:
            'How often do you feel that you have lost your sense of humor?',
        options: _standardOptions),
    StressQuestion(
        id: 46,
        question:
            'How often do you feel that your appetite has changed due to stress?',
        options: _standardOptions),
    StressQuestion(
        id: 47,
        question:
            'How often do you feel that you are not living up to your potential?',
        options: _standardOptions),
    StressQuestion(
        id: 48,
        question:
            'How often do you feel that your stress affects those around you?',
        options: _standardOptions),
    StressQuestion(
        id: 49,
        question:
            'How often do you feel that you need a long break from everything?',
        options: _standardOptions),
    StressQuestion(
        id: 50,
        question:
            'How often do you feel that your daily routine drains your energy?',
        options: _standardOptions),
  ];

  // Get 10 random questions from the 50
  List<StressQuestion> getRandomQuestions() {
    final shuffled = List<StressQuestion>.from(_allQuestions)..shuffle();
    return shuffled.take(10).toList();
  }

  // Calculate stress percentage from answers
  // Min score = 10 (all 1s) = 0%
  // Max score = 50 (all 5s) = 100%
  int calculateStressPercentage(List<int> answers) {
    final total = answers.fold(0, (sum, a) => sum + a);
    return ((total - 10) / 40 * 100).round().clamp(0, 100);
  }

  // Get stress level label
  String getStressLevel(int percentage) {
    if (percentage <= 25) return 'Low Stress';
    if (percentage <= 50) return 'Moderate Stress';
    if (percentage <= 75) return 'High Stress';
    return 'Very High Stress';
  }

  // Get emoji based on percentage
  String getEmoji(int percentage) {
    if (percentage <= 25) return '😊';
    if (percentage <= 50) return '😐';
    if (percentage <= 75) return '😟';
    return '😰';
  }

  // Get color hex based on percentage
  String getAdvice(int percentage) {
    if (percentage <= 25) {
      return 'Your stress level is low. You are managing well! Keep up your healthy habits and daily routine.';
    }
    if (percentage <= 50) {
      return 'You have moderate stress. Try taking short breaks, practicing deep breathing, and spending time with people you enjoy.';
    }
    if (percentage <= 75) {
      return 'Your stress level is high. Consider reducing your workload, getting more sleep, and doing physical activity daily.';
    }
    return 'Your stress level is very high. Please talk to someone you trust or a professional. Prioritize rest above everything.';
  }
}
