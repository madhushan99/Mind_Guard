import 'package:flutter/material.dart';
import '../data/daily_motivation_data.dart';

class DailyMotivationCard extends StatefulWidget {
  const DailyMotivationCard({super.key});

  @override
  State<DailyMotivationCard> createState() => _DailyMotivationCardState();
}

class _DailyMotivationCardState extends State<DailyMotivationCard> {
  late DailyContent _content;

  @override
  void initState() {
    super.initState();
    _setTodayContent();
  }

  void _setTodayContent() {
    final int dayIndex =
        DateTime.now().difference(DateTime(2024, 1, 1)).inDays;
    _content = dailyContents[dayIndex % dailyContents.length];
  }

  void _refreshContent() {
    setState(() {
      _content =
          dailyContents[(dailyContents.indexOf(_content) + 1) % dailyContents.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title + Refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Daily Motivation",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _refreshContent,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Quote
          Text(
            '"${_content.quote}"',
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // 🔹 Tip
          const Text(
            "Today's Tip",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(_content.tip),
        ],
      ),
    );
  }
}