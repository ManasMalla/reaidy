import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/presentation/bloc/interview/create_interview_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/injector.dart';

class NewInterviewBottomSheet extends StatefulWidget {
  final User user;
  const NewInterviewBottomSheet({
    super.key,
    required this.user,
  });

  @override
  State<NewInterviewBottomSheet> createState() =>
      _NewInterviewBottomSheetState();
}

class _NewInterviewBottomSheetState extends State<NewInterviewBottomSheet> {
  var technologyController = TextEditingController();
  var selectedDifficulty = {"low"};
  var selectedNumberOfQuestions = 5;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateInterviewBloc, InterviewState>(
      builder: (context, state) {
        return state is CreateInterviewState
            ? SingleChildScrollView(
                child: Wrap(children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0).copyWith(
                        bottom: 24 + MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create Interview",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                            "Prepare for success. Customize your mock interview and let AI refine your skills. Start by providing details below."),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.monetization_on_outlined,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                  child: Text(
                                "50 credits will be deducted for each interview",
                                style: Theme.of(context).textTheme.labelMedium,
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Technology',
                            prefixIcon: const Icon(Icons.code),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: technologyController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DropdownButtonFormField(
                          items: const [
                            DropdownMenuItem(
                              value: 5,
                              child: Text('5 Questions'),
                            ),
                            DropdownMenuItem(
                              value: 10,
                              child: Text('10 Questions'),
                            ),
                          ],
                          onChanged: (value) {
                            selectedNumberOfQuestions = value ?? 5;
                            setState(() {});
                          },
                          value: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton(
                            segments: const [
                              ButtonSegment(value: 'low', label: Text('Easy')),
                              ButtonSegment(
                                  value: 'medium', label: Text('Medium')),
                              ButtonSegment(value: 'high', label: Text('Hard')),
                            ],
                            selected: selectedDifficulty,
                            onSelectionChanged: (_) {
                              selectedDifficulty = _;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        FilledButton(
                          onPressed: () {
                            final technology = technologyController.text;
                            final levelOfDifficulty = selectedDifficulty.first;
                            final numberOfQuestions = selectedNumberOfQuestions;
                            Injector.createInterviewBloc.add(OnCreateInterview(
                                technology: technology,
                                intervieweeId: widget.user.id,
                                name: widget.user.name,
                                levelOfDifficulty: levelOfDifficulty,
                                numberOfQuestions: numberOfQuestions));
                          },
                          child: const Text("Create Interview"),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            : state is InterviewFailureState
                ? Center(
                    child: Text(state.message),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
      },
      listener: (BuildContext context, InterviewState state) {
        if (state is CreatedInterviewState) {
          Navigator.of(context).pushNamed('/interview');
        }
      },
      listenWhen: (previous, current) =>
          !(previous is CreatedInterviewState) &&
          current is CreatedInterviewState,
    );
  }
}
