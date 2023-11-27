import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:reaidy/domain/entities/course.dart';
import 'package:reaidy/domain/entities/subtopic.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseContentPage extends StatefulWidget {
  const CourseContentPage({super.key});

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print(arguments);
    var subtopic = (arguments)["subtopic"] as Subtopic;

    var completedSubtopics = arguments["completed-subtopics"] as List<Subtopic>;
    final nextSubtopics = arguments["next-subtopics"] as List<Subtopic>;
    final isMarkedComplete = arguments["isMarkedComplete"] as bool;
    var isExpanded = false;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .popUntil((route) => route.settings.name == "/home");
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const ReaidyLogo(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // ClipRRect(
              //     borderRadius: BorderRadius.circular(16),
              //     child: Image.network(
              //       "https://i3.ytimg.com/vi/${subtopic.videoLink.split("?")[0]}/maxresdefault.jpg",
              //       width: double.infinity,
              //       fit: BoxFit.fitWidth,
              //     )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: subtopic.videoLink,
                      flags: YoutubePlayerFlags(
                        startAt: subtopic.startTime,
                        endAt: subtopic.endTime,
                      ),
                    ),
                    aspectRatio: 16 / 9,
                  )),
              const SizedBox(
                height: 24,
              ),
              Text(
                subtopic.title,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 12,
              ),
              ReadMoreText(
                subtopic.description.split(".").fold<String>(
                    "",
                    (previousValue, element) =>
                        previousValue +
                        (subtopic.description.split(".").indexOf(element) % 2 ==
                                1
                            ? "$element.\n\n"
                            : element)),
                trimLines: 4,
                colorClickableText: Theme.of(context).colorScheme.primary,
                lessStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                trimMode: TrimMode.Length,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 24,
              ),
              !isMarkedComplete
                  ? OutlinedButton(
                      onPressed: () {
                        Injector.coursesBloc.add(MarkSubtopicAsCompleted(
                            userId: arguments["userId"]!,
                            courseId: arguments["courseId"]!,
                            topicId: subtopic.id,
                            callback: () {
                              Navigator.of(context).pushNamed(
                                "/course-content",
                                arguments: {
                                  "subtopic": nextSubtopics.first,
                                  "completed-subtopics": completedSubtopics
                                    ..add(subtopic),
                                  "next-subtopics":
                                      nextSubtopics.skip(1).toList(),
                                  "userId": arguments["userId"],
                                  "courseId": arguments["courseId"],
                                  "isMarkedComplete": completedSubtopics
                                      .contains(nextSubtopics.first)
                                },
                              );
                            }));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Mark as completed"),
                        ],
                      ))
                  : FilledButton(
                      onPressed: null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Completed")
                        ],
                      )),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: completedSubtopics.isEmpty
                            ? null
                            : () {
                                Navigator.of(context).pushNamed(
                                  "/course-content",
                                  arguments: {
                                    "subtopic": completedSubtopics.last,
                                    "completed-subtopics": completedSubtopics
                                      ..removeLast()
                                      ..remove(subtopic)
                                      ..toList(),
                                    "next-subtopics": nextSubtopics
                                      ..insert(0, subtopic)
                                      ..toList(),
                                    "userId": arguments["userId"],
                                    "courseId": arguments["courseId"],
                                    "isMarkedComplete": completedSubtopics
                                        .contains(completedSubtopics.last)
                                  },
                                );
                              },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chevron_left),
                            Text("Previous"),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250 * 0.65,
                        child: Text(
                          (completedSubtopics.last).title,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: nextSubtopics.isEmpty
                            ? null
                            : () {
                                Navigator.of(context).pushNamed(
                                  "/course-content",
                                  arguments: {
                                    "subtopic": nextSubtopics.first,
                                    "completed-subtopics": completedSubtopics
                                      ..add(subtopic),
                                    "next-subtopics":
                                        nextSubtopics.skip(1).toList(),
                                    "userId": arguments["userId"],
                                    "courseId": arguments["courseId"],
                                    "isMarkedComplete": completedSubtopics
                                        .contains(nextSubtopics.first)
                                  },
                                );
                              },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Next"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250 * 0.65,
                        child: Text(
                          (nextSubtopics.first).title,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
