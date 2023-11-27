import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/entities/subtopic.dart';
import 'package:reaidy/presentation/bloc/courses/courses_bloc.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/bloc/courses/courses_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';

class ViewCoursePage extends StatelessWidget {
  const ViewCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    String courseId = arguments["courseId"]!;
    String? userId = arguments["userId"];
    var isExpanded = false;
    return BlocBuilder<CoursesBloc, CoursesState>(builder: (context, state) {
      return state is SuccessCoursesListState
          ? Builder(builder: (context) {
              print(courseId);
              print(state.allCourses);
              final course = state.allCourses
                  .firstWhere((element) => element.id == courseId);
              final bool isUserEnrolled = state.userCourses
                  .where((element) => element.id == courseId)
                  .isNotEmpty;
              final userCourse = state.userCourses.firstWhere(
                (element) => element.id == courseId,
                orElse: () => course,
              );
              final totalTopics = userCourse.topics.fold<int>(
                  0,
                  (previousValue, element) =>
                      previousValue + element.subtopic.length);
              final progress = userCourse.completedTopics.length / totalTopics;
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const ReaidyLogo(),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight((Theme.of(context)
                                .progressIndicatorTheme
                                .linearMinHeight ??
                            6) *
                        3),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: LinearProgressIndicator(
                        value: progress,
                      ),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              course.thumbnail,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            )),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                course.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  child: Text(
                                    "$totalTopics topics",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  child: Text(
                                    "42 hours",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.description,
                                maxLines: isExpanded ? null : 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: const Text("View More"),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  !isUserEnrolled
                                      ? FilledButton(
                                          onPressed: () {
                                            if (userId != null) {
                                              Injector.coursesBloc.add(
                                                EnrollCourse(
                                                  userId: userId,
                                                  courseId: course.id,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.lock_open_outlined,
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text("Enroll"),
                                            ],
                                          ))
                                      : FilledButton(
                                          onPressed: () {
                                            final subtopics = course.topics.fold<
                                                    List<Subtopic>>(
                                                [],
                                                (previousValue, element) =>
                                                    previousValue
                                                      ..addAll(element
                                                          .subtopic)).toList();
                                            final completedSubtopics =
                                                subtopics;
                                            completedSubtopics.removeWhere(
                                                (element) => userCourse
                                                    .completedTopics
                                                    .contains(element.id));
                                            final previousTopic = subtopics
                                                        .indexOf(
                                                            completedSubtopics
                                                                .first) !=
                                                    0
                                                ? subtopics[subtopics.indexOf(
                                                        completedSubtopics
                                                            .first) -
                                                    1]
                                                : null;
                                            final nextTopic =
                                                completedSubtopics.length == 1
                                                    ? null
                                                    : completedSubtopics[1];
                                            Navigator.of(context).pushNamed(
                                                "/course-content",
                                                arguments: {
                                                  "subtopic":
                                                      completedSubtopics.first,
                                                  "completed-subtopics": course
                                                      .topics
                                                      .fold<List<Subtopic>>(
                                                          [],
                                                          (previousValue,
                                                                  element) =>
                                                              previousValue
                                                                ..addAll(element
                                                                    .subtopic))
                                                      .where((element) =>
                                                          userCourse
                                                              .completedTopics
                                                              .contains(
                                                                  element.id))
                                                      .toList(),
                                                  "next-subtopics":
                                                      completedSubtopics
                                                          .skip(1)
                                                          .toList(),
                                                  "userId": userId,
                                                  "courseId": courseId,
                                                  "isMarkedComplete": false
                                                });
                                          },
                                          child: const Text("Start Learning"),
                                        ),
                                ],
                              ),
                            ],
                          );
                        }),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Topics you'll cover in this course",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.topics[index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ListView.separated(
                                    itemBuilder: (context, subtopicIndex) =>
                                        InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            "/course-content",
                                            arguments: {
                                              "subtopic": course.topics[index]
                                                  .subtopic[subtopicIndex],
                                              "completed-subtopics": course
                                                  .topics
                                                  .fold<List<Subtopic>>(
                                                      [],
                                                      (previousValue,
                                                              element) =>
                                                          previousValue
                                                            ..addAll(element
                                                                .subtopic))
                                                  .where((element) => userCourse
                                                      .completedTopics
                                                      .contains(element.id))
                                                  .toList(),
                                              "next-subtopics": course
                                                  .topics[index].subtopic
                                                  .skip(subtopicIndex)
                                                  .toList(),
                                              "userId": userId,
                                              "courseId": courseId,
                                              "isMarkedComplete": false
                                            });
                                      },
                                      child: Text(course.topics[index]
                                          .subtopic[subtopicIndex].title),
                                    ),
                                    separatorBuilder: (_, __) => const SizedBox(
                                      height: 8,
                                    ),
                                    itemCount:
                                        course.topics[index].subtopic.length,
                                    shrinkWrap: true,
                                    primary: false,
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(),
                                ),
                            itemCount: course.topics.length),
                      ],
                    ),
                  ),
                ),
              );
            })
          : Scaffold(
              body: Center(
                  child: state is CoursesFailureState
                      ? Text(state.message)
                      : const CircularProgressIndicator()),
            );
    });
  }
}
