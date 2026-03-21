import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../services/question_bank.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';
import '../../models/models.dart';

class StressCheckScreen extends StatefulWidget {
  const StressCheckScreen({super.key});

  @override
  State<StressCheckScreen> createState() => _StressCheckScreenState();
}

class _StressCheckScreenState extends State<StressCheckScreen> {
  final _bank = QuestionBank();

  late List<StressQuestion> _questions;
  late List<int> _answers; // -1 = not answered

  bool _showResult = false;
  int _stressPercentage = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pick 10 random questions from the 50
    _questions = _bank.getRandomQuestions();
    _answers = List.filled(10, -1);
  }

  int get _answeredCount => _answers.where((a) => a != -1).length;

  void _handleSubmit() async {
    if (_answers.contains(-1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all 10 questions'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Calculate stress percentage using probability method
    final percentage = _bank.calculateStressPercentage(_answers);

    // Save to Supabase
    setState(() => _isSaving = true);
    try {
      final userId = AuthService().currentUser?.id ?? '';
      final log = StressLogModel(
        id: '',
        createdAt: DateTime.now(),
        userId: userId,
        sleepHours: 0,
        workHours: 0,
        screenTime: 0,
        exerciseMins: 0,
        mood: Mood.neutral,
        stressScore: percentage,
        notes: 'Stress Check Assessment',
      );
      await DataService().saveStressLog(log);
    } catch (_) {
      // Still show result even if save fails
    }

    setState(() {
      _stressPercentage = percentage;
      _showResult = true;
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF0F4F8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Stress Check',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: _showResult ? _buildResultView() : _buildQuestionView(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Question View ────────────────────────────────────────────

  Widget _buildQuestionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Questions answered',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '$_answeredCount / 10',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _answeredCount / 10,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Info badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '10 random questions selected from our 50-question library. Answer honestly for accurate results.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2563EB),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Questions
          ...List.generate(10, (i) => _buildQuestion(i)),

          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Text(
                      'Submit & See Results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Your answers are private and encrypted.',
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuestion(int index) {
    final question = _questions[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _answers[index] != -1
              ? const Color(0xFF2563EB).withOpacity(0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number + text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _answers[index] != -1
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _answers[index] != -1
                          ? Colors.white
                          : const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0F172A),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Answer options
          ...List.generate(5, (optIndex) {
            final option = question.options[optIndex];
            final selected = _answers[index] == option.value;

            return GestureDetector(
              onTap: () {
                setState(() => _answers[index] = option.value);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white,
                        border: Border.all(
                          color:
                              selected ? Colors.white : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: selected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 12)
                          : Center(
                              child: Text(
                                '${option.value}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      option.text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                        color:
                            selected ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Result View ──────────────────────────────────────────────

  Widget _buildResultView() {
    final level = _bank.getStressLevel(_stressPercentage);
    final emoji = _bank.getEmoji(_stressPercentage);
    final advice = _bank.getAdvice(_stressPercentage);

    Color color;
    if (_stressPercentage <= 25)
      color = const Color(0xFF22C55E);
    else if (_stressPercentage <= 50)
      color = const Color(0xFF3B82F6);
    else if (_stressPercentage <= 75)
      color = const Color(0xFFF59E0B);
    else
      color = const Color(0xFFEF4444);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Score circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 4),
                Text(
                  '$_stressPercentage%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            level,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 6),

          // How it was calculated
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Based on 10 random questions from 50-question library',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Advice card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: color, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'What this means',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  advice,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Score breakdown card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How your score is calculated',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),
                _buildScoreRow('Questions answered', '10 of 50'),
                _buildScoreRow('Your total score',
                    '${_answers.fold(0, (s, a) => s + (a == -1 ? 0 : a))} / 50'),
                _buildScoreRow('Stress percentage', '$_stressPercentage%'),
                _buildScoreRow('Level', level),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tips
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick tips for you',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTip(Icons.air, 'Practice deep breathing for 5 minutes'),
                _buildTip(
                    Icons.directions_walk, 'Take a 10 minute walk outside'),
                _buildTip(Icons.bedtime, 'Sleep 7 to 9 hours tonight'),
                _buildTip(
                    Icons.people_outline, 'Talk to a friend or family member'),
                _buildTip(Icons.phone_android, 'Reduce screen time before bed'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Try again button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _questions = _bank.getRandomQuestions();
                  _answers = List.filled(10, -1);
                  _showResult = false;
                });
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: Color(0xFF2563EB)),
              ),
              child: const Text(
                'Try Again with New Questions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Back button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Back to Dashboard',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          Text(value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              )),
        ],
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A))),
          ),
        ],
      ),
    );
  }
}
