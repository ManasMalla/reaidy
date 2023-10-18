import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/injector.dart';

class InterviewPage extends StatelessWidget {
  const InterviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterviewBloc, InterviewState>(
        builder: (context, state) {
      return Scaffold(
        body: state is PastInterviewListState
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Interview ${index + 1}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(state.interviews[index].technology),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              state.interviews[index].createdAt.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.type_specimen_outlined,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  state.interviews[index].interviewType,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.speed_outlined,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  state.interviews[index].levelOfInterview,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.timer_outlined,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  state.interviews[index].numberOfQuestions
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(
                    height: 8,
                  ),
                  itemCount: state.interviews.length,
                ),
              )
            : CircularProgressIndicator(),
      );
    });
  }
}
