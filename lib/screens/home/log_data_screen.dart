import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';
import '../../models/models.dart';

class LogDataScreen extends StatefulWidget {
  const LogDataScreen({super.key});

  @override
  State<LogDataScreen> createState() => _LogDataScreenState();
}

class _LogDataScreenState extends State<LogDataScreen> {
  // Slider values
  double _sleepHours = 7.5;
  double _workHours = 8.0;
  double _screenTime = 4.2;
  double _exerciseMins = 45;

  // Mood selection
  String _selectedMood = 'STRESSED';

  // Notes
  final _notesController = TextEditingController();

  //loading state
  bool _isLoading = false;
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() => _isLoading = true);

    try {
      final userId = AuthService().currentUser?.id ?? '';

      // Convert mood string to Mood enum
      Mood moodEnum;
      switch (_selectedMood) {
        case 'HAPPY':
          moodEnum = Mood.happy;
          break;
        case 'NEUTRAL':
          moodEnum = Mood.neutral;
          break;
        case 'STRESSED':
          moodEnum = Mood.stressed;
          break;
        case 'SAD':
          moodEnum = Mood.sad;
          break;
        default:
          moodEnum = Mood.neutral;
      }

      // Create StressLogModel (using our OOP model!)
      final log = StressLogModel(
        id: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
          RegExp(r'[xy]'),
          (c) {
            final r = DateTime.now().microsecondsSinceEpoch % 16;
            final v = c.group(0) == 'x' ? r : (r & 0x3 | 0x8);
            return v.toRadixString(16);
          },
        ),
        createdAt: DateTime.now(),
        userId: userId,
        sleepHours: _sleepHours,
        workHours: _workHours,
        screenTime: _screenTime,
        exerciseMins: _exerciseMins,
        mood: moodEnum,
        stressScore: 0,
        notes: _notesController.text.trim(),
      );

      await DataService().saveStressLog(log);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily data saved successfully!'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                        'Log Daily Data',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'MIND GUARD AI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Step 4: Daily Habits',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '4 of 8',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 4 / 8,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'How was your day?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Accurate logs help our AI predict stress levels more effectively.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Sliders card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _buildSlider(
                            icon: Icons.bedtime_outlined,
                            iconColor: const Color(0xFF6366F1),
                            label: 'Sleep hours',
                            value: _sleepHours,
                            min: 0,
                            max: 12,
                            displayValue:
                                '${_sleepHours.toStringAsFixed(1)} hrs',
                            onChanged: (v) => setState(() => _sleepHours = v),
                          ),
                          const Divider(height: 28, color: Color(0xFFF1F5F9)),
                          _buildSlider(
                            icon: Icons.menu_book_outlined,
                            iconColor: const Color(0xFF2563EB),
                            label: 'Work / Study',
                            value: _workHours,
                            min: 0,
                            max: 16,
                            displayValue:
                                '${_workHours.toStringAsFixed(1)} hrs',
                            onChanged: (v) => setState(() => _workHours = v),
                          ),
                          const Divider(height: 28, color: Color(0xFFF1F5F9)),
                          _buildSlider(
                            icon: Icons.phone_android_outlined,
                            iconColor: const Color(0xFF8B5CF6),
                            label: 'Screen time',
                            value: _screenTime,
                            min: 0,
                            max: 16,
                            displayValue:
                                '${_screenTime.toStringAsFixed(1)} hrs',
                            onChanged: (v) => setState(() => _screenTime = v),
                          ),
                          const Divider(height: 28, color: Color(0xFFF1F5F9)),
                          _buildSlider(
                            icon: Icons.directions_run_outlined,
                            iconColor: const Color(0xFFF59E0B),
                            label: 'Exercise duration',
                            value: _exerciseMins,
                            min: 0,
                            max: 180,
                            displayValue: '${_exerciseMins.round()} min',
                            onChanged: (v) => setState(() => _exerciseMins = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Mood picker
                    const Text(
                      'How are you feeling?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMoodButton('😊', 'HAPPY'),
                        _buildMoodButton('😐', 'NEUTRAL'),
                        _buildMoodButton('😤', 'STRESSED'),
                        _buildMoodButton('😢', 'SAD'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Notes
                    const Text(
                      'Add a note',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: Color(0xFF2563EB), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Save button
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Save Daily Log',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper: Slider row ───────────────────────────────────────

  Widget _buildSlider({
    required IconData icon,
    required Color iconColor,
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF2563EB),
            inactiveTrackColor: const Color(0xFFBFDBFE),
            thumbColor: const Color(0xFF2563EB),
            overlayColor: const Color(0x292563EB),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // ── Helper: Mood button ──────────────────────────────────────

  Widget _buildMoodButton(String emoji, String mood) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              mood,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF94A3B8),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
