class DailyContent {
  final String quote;
  final String tip;

  DailyContent({
    required this.quote,
    required this.tip,
  });
}

final List<DailyContent> dailyContents = [
  DailyContent(
    quote: "Small progress is still progress.",
    tip: "Take a 5-minute break and focus on slow breathing.",
  ),
  DailyContent(
    quote: "Be kind to yourself.",
    tip: "Drink water and stretch your body.",
  ),
  DailyContent(
    quote: "One step at a time is enough.",
    tip: "Write one good thing about today.",
  ),
];