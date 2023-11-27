import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/presentation/bloc/courses/courses_bloc.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/bloc/courses/courses_state.dart';
import 'package:reaidy/presentation/bloc/interview/interview_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';

class LearnPage extends StatelessWidget {
  final String userId;
  const LearnPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(builder: (context, state) {
      return Scaffold(
        body: state is SuccessCoursesListState
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0).copyWith(bottom: 24 + 56),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enrolled Courses",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 152,
                        child: LearningSection(
                          goToLearn: () {},
                          userId: userId,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Available Courses",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (_, __) => SizedBox(
                          height: 12,
                        ),
                        itemBuilder: (context, index) {
                          var course = state.allCourses
                              .where((element) =>
                                  !state.userCourses.contains(element))
                              .toList()[index];
                          return Card(
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 128,
                                    width: double.infinity,
                                    child: Container(
                                      color: Colors.black,
                                      child: course.thumbnail.contains("http")
                                          ? Image.network(
                                              course.thumbnail,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              base64Decode(course.thumbnail
                                                  .split("base64,")[1]),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.title,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          course.description,
                                          maxLines: 4,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            state.userCourses.contains(course)
                                                ? SizedBox()
                                                : FilledButton(
                                                    onPressed: () {
                                                      Injector.coursesBloc.add(
                                                        EnrollCourse(
                                                          userId: userId,
                                                          courseId: course.id,
                                                        ),
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .lock_open_outlined,
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Text("Enroll"),
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  '/view-course',
                                                  arguments: {
                                                    "courseId": course.id,
                                                    "userId": userId
                                                  },
                                                );
                                              },
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("View Course"),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          );
                        },
                        itemCount: state.allCourses
                            .where((element) =>
                                !state.userCourses.contains(element))
                            .length,
                      ),
                    ],
                  ),
                ),
              )
            : state is CoursesFailureState
                ? Center(
                    child: Text(state.message),
                  )
                : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
