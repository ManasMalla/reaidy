import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/presentation/bloc/auth/auth_bloc.dart';
import 'package:reaidy/presentation/bloc/auth/auth_event.dart';
import 'package:reaidy/presentation/bloc/auth/auth_state.dart';
import 'package:reaidy/presentation/injector.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Injector.authBloc.add(OnAppInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            const SizedBox(
              height: 86,
            ),
            Text.rich(
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
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontFamily: "Gobold Extra",
                    fontSize: 96,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
            ),
            const Text(
              "Stepping up your interview prep",
              style: TextStyle(
                letterSpacing: 0.6,
              ),
            ),
            const Spacer(),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is RegisterNewUserState) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Name",
                                    filled: true,
                                  ),
                                  controller: TextEditingController(
                                    text: state.displayName,
                                  ),
                                  onChanged: null,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SegmentedButton(
                                  segments: state.userRoles
                                      .map(
                                        (e) => ButtonSegment(
                                          value: e,
                                          label: Text(e.name),
                                        ),
                                      )
                                      .toList(),
                                  selected: {},
                                  onSelectionChanged: (_) {},
                                  multiSelectionEnabled: false,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    child: const Text("Register"),
                                    onPressed: () {
                                      //TODO work on workflow for new users
                                      // Injector.authBloc.add(
                                      //   OnRegisterUser(
                                      //     displayName: state.displayName,
                                      //     userRole: state.userRoles.first,
                                      //   ),
                                      // );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ));
                } else if (state is SuccessAuthState) {
                  Navigator.of(context).pushReplacementNamed(
                    "/home",
                    arguments: state.user,
                  );
                }
              },
              builder: (context, state) {
                if (state is UnauthorizedAuthState) {
                  return FilledButton(
                    onPressed: () async {
                      final authBloc = Injector.authBloc;
                      authBloc.add(OnSignInWithGoogle());
                    },
                    child: const Text("Sign in"),
                  );
                } else if (state is FailureAuthState) {
                  return Text(state.message);
                } else {
                  return const CircularProgressIndicator(
                      // color: Color(0xFFFF5722),
                      );
                }
              },
            ),
            const SizedBox(
              height: 86,
            ),
          ],
        ),
      ),
    );
  }
}
