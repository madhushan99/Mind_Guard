import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  double _sleepHours = 8;
  String _sleepQuality = 'Good';

  final List<double> _weeklySleep = [7.5, 8, 6.5, 7, 8.5, 6, 7.8];

  String _getSleepMessage() {
    if (_sleepHours < 6) {
      return 'You may need more sleep. Try to rest earlier tonight.';
    } else if (_sleepHours <= 8) {
      return 'Nice. Your sleep duration looks healthy.';
    } else {
      return 'You slept well. Hope you feel refreshed today.';
    }
  }

  Color _getBarColor(bool isLast) {
    return isLast ? AppTheme.primary : AppTheme.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final maxSleep = _weeklySleep.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.bedtime_outlined,
                      size: 50,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_sleepHours.toStringAsFixed(1)} hours',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getSleepMessage(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      value: _sleepHours,
                      min: 0,
                      max: 12,
                      divisions: 24,
                      activeColor: AppTheme.primary,
                      label: _sleepHours.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _sleepHours = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sleep Quality',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QualityButton(
                    label: 'Poor',
                    isSelected: _sleepQuality == 'Poor',
                    onTap: () {
                      setState(() {
                        _sleepQuality = 'Poor';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QualityButton(
                    label: 'Good',
                    isSelected: _sleepQuality == 'Good',
                    onTap: () {
                      setState(() {
                        _sleepQuality = 'Good';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QualityButton(
                    label: 'Excellent',
                    isSelected: _sleepQuality == 'Excellent',
                    onTap: () {
                      setState(() {
                        _sleepQuality = 'Excellent';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Weekly Sleep Chart',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Last 7 days sleep duration',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_weeklySleep.length, (index) {
                      final value = _weeklySleep[index];
                      final ratio = maxSleep > 0 ? value / maxSleep : 0.0;
                      final isLast = index == _weeklySleep.length - 1;
                      const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 24,
                            height: 140 * ratio,
                            decoration: BoxDecoration(
                              color: _getBarColor(isLast),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            days[index],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sleep saved: ${_sleepHours.toStringAsFixed(1)}h, Quality: $_sleepQuality',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save Sleep Data',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QualityButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.12)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : Theme.of(context).dividerColor,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}