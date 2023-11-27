import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reaidy/presentation/bloc/interview/interview_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:speech_to_text/speech_to_text.dart';

class InterviewPage extends StatelessWidget {
  const InterviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Injector.interviewBloc.add(
          FetchPastInterviews(
              intervieweeId:
                  Injector.interviewBloc.state is SpecificInterviewState
                      ? (Injector.interviewBloc.state as SpecificInterviewState)
                          .interview["interviewee"]["_id"]
                      : ""),
        );
        return false;
      },
      child:
          BlocBuilder<InterviewBloc, InterviewState>(builder: (context, state) {
        return Scaffold(
          body: state is SpecificInterviewState
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: CircularProgressIndicator(
                                          value: double.parse(
                                              ((state.interview["result"][1]
                                                          ["score"] /
                                                      100) as double)
                                                  .toStringAsFixed(2)),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          strokeCap: StrokeCap.round,
                                          strokeWidth: 8,
                                        ),
                                      ),
                                      Text(
                                        "${double.parse(((state.interview["result"][1]["score"] / 100) as double).toStringAsFixed(2)) * 100}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const Text(
                                    "Technical skills",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: CircularProgressIndicator(
                                          value: double.parse(
                                              ((state.interview["result"][2]
                                                          ["score"] /
                                                      100) as double)
                                                  .toStringAsFixed(2)),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          strokeCap: StrokeCap.round,
                                          strokeWidth: 8,
                                        ),
                                      ),
                                      Text(
                                        "${double.parse(((state.interview["result"][2]["score"] / 100) as double).toStringAsFixed(2)) * 100}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const Text(
                                    "Communication skills",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: CircularProgressIndicator(
                                          value: double.parse(
                                              ((state.interview["result"][0]
                                                          ["score"] /
                                                      100) as double)
                                                  .toStringAsFixed(2)),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          strokeCap: StrokeCap.round,
                                          strokeWidth: 8,
                                        ),
                                      ),
                                      Text(
                                        "${double.parse(((state.interview["result"][0]["score"] / 100) as double).toStringAsFixed(2)) * 100}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const Text(
                                    "Overall skills",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Summary",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          state.interview["result"][3]["score"],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Interview Details",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Interviee: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${state.interview["interviewee"]["name"]}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Duration: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const Text("--"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Interviewer: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const Text("Lucy"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Topic: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      Text("${state.interview["technology"]}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("ID: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      Text("${state.interview["_id"]}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Microphone: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const Text("Allowed"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Video: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const Text("Allowed"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Level: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          "${state.interview["levelOfInterview"]}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Question and Answers",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            var question = state.interview["questions"][index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Q${index + 1}. " + question["question"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  question["answer"],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Score: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        question["score"].toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(
                            height: 16,
                          ),
                          itemCount: state.interview["questions"].length,
                        ),
                      ],
                    ),
                  ),
                )
              : state is PastInterviewListState
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 80, left: 0, right: 0),
                        itemBuilder: (context, index) {
                          print(state.interviews.reversed
                              .toList()[index]
                              .createdAt);
                          return InkWell(
                            onTap: () async {
                              if (state.interviews.reversed
                                      .toList()[index]
                                      .overall ==
                                  0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Generating your report..."),
                                  ),
                                );
                                //Finish the interview
                                final result = await Injector
                                    .interviewBloc.interviewUsecase
                                    .finishInterview(state.interviews.reversed
                                        .toList()[index]
                                        .id);

                                if (result.isLeft()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Failed to generate your report."),
                                    ),
                                  );
                                } else {
                                  Injector.interviewBloc.add(
                                    FetchSpecificInterview(
                                      interviewId: state.interviews.reversed
                                          .toList()[index]
                                          .id,
                                    ),
                                  );
                                }
                              } else {
                                Injector.interviewBloc.add(
                                  FetchSpecificInterview(
                                    interviewId: state.interviews.reversed
                                        .toList()[index]
                                        .id,
                                  ),
                                );
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.interviews.reversed
                                                .toList()[index]
                                                .technology,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            "Interview ${state.interviews.length - (index)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            DateFormat(
                                                    "EE dd MMM yyyy, hh:mm aa")
                                                .format(state
                                                    .interviews.reversed
                                                    .toList()[index]
                                                    .createdAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.type_specimen_outlined,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                state.interviews.reversed
                                                    .toList()[index]
                                                    .interviewType,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              const Icon(
                                                Icons.speed_outlined,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                state.interviews.reversed
                                                    .toList()[index]
                                                    .levelOfInterview,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              const Icon(
                                                Icons.timer_outlined,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                state.interviews.reversed
                                                    .toList()[index]
                                                    .numberOfQuestions
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    state.interviews.reversed
                                                .toList()[index]
                                                .overall ==
                                            0
                                        ? SizedBox(
                                            width: 100,
                                            child: Opacity(
                                              opacity: 0.4,
                                              child: Column(
                                                children: [
                                                  Icon(Icons
                                                      .warning_amber_rounded),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    "Report not yet generated",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Communication:"),
                                              Text(
                                                state.interviews.reversed
                                                    .toList()[index]
                                                    .communication
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text("Technical:"),
                                              Text(
                                                state.interviews.reversed
                                                    .toList()[index]
                                                    .technical
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text("Overall:"),
                                              Text(
                                                state.interviews.reversed
                                                    .toList()[index]
                                                    .overall
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 8,
                        ),
                        itemCount: state.interviews.reversed.toList().length,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
