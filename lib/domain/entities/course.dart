class Course {
  final String id;
  final String title;
  final String description;
  final String image;
  final String thumbnail;
  final int sort;
  final List<dynamic> benefits;
  final List<dynamic> outComes;
  final List<String> requirements;
  final List<dynamic> courseFor;
  final bool comingSoon;
  final bool isActive;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.thumbnail,
    required this.sort,
    required this.benefits,
    required this.outComes,
    required this.requirements,
    required this.courseFor,
    required this.comingSoon,
    required this.isActive,
  });
}
