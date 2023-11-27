import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:reaidy/domain/entities/subtopic.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/domain/usecases/interview_usecase.dart';
import 'package:reaidy/presentation/bloc/courses/courses_bloc.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/bloc/courses/courses_state.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/bloc/payments/payment_event.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/certificate_page.dart';
import 'package:reaidy/presentation/layouts/dashboard_page.dart';
import 'package:reaidy/presentation/layouts/interview_page.dart';
import 'package:reaidy/presentation/layouts/learn_page.dart';
import 'package:reaidy/presentation/layouts/new_interview_bottom_sheet.dart';
import 'package:reaidy/presentation/layouts/profile_page.dart';

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
    Injector.paymentBloc.add(const FetchCoupons());
    return BlocConsumer(
        bloc: Injector.createInterviewBloc,
        listener: (context, state) {
          if (state is SpecificInterviewState) {
            setState(() {
              destination = ReaidyDestination.interview;
            });
          }
        },
        builder: (context, _) {
          return Scaffold(
            floatingActionButton: destination == ReaidyDestination.home ||
                    destination == ReaidyDestination.interview
                ? BlocBuilder(
                    builder: (context, state) {
                      return state is SpecificInterviewState
                          ? FloatingActionButton.extended(
                              label: const Text("Show Certificate"),
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CertificatePage(
                                    isReport: true,
                                    skills: [
                                      (double.parse(((state.interview["result"]
                                                          [1]["score"] /
                                                      100) as double)
                                                  .toStringAsFixed(2)) *
                                              100)
                                          .toInt(),
                                      (double.parse(((state.interview["result"]
                                                          [2]["score"] /
                                                      100) as double)
                                                  .toStringAsFixed(2)) *
                                              100)
                                          .toInt(),
                                      (double.parse(((state.interview["result"]
                                                          [0]["score"] /
                                                      100) as double)
                                                  .toStringAsFixed(2)) *
                                              100)
                                          .toInt()
                                    ],
                                    title: state.interview["technology"],
                                    name: state.interview["interviewee"]
                                        ["name"],
                                    date: DateFormat("dd MMM yyyy").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            state.interview["createdAt"])),
                                  ),
                                ));
                              },
                            )
                          : FloatingActionButton.extended(
                              label: const Text("Create Interview"),
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Injector.createInterviewBloc
                                    .add(const ResetCreateInterviewState());
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => InterviewTypeSelection(
                                    user: user,
                                  ),
                                  // TypeOfInterviewBottomSheet()
                                  //NewInterviewBottomSheet(
                                  // user: user,
                                  // ),
                                );
                              },
                            );
                    },
                    bloc: Injector.interviewBloc)
                : null,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: const ReaidyLogo(),
              centerTitle: true,
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: destination == ReaidyDestination.home
                  ? DashboardPage(
                      user: user,
                      goToProfile: () {
                        destination = ReaidyDestination.profile;
                        setState(() {});
                      },
                      goToLearn: () {
                        destination = ReaidyDestination.learn;
                        setState(() {});
                      })
                  : destination == ReaidyDestination.interview
                      ? const InterviewPage()
                      : destination == ReaidyDestination.learn
                          ? LearnPage(
                              userId: user.id,
                            )
                          : ProfilePage(
                              user: user,
                            ),
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
        });
  }
}

class InterviewTypeSelection extends StatelessWidget {
  final User user;
  const InterviewTypeSelection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final types = [
      {
        "title": "Basic Mock Practice",
        "description":
            "Efficient for Foundation Building: Basic mock practice efficiently [ Efficiency 60% ] establishes a foundational understanding, aiding in confidence-building and initial self-assessment.",
        "icon": Icons.co_present_outlined,
        "enabled": true
      },
      {
        "title": "Resume Based Interview",
        "description":
            "Efficient Initial Screening: A resume interview efficiently screens candidates based on their resume, providing a quick assessment of qualifications and potential alignment with the job.",
        "icon": Icons.task_outlined,
        "enabled": false
      },
      {
        "title": "Company Based Interview",
        "description":
            "Effective Candidate Evaluation: The company interview efficiently evaluates candidates through various formats, offering a comprehensive assessment of skills and cultural fit for the organization.",
        "icon": Icons.location_city_outlined,
        "enabled": false
      },
      {
        "title": "Company Interview with Resume",
        "description":
            "Efficient Comprehensive Assessment: Combining traditional elements with a resume-based evaluation, this interview efficiently assesses a candidate's background and alignment with the company's needs and culture.",
        "icon": Icons.location_city_outlined,
        "enabled": false
      },
      {
        "title": "HR Based Interview",
        "description":
            "Efficient Initial Screening: An HR interview efficiently screens candidates based on their resume, providing a quick assessment of qualifications and potential alignment with the job.",
        "icon": Icons.upcoming_outlined,
        "enabled": false
      },
      {
        "title": "English Practice Bot",
        "description":
            "English practice bot is a bot that helps you to practice your English speaking skills. It will ask you questions and you have to answer them. It will also give you feedback on your answers.",
        "icon": Icons.upcoming_outlined,
        "enabled": false
      }
    ];
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            "Choose your interview type",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 12,
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      types[index]["icon"] as IconData? ?? Icons.label_rounded,
                      size: 48,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      types[index]["title"].toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      types[index]["description"].toString(),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FilledButton(
                      onPressed: (types[index]["enabled"] as bool?) ?? false
                          ? () {
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => NewInterviewBottomSheet(
                                  user: user,
                                ),
                              );
                            }
                          : null,
                      child: Text("Start Interview"),
                    ),
                  ],
                ),
              ),
            ),
            itemCount: 6,
          ),
        ],
      ),
    );
  }
}

class ReaidyLogo extends StatelessWidget {
  final Color? color;
  final double? height;
  const ReaidyLogo({
    super.key,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: "Re"),
        TextSpan(
          text: "ai",
          style: TextStyle(
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        const TextSpan(text: "dy"),
      ]),
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: "Gobold Extra",
            color: Colors.black,
            letterSpacing: 2,
            fontSize: height,
          ),
    );
  }
}

class LearningSection extends StatelessWidget {
  final Function() goToLearn;
  final String userId;
  const LearningSection({
    super.key,
    required this.goToLearn,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
        bloc: Injector.coursesBloc,
        builder: (context, state) {
          return state is SuccessCoursesListState
              ? SizedBox(
                  height: 170,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        print(state.userCourses.length);
                        return index == state.userCourses.length
                            ? InkWell(
                                onTap: goToLearn,
                                child: Column(
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
                                ),
                              )
                            : InkWell(
                                onTap: () => {
                                  Navigator.of(context).pushNamed(
                                    '/view-course',
                                    arguments: {
                                      "courseId": state.userCourses[index].id,
                                      "userId": userId,
                                    },
                                  )
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                              value: (state.userCourses[index]
                                                      .completedTopics.length /
                                                  state
                                                      .userCourses[index].topics
                                                      .fold<List<Subtopic>>(
                                                          [],
                                                          (previousValue,
                                                                  element) =>
                                                              previousValue
                                                                ..addAll(element
                                                                    .subtopic)).length),
                                              strokeWidth: 8,
                                              strokeCap: StrokeCap.round,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                          ),
                                          ClipOval(
                                            child: SizedBox(
                                              width: 90,
                                              height: 90,
                                              child: ClipOval(
                                                child: Container(
                                                  color: Colors.black,
                                                  child: state
                                                          .userCourses[index]
                                                          .thumbnail
                                                          .contains("http")
                                                      ? Image.network(
                                                          state
                                                              .userCourses[
                                                                  index]
                                                              .thumbnail,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.memory(
                                                          base64Decode(state
                                                              .userCourses[
                                                                  index]
                                                              .thumbnail
                                                              .split(
                                                                  "base64,")[1]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      state.userCourses[index].title.length > 16
                                          ? state.userCourses[index].title
                                                  .substring(0, 16) +
                                              "..."
                                          : state.userCourses[index].title,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                      },
                      separatorBuilder: (context, _) => const SizedBox(
                            width: 12,
                          ),
                      itemCount: state.userCourses.length + 1),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }
}
