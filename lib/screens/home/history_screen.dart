import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/models.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<StressLogModel> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      final logs = await DataService().getStressLogs();
      if (mounted)
        setState(() {
          _logs = logs;
          _isLoading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getColor(int score) {
    if (score <= 25) return const Color(0xFF22C55E);
    if (score <= 50) return const Color(0xFF3B82F6);
    if (score <= 75) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _getLevel(int score) {
    if (score <= 25) return 'Low';
    if (score <= 50) return 'Moderate';
    if (score <= 75) return 'High';
    return 'Very High';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
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
                        'Stress History',
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
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF2563EB)))
                  : _logs.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history,
                                  size: 64, color: Color(0xFFCBD5E1)),
                              SizedBox(height: 16),
                              Text(
                                'No logs yet',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B)),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Complete a stress check or\nlog your daily data to see history',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadLogs,
                          color: const Color(0xFF2563EB),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: _logs.length,
                            itemBuilder: (_, i) => _buildLogCard(_logs[i]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(StressLogModel log) {
    final color = _getColor(log.stressScore);
    final isAssessment = log.notes == 'Stress Check Assessment';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        log.moodEmoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAssessment ? 'Stress Assessment' : 'Daily Log',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        _formatDate(log.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Stress score badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  '${log.stressScore}% ${_getLevel(log.stressScore)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          // Daily metrics (only for daily logs)
          if (!isAssessment) ...[
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFF1F5F9)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMini(Icons.bedtime_outlined, '${log.sleepHours}h',
                    'Sleep', const Color(0xFF6366F1)),
                _buildMini(Icons.work_outline, '${log.workHours}h', 'Work',
                    const Color(0xFFF59E0B)),
                _buildMini(Icons.phone_android_outlined, '${log.screenTime}h',
                    'Screen', const Color(0xFF8B5CF6)),
                _buildMini(Icons.bolt_outlined, '${log.exerciseMins.round()}m',
                    'Exercise', const Color(0xFF22C55E)),
              ],
            ),
          ],

          // Notes
          if (log.notes.isNotEmpty &&
              log.notes != 'Stress Check Assessment' &&
              log.notes != 'PSS Assessment') ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '"${log.notes}"',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMini(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A))),
        Text(label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
      ],
    );
  }
}
