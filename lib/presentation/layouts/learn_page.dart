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

class LearnPage extends StatelessWidget {
  const LearnPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(builder: (context, state) {
      return Scaffold(
        body: state is SuccessCoursesListState
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.75),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ClipOval(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.05)
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: ClipOval(
                                child: Container(
                                  color: Colors.black,
                                  child: state.allCourses[index].thumbnail
                                          .contains("http")
                                      ? Image.network(
                                          state.allCourses[index].thumbnail,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.memory(
                                          base64Decode(state
                                              .allCourses[index].thumbnail
                                              .split("base64,")[1]),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          state.allCourses[index].title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                  itemCount: state.allCourses.length,
                ),
              )
            : CircularProgressIndicator(),
      );
    });
  }
}
