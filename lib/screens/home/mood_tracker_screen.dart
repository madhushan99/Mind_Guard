import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  String _selectedMood = '';
  String _selectedEmoji = '';
  String _message = 'How are you feeling today?';

  final List<Map<String, String>> moods = [
    {
      'emoji': '😄',
      'label': 'Happy',
      'message': 'That is great. Keep your positive energy going.',
    },
    {
      'emoji': '😊',
      'label': 'Good',
      'message': 'Nice. You seem to be doing well today.',
    },
    {
      'emoji': '😐',
      'label': 'Okay',
      'message': 'It is okay to have an average day. Take things slowly.',
    },
    {
      'emoji': '😔',
      'label': 'Sad',
      'message': 'Be gentle with yourself today. Take some rest if needed.',
    },
    {
      'emoji': '😣',
      'label': 'Stressed',
      'message': 'Try a breathing exercise and take a short break.',
    },
  ];

  void _selectMood(String emoji, String label, String message) {
    setState(() {
      _selectedEmoji = emoji;
      _selectedMood = label;
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _selectedEmoji.isEmpty ? '🙂' : _selectedEmoji,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedMood.isEmpty ? 'Select Your Mood' : _selectedMood,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose a mood',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              itemCount: moods.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final mood = moods[index];
                final isSelected = _selectedMood == mood['label'];

                return GestureDetector(
                  onTap: () => _selectMood(
                    mood['emoji']!,
                    mood['label']!,
                    mood['message']!,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withOpacity(0.12)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : Theme.of(context).dividerColor,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood['emoji']!,
                          style: const TextStyle(fontSize: 34),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mood['label']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _selectedMood.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mood selected: $_selectedMood'),
                          ),
                        );
                      },
                icon: const Icon(Icons.favorite),
                label: const Text(
                  'Save Mood',
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