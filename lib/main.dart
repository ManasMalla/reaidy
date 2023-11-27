import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reaidy/color_schemes.g.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:reaidy/presentation/layouts/course_content_page.dart';
import 'package:reaidy/presentation/layouts/home_page.dart';
import 'package:reaidy/presentation/layouts/progressing_interview_page.dart';
import 'package:reaidy/presentation/layouts/splash_page.dart';
import 'package:reaidy/presentation/layouts/view_course_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Injector.authBloc,
        ),
        BlocProvider(
          create: (context) => Injector.interviewBloc,
        ),
        BlocProvider(
          create: (context) => Injector.coursesBloc,
        ),
        BlocProvider(
          create: (context) => Injector.paymentBloc,
        ),
        BlocProvider(
          create: (context) => Injector.createInterviewBloc,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (dynamicLightColorScheme, dynamicDarkColorScheme) {
      return MaterialApp(
        title: 'Reaidy',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: dynamicLightColorScheme ?? lightColorScheme,
          textTheme: GoogleFonts.dmSansTextTheme(),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: dynamicDarkColorScheme ?? darkColorScheme,
          textTheme: GoogleFonts.dmSansTextTheme(),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/home': (context) => const HomePage(),
          '/view-course': (context) => const ViewCoursePage(),
          '/course-content': (context) => const CourseContentPage(),
          '/interview': (context) => const ProgressingInterviewPage(),
        },
      );
    });
  }
}
