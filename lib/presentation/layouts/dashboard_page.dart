import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';

class DashboardPage extends StatelessWidget {
  final User user;
  const DashboardPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    user.profilePictureUrl,
                    height: 80,
                    width: 80,
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
                    onPressed: () {},
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  const Text("Interviews Completed: "),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Text(
                      "2",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
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
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: const Center(child: Text("2")),
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        user.skills[index].toString(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
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
              SizedBox(height: 132, child: LearningSection(id: user.id)),
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
                              style: Theme.of(context).textTheme.titleLarge,
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
                              style: Theme.of(context).textTheme.titleLarge,
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
                ],
              ),
            ]),
      ),
    );
  }
}
