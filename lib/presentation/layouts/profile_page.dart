import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/presentation/bloc/auth/auth_bloc.dart';
import 'package:reaidy/presentation/bloc/auth/auth_event.dart';
import 'package:reaidy/presentation/bloc/auth/auth_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var changes = 0;
  var designation;

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController collegeEditingController = TextEditingController();
  TextEditingController departmentEditingController = TextEditingController();
  TextEditingController yearOfStudyEditingController = TextEditingController();
  TextEditingController designationEditingController = TextEditingController();
  List<String> userSkills = [];
  TextEditingController userSkillsEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var state = Injector.authBloc.state;
    if (state is SuccessAuthState) {
      designation = {state.user.userRole.toLowerCase()};
      userSkills = state.user.skills;
      nameEditingController.text = state.user.name;
      collegeEditingController.text = state.user.college;
      departmentEditingController.text = state.user.branch;
      yearOfStudyEditingController.text = state.user.year.toString();
      designationEditingController.text = state.user.designation;
    } else if (state is UnauthorizedAuthState) {
      designation = {widget.user.userRole.toLowerCase()};
      userSkills = widget.user.skills;
      nameEditingController.text = widget.user.name;
      collegeEditingController.text = widget.user.college;
      departmentEditingController.text = widget.user.branch;
      yearOfStudyEditingController.text = widget.user.year.toString();
      designationEditingController.text = widget.user.designation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<AuthBloc, AuthState>(
              bloc: Injector.authBloc,
              builder: (context, state) {
                final user =
                    state is SuccessAuthState ? state.user : widget.user;
                return state is SuccessAuthState ||
                        state is UnauthorizedAuthState
                    ? Column(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Text(user.email),
                                    Text(
                                      user.designation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
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
                          Center(
                            child: SegmentedButton(
                              segments: [
                                ButtonSegment(
                                  value: "student",
                                  label: Text("Student"),
                                ),
                                ButtonSegment(
                                  value: "employee",
                                  label: Text("Employee"),
                                ),
                              ],
                              onSelectionChanged: (newValue) {
                                designation = newValue;
                                changes++;
                                setState(() {});
                              },
                              selected: designation,
                              showSelectedIcon: false,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Name"),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: nameEditingController,
                            onChanged: (_) {
                              changes++;
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("College"),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: collegeEditingController,
                            onChanged: (_) {
                              changes++;
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Department (Branch)"),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: departmentEditingController,
                            onChanged: (_) {
                              changes++;
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Year of Study"),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: yearOfStudyEditingController,
                            onChanged: (_) {
                              changes++;
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Designation"),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: designationEditingController,
                            onChanged: (_) {
                              changes++;
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text("Skills you have"),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: userSkillsEditingController,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  userSkills
                                      .add(userSkillsEditingController.text);
                                  userSkillsEditingController.clear();
                                  userSkills = userSkills.toSet().toList();
                                  changes++;
                                  setState(() {});
                                },
                                child: Text("Add"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          MasonryGridView.builder(
                            gridDelegate:
                                const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                            ),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userSkills[index].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        userSkills.removeAt(index);
                                        changes++;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: userSkills.length,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  Injector.authBloc.add(UpdateUserData(
                                    googleId: user.googleId,
                                    userData: {
                                      "name": nameEditingController.text,
                                      "branch":
                                          departmentEditingController.text,
                                      "college": collegeEditingController.text,
                                      "designation":
                                          designationEditingController.text,
                                      "year": int.parse(
                                          yearOfStudyEditingController.text),
                                      "skills": userSkills,
                                      //TODO add user role
                                    },
                                  ));
                                },
                                child: Text("Update Profile"),
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  await Injector.googleSignIn.signOut();
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.clear();
                                  Navigator.of(context)
                                      .pushReplacementNamed("/splash");
                                },
                                child: Text("Logout"),
                              ),
                            ],
                          ),
                        ],
                      )
                    : state is FailureAuthState
                        ? Center(
                            child: Text(state.message),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
              }),
        ),
      ),
    );
  }
}
