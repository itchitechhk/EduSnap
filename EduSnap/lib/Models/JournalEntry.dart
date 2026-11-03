class JournalEntry {
  const JournalEntry({
    required this.title,
    required this.note,
    required this.createdAt,
  });

  final String title;
  final String note;
  final DateTime createdAt;
}
