class Subtopic {
  final String id;
  final String title;
  final String videoLink;
  final String description;
  final String videoType;
  final int startTime;
  final int endTime;
  final List<dynamic> content;

  Subtopic({
    required this.id,
    required this.title,
    required this.videoLink,
    required this.description,
    required this.videoType,
    required this.startTime,
    required this.endTime,
    required this.content,
  });
}
