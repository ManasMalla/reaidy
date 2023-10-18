import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/domain/usecases/interview_usecase.dart';
import 'package:reaidy/presentation/bloc/courses/courses_bloc.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/bloc/courses/courses_state.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/dashboard_page.dart';
import 'package:reaidy/presentation/layouts/interview_page.dart';
import 'package:reaidy/presentation/layouts/learn_page.dart';

enum ReaidyDestination {
  home,
  interview,
  learn,
  profile,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var destination = ReaidyDestination.home;
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    Injector.coursesBloc.add(FetchCoursesList(userId: user.id));
    Injector.interviewBloc.add(FetchPastInterviews(intervieweeId: user.id));
    return Scaffold(
      appBar: AppBar(
        title: const ReaidyLogo(),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: destination == ReaidyDestination.home
            ? DashboardPage(user: user)
            : destination == ReaidyDestination.interview
                ? InterviewPage()
                : destination == ReaidyDestination.learn
                    ? LearnPage()
                    : const Scaffold(),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt),
            label: "Interview",
            selectedIcon: Icon(Icons.person_add_alt_1),
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            label: "Learn",
            selectedIcon: Icon(Icons.book),
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: "Profile",
            selectedIcon: Icon(Icons.account_circle),
          ),
        ],
        selectedIndex: ReaidyDestination.values.indexOf(destination),
        onDestinationSelected: (selectedDestination) {
          setState(() {
            destination = ReaidyDestination.values[selectedDestination];
          });
        },
      ),
    );
  }
}

class ReaidyLogo extends StatelessWidget {
  const ReaidyLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: "Re"),
        TextSpan(
          text: "ai",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const TextSpan(text: "dy"),
      ]),
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: "Gobold Extra",
            color: Colors.black,
            letterSpacing: 2,
          ),
    );
  }
}

class LearningSection extends StatelessWidget {
  final String id;
  const LearningSection({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
        bloc: Injector.coursesBloc,
        builder: (context, state) {
          return state is SuccessCoursesListState
              ? SizedBox(
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        print(state.userCourses.length);
                        return index == state.userCourses.length
                            ? Column(
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
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
                                        padding: const EdgeInsets.all(16),
                                        child: ClipOval(
                                          child: Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Icon(
                                              Icons.add_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    "Add course",
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
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
                                        padding: const EdgeInsets.all(16),
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.black,
                                            child: state.userCourses[index]
                                                    .thumbnail
                                                    .contains("http")
                                                ? Image.network(
                                                    state.userCourses[index]
                                                        .thumbnail,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(state
                                                        .userCourses[index]
                                                        .thumbnail
                                                        .split("base64,")[1]),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    state.userCourses[index].title,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                      },
                      separatorBuilder: (context, _) => const SizedBox(
                            width: 12,
                          ),
                      itemCount: state.userCourses.length + 1),
                )
              : Center(child: const CircularProgressIndicator());
        });
  }
}
