import 'dart:io';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reaidy/domain/entities/interview_response.dart';
import 'package:reaidy/presentation/bloc/interview/create_interview_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ProgressingInterviewPage extends StatefulWidget {
  const ProgressingInterviewPage({super.key});

  @override
  State<ProgressingInterviewPage> createState() =>
      _ProgressingInterviewPageState();
}

class _ProgressingInterviewPageState extends State<ProgressingInterviewPage> {
  var isVolumeOn = true;
  bool isMicOn = false;
  bool isVideoOn = false;
  var textController = TextEditingController();
  SpeechToText speech = SpeechToText();
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Injector.createInterviewBloc.add(ResetCreateInterviewState());
        Navigator.of(context).popUntil(ModalRoute.withName('/home'));
        return Future.value(false);
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            bottomSheet: BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(seconds: 2),
                          child:
                              BlocBuilder<CreateInterviewBloc, InterviewState>(
                                  bloc: Injector.createInterviewBloc,
                                  builder: (context, state) {
                                    return state is ServerLoadingInterviewState
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InterviewConversationBlock(
                                                response: InterviewResponse(
                                                    interviewId: "",
                                                    response: "",
                                                    role: "",
                                                    index: 0,
                                                    totalQuestions: 0,
                                                    topic: "",
                                                    interviewee: ""),
                                                isUser: false,
                                                isUserTranscribing: true,
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          )
                                        : SizedBox(
                                            height: 0,
                                          );
                                  }),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  hintText: "Type your response here",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  isDense: true,
                                ),
                                maxLines: null,
                              ),
                            ),
                            BlocBuilder(
                                bloc: Injector.createInterviewBloc,
                                builder: (context, state) {
                                  return TextButton(
                                    onPressed: state is CreatedInterviewState
                                        ? state.interviewResponse.length == 1 ||
                                                state
                                                        .interviewResponse[state
                                                                .interviewResponse
                                                                .length -
                                                            1]
                                                        .role
                                                        .toLowerCase() ==
                                                    "assistant"
                                            ? () {
                                                Injector.createInterviewBloc
                                                    .add(
                                                  ContinueInterviewState(
                                                    interviewId: (state
                                                                .interviewResponse
                                                                .lastOrNull ??
                                                            state
                                                                .interviewResponse
                                                                .first)
                                                        .interviewId,
                                                    userResponse:
                                                        textController.text,
                                                  ),
                                                );
                                                textController.clear();
                                              }
                                            : null
                                        : null,
                                    child: Text("Send"),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async {
                      isVolumeOn = !isVolumeOn;

                      setState(() {});
                    },
                    icon: Icon(
                      isVolumeOn
                          ? Icons.volume_up_outlined
                          : Icons.volume_off_outlined,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isVolumeOn
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      foregroundColor: isVolumeOn
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      isMicOn = !isMicOn;
                      setState(() {});
                    },
                    icon: Icon(
                      isMicOn ? Icons.mic_outlined : Icons.mic_off,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isMicOn
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      foregroundColor: isMicOn
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      if (speech.isAvailable) {
                        speech.listen(
                          onResult: (result) => setState(() {
                            if (!textController.text
                                .contains(result.recognizedWords)) {
                              textController.text = result.recognizedWords;
                            }
                          }),
                          listenMode: ListenMode.dictation,
                        );
                        setState(() {});
                      } else {
                        await speech.initialize();
                        speech.listen(
                          onResult: (result) => setState(() {
                            if (!textController.text
                                .contains(result.recognizedWords)) {
                              textController.text = result.recognizedWords;
                            }
                          }),
                          listenMode: ListenMode.dictation,
                        );
                        setState(() {});
                      }
                    },
                    child: Text(speech.isListening
                        ? "Stop Listening"
                        : "Start Listening"),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      isVideoOn = !isVideoOn;
                      setState(() {});
                    },
                    icon: Icon(
                      isVideoOn ? Icons.videocam_outlined : Icons.videocam_off,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isVideoOn
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      foregroundColor: isVideoOn
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: const ReaidyLogo(),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                    (Theme.of(context).progressIndicatorTheme.linearMinHeight ??
                            6) *
                        3),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: BlocBuilder(
                      bloc: Injector.createInterviewBloc,
                      builder: (context, state) {
                        final response = state is CreatedInterviewState
                            ? (state.interviewResponse.lastOrNull ??
                                state.interviewResponse.first)
                            : null;
                        return LinearProgressIndicator(
                          value: (response?.index ?? 0) /
                              (response?.totalQuestions ?? 1),
                        );
                      }),
                ),
              ),
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocConsumer<CreateInterviewBloc, InterviewState>(
                        bloc: Injector.createInterviewBloc,
                        listener: (_, state) {
                          Future.delayed(Duration(seconds: 1), () {
                            if (state is CreatedInterviewState &&
                                (state.interviewResponse
                                    .where((element) => element.response
                                        .contains("interviewDoneSuccessfully"))
                                    .isNotEmpty)) {
                              print("hello");
                              Injector.createInterviewBloc.add(
                                  FinishInterviewEvent(
                                      interviewId: state
                                          .interviewResponse.last.interviewId));
                              Navigator.of(context).popUntil(
                                ModalRoute.withName('/home'),
                              );
                            } else {
                              if (scrollController.position.maxScrollExtent >
                                  scrollController.position.pixels) {
                                print(
                                    "${scrollController.position.maxScrollExtent}, ${scrollController.position.pixels}");
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                );
                              }
                            }
                          });
                        },
                        builder: (context, state) {
                          print("rebuilding");

                          return state is CreatedInterviewState
                              ? ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InterviewConversationBlock(
                                      response: state.interviewResponse[index],
                                      isUser: state
                                              .interviewResponse[index].role
                                              .toLowerCase() !=
                                          "assistant",
                                      isUserTranscribing: false,
                                    );
                                  },
                                  separatorBuilder: (context, _) =>
                                      const SizedBox(
                                        height: 24,
                                      ),
                                  itemCount: state.interviewResponse.length)
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        }),
                    SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InterviewConversationBlock extends StatelessWidget {
  const InterviewConversationBlock({
    super.key,
    required this.response,
    required this.isUser,
    required this.isUserTranscribing,
  });

  final InterviewResponse response;
  final bool isUser;
  final bool isUserTranscribing;

  @override
  Widget build(BuildContext context) {
    final animationKey = GlobalKey<AnimatedListState>();
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isUser
                ? const SizedBox()
                : ClipOval(
                    child: Container(
                      color: const Color(0x50FF725E),
                      child: SvgPicture.network(
                        "https://storyset.com/images/hello-pana.svg",
                        height: 64,
                        width: 64,
                      ),
                    ),
                  ),
            isUser
                ? const SizedBox()
                : const SizedBox(
                    width: 24,
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isUser ? response.interviewee : "Lucy Muchlongername",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    isUser
                        ? const SizedBox()
                        : Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  response.role.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            isUser
                ? const SizedBox(
                    width: 24,
                  )
                : const SizedBox(),
            !isUser
                ? const SizedBox()
                : ClipOval(
                    child: Container(
                      color: const Color(0x50FF725E),
                      child: Transform.flip(
                        flipX: isUser,
                        child: SvgPicture.network(
                          "https://storyset.com/images/hello-pana.svg",
                          height: 64,
                          width: 64,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        isUser & isUserTranscribing
            ? ListeningUserResponse(
                animationKey: animationKey,
              )
            : isUserTranscribing & !isUser
                ? LinearProgressIndicator()
                : Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      response.response.split("interviewDoneSuccessfully")[0],
                      textAlign: isUser ? TextAlign.right : TextAlign.start,
                    ),
                  )
      ],
    );
  }
}

class ListeningUserResponse extends StatelessWidget {
  final GlobalKey<AnimatedListState> animationKey;
  const ListeningUserResponse({super.key, required this.animationKey});

  addItem(context, length) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (length == 11) {
        animationKey.currentState
            ?.removeItem(0, (context, animation) => const SizedBox());
        addItem(context, length + 1);
      } else {
        animationKey.currentState?.insertItem(0);
        addItem(context, length + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    addItem(context, 0);
    return SizedBox(
      height: 48,
      child: AnimatedList(
        reverse: true,
        key: animationKey,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index, animation) {
          final verticalPadding = (Random().nextDouble() * 24);
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: verticalPadding >= 20 ? 6 : verticalPadding),
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4)),
            ),
          );
        },
      ),
    );
  }
}
