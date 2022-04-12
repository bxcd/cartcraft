import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:survey_kit/survey_kit.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CartCraft',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Code Dart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black87,
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder<Task>(
              future: getSampleTask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  final task = snapshot.data!;
                  return SurveyKit(
                    onResult: (SurveyResult result) {
                      if (kDebugMode) {
                        print(result.finishReason);
                      }
                    },
                    task: task,
                    showProgress: true,
                    localizations: const {
                      'cancel': 'Cancel',
                      'next': 'Next',
                    },
                    themeData: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch(
                        primarySwatch: Colors.red,
                      ).copyWith(
                        onPrimary: Colors.black87,
                      ),
                      primaryColor: Colors.red,
                      backgroundColor: Colors.white,
                      appBarTheme: const AppBarTheme(
                        color: Colors.black26,
                        iconTheme: IconThemeData(
                          color: Colors.red,
                        ),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      iconTheme: const IconThemeData(
                        color: Colors.red,
                      ),
                      textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: Colors.red,
                        selectionColor: Colors.red,
                        selectionHandleColor: Colors.red,
                      ),
                      cupertinoOverrideTheme: const CupertinoThemeData(
                        primaryColor: Colors.red,
                      ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            const Size(150.0, 60.0),
                          ),
                          side: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return const BorderSide(
                                  color: Colors.white,
                                );
                              }
                              return const BorderSide(
                                color: Colors.red,
                              );
                            },
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                  color: Colors.white,
                                );
                              }
                              return Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            Theme.of(context).textTheme.button?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      textTheme: const TextTheme(
                        headline2: TextStyle(
                          fontSize: 28.0,
                          color: Colors.red,
                        ),
                        headline5: TextStyle(
                          fontSize: 24.0,
                          color: Colors.red,
                        ),
                        bodyText2: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                        subtitle1: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    surveyProgressbarConfiguration: SurveyProgressConfiguration(
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return const CircularProgressIndicator.adaptive();
              },
            ),
          ),
        ),
      ),
    );

  Future<Task> getSampleTask() {
    var task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: 'Service Matcher',
          text: 'Get service recommendations from Code Dart\nby submitting a brief form.\n\nAll responses are optional\nand your information is kept anonymous.',
          buttonText: 'Start',
        ),
        QuestionStep(
          title: 'Business Area',
          text: 'What aspect of your business can be improved?',
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Systems', value: 'systems'),
              TextChoice(text: 'Software', value: 'software'),
              TextChoice(text: 'Web', value: 'web'),
              TextChoice(text: 'Products', value: 'products'),
              TextChoice(text: 'Processes', value: 'processes'),
              TextChoice(text: 'Branding', value: 'branding'),
              TextChoice(text: 'Communications', value: 'communications'),
              TextChoice(text: 'Controls', value: 'controls'),
              TextChoice(text: 'Strategy', value: 'strategy'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Function Area',
          text: 'What aspect of your software can be improved?',
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'App development', value: 'systems'),
              TextChoice(text: 'UX design', value: 'software'),
              TextChoice(text: 'Graphic design', value: 'web'),
              TextChoice(text: 'Content production', value: 'products'),
            ],
          ),
        )
      ],
    );
    return Future.value(task);
  }
}
