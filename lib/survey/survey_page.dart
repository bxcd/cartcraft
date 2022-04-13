import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:survey_kit/survey_kit.dart';

import 'custom/custom_completion_step.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SurveyPageState createState() => _SurveyPageState();
}


class _SurveyPageState extends State<SurveyPage> {
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

  // var inputLastCompleted; // Updated each time Q2 is completed for a Q1 input
  // var inputMap; // maps each Q1 input to corresponding Q2 selections
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
          title: 'Business Aspects',
          text: 'What aspects of your business can be improved?',
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
        // General placeholder to Q2s customized for each input in Q1
        QuestionStep(
          title: 'Selection  Aspects',
          text: 'What aspects of your selections can be improved?',
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'App development', value: 'app'),
              TextChoice(text: 'UX design', value: 'ux'),
              TextChoice(text: 'Graphic design', value: 'graphics'),
              TextChoice(text: 'Content production', value: 'content'),
              TextChoice(text: 'Business operations', value: 'business')
            ],
          ),
        ),
        CustomCompletionStep(
          stepIdentifier: StepIdentifier(id: '100'),
          text: 'Your recommendations are being generated.',
          title: 'Thank you',
          buttonText: 'Submit',
        ),
      ],
    );
    task.addNavigationRule(
      forTriggerStepIdentifier: task.steps[3].stepIdentifier,
      navigationRule: DirectNavigationRule(
          task.steps[0].stepIdentifier
      ),
    );
    // Called back the first time Q1 is completed
    // task.addNavigationRule(
    //   forTriggerStepIdentifier: task.steps[].stepIdentifier,
    //   navigationRule: ConditionalNavigationRule(
    //     resultToStepIdentifierMapper: (inputs) {
    //       // for each input in inputs, add input to inputMap
    //       var input = inputs[0]
    //       switch (input) {
    //         case :
    //           return task.steps[].stepIdentifier;
    //         default:
    //           return null;
    //       }
    //     },
    //   ),
    // );
    // Called back each time a Q2 is completed until all inputs from Q1 are cleared
    // task.addNavigationRule(
    //   forTriggerStepIdentifier: task.steps[].stepIdentifier,
    //   navigationRule: ConditionalNavigationRule(
    //     resultToStepIdentifierMapper: (inputs) {
    //     // add inputs to corresponding input in inputMap
    //     // finding index by ++inputLastCompleted (now incremented)
    //     // either go to completion step if no more inputs or
    //     // launch Q2 for next input found in inputMap by inputLastCompleted
    //       switch (input) {
    //         case :
    //           return task.steps[].stepIdentifier;
    //         default:
    //           return null;
    //       }
    //     },
    //   ),
    // );
    return Future.value(task);
  }
}

