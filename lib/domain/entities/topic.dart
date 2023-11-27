import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/subtopic.dart';

class Topic extends Equatable {
  final String id;
  final String title;
  final List<Subtopic> subtopic;
  const Topic({
    required this.id,
    required this.title,
    required this.subtopic,
  });

  @override
  List<Object?> get props => [id];
}
