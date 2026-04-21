import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/data_service.dart';

class ScreenTimeTrackerScreen extends StatefulWidget {
  const ScreenTimeTrackerScreen({super.key});

  @override
  State<ScreenTimeTrackerScreen> createState() =>
      _ScreenTimeTrackerScreenState();
}

class _ScreenTimeTrackerScreenState extends State<ScreenTimeTrackerScreen> {
  int _screenMinutes = 0;
  bool _isLoading = true;

  List<int> _weeklyMinutes = List.filled(7, 0);
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _loadScreenTimeData();
  }

  Future<void> _loadScreenTimeData() async {
    try {
      final todayLog = await DataService().getTodayScreenTimeLog();
      final weekly = await DataService().getWeeklyScreenTimeMinutes();

      if (mounted) {
        setState(() {
          _screenMinutes = todayLog != null
              ? (todayLog.screenTime * 60).round()
              : 0;
          _weeklyMinutes = weekly;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  String _getStatus(int minutes) {
    final hours = minutes / 60.0;
    if (hours <= 2) return 'Best';
    if (hours <= 4) return 'Good';
    if (hours <= 6) return 'Moderate';
    return 'High';
  }

  Color _getStatusColor(int minutes) {
    final hours = minutes / 60.0;
    if (hours <= 2) return const Color(0xFF22C55E);
    if (hours <= 4) return const Color(0xFF3B82F6);
    if (hours <= 6) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _getTip(int minutes) {
    final hours = minutes / 60.0;
    if (hours <= 2) return 'Excellent balance today. Keep it up.';
    if (hours <= 4) return 'Good job. Try short eye breaks every hour.';
    if (hours <= 6) {
      return 'A bit high. Take a 10-minute break away from the screen.';
    }
    return 'Your screen time is high today. Try reducing non-essential usage.';
  }

  void _addMinutes(int value) {
    setState(() {
      _screenMinutes += value;
    });
  }

  void _resetMinutes() {
    setState(() {
      _screenMinutes = 0;
    });
  }

  Future<void> _saveScreenTime() async {
    try {
      await DataService().saveScreenTime(_screenMinutes / 60.0);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Screen time saved: ${_formatMinutes(_screenMinutes)}',
            ),
          ),
        );
      }

      await _loadScreenTimeData();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save screen time'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(_screenMinutes);
    final statusColor = _getStatusColor(_screenMinutes);
    final maxVal = _weeklyMinutes.isEmpty
        ? 0.0
        : _weeklyMinutes.reduce((a, b) => a > b ? a : b).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Screen Time Tracker',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Today’s Screen Time',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatMinutes(_screenMinutes),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _getTip(_screenMinutes),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addMinutes(30),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('+30 min'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addMinutes(60),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('+1 hour'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetMinutes,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveScreenTime,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Weekly Report',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Last 7 days screen time summary',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(_weeklyMinutes.length, (i) {
                            final heightRatio =
                                maxVal > 0 ? _weeklyMinutes[i] / maxVal : 0.0;
                            final dayStatusColor =
                                _getStatusColor(_weeklyMinutes[i]);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  (_weeklyMinutes[i] ~/ 60).toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 22,
                                  height: 100 * heightRatio + 12,
                                  decoration: BoxDecoration(
                                    color: dayStatusColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _days[i],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}