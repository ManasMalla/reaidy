import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';
import 'package:reaidy/presentation/layouts/redeem_coupon_dialog.dart';

class DashboardPage extends StatelessWidget {
  final User user;
  final Function() goToProfile;
  final Function() goToLearn;
  const DashboardPage({
    super.key,
    required this.user,
    required this.goToProfile,
    required this.goToLearn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0)
            .copyWith(bottom: 24 + kFloatingActionButtonMargin + 56),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      user.profilePictureUrl,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(user.email),
                        Text(
                          user.designation,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: goToProfile,
                    icon: const Column(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              Row(
                children: [
                  Text(
                    "Credit points",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    "Interviews Completed: ",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  BlocBuilder<InterviewBloc, InterviewState>(
                      bloc: Injector.interviewBloc,
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(
                            state is PastInterviewListState
                                ? state.interviews.length.toString()
                                : "...",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        user.coins.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Skills",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              MasonryGridView.builder(
                gridDelegate:
                    const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                ),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          user.skills[index].toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: user.skills.length,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Learning",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              LearningSection(
                goToLearn: goToLearn,
                userId: user.id,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Skills based on recent interviews",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 36,
              ),
              Row(
                children: [
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
                                value: user.technicalSkills / 100,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 8,
                              ),
                            ),
                            Text(
                              "${user.technicalSkills}%",
                              style: Theme.of(context).textTheme.titleMedium,
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
                                value: user.communicationSkills / 100,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 8,
                              ),
                            ),
                            Text(
                              "${user.communicationSkills}%",
                              style: Theme.of(context).textTheme.titleMedium,
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
                                value: user.overallRating / 100,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 8,
                              ),
                            ),
                            Text(
                              "${user.overallRating}%",
                              style: Theme.of(context).textTheme.titleMedium,
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
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: FilledButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => RedeemCouponDialog(
                              user: user,
                            ));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.redeem_outlined),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Redeem Coupon"),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
