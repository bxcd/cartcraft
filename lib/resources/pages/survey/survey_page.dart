import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/survey/custom_text_answer_format.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:survey_kit/survey_kit.dart';

import '../../widgets/survey/custom_completion_step.dart';
import '../../widgets/survey/custom_question_step.dart';
import '../survey/result_page.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

// TODO:
class _SurveyPageState extends State<SurveyPage> {
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(trans("Survey")),
      ),
      body: SafeArea(
        child: FutureBuilder<Task>(
          future: getSampleTask(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              final task = snapshot.data;
              return SurveyKit(
                onResult: (SurveyResult r) {
                  if (kDebugMode) {
                    print(r.finishReason);
                    setState(() {
                      // This call to setState tells the Flutter framework that something has
                      // changed in this State, which causes it to rerun the build method below
                      // so that the display can reflect the updated values. If we changed
                      // _counter without calling setState(), then the build method would not be
                      // called again, and so nothing would appear to happen.
                      Navigator.of(context).pop();
                      // launch result page passing r argument
                      // move/handle _generateRecommendations from result page
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResultPage(result: r)));
                    });
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
                    brightness: Theme.of(context).brightness,
                  ),
                  hintColor: Theme.of(context).backgroundColor,
                  primaryColor: Colors.red.shade500,
                  appBarTheme: AppBarTheme(
                      backgroundColor: Theme.of(context).backgroundColor,
                      elevation: 0,
                      iconTheme: IconThemeData(
                        color: Colors.red,
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        const Size(150.0, 60.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
    );
  }

  static String formatText(String s) { return "What aspects of your " + s + " can be improved?"; }
  int currentSelectionIndex = 0; // Updated each time Q2 is completed for a Q1 input
  List<String> selections = List.generate(1, (index) => "");
  static const List<String> areaSteps = [
    'tech',
    'product',
    'business',
    'graphics',
    'content',
    'other',
  ];
  Future<Task> getSampleTask() {
    var task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: '',
          text: 'Get service recommendations from Code Dart\nby submitting a brief form.\n\n\n\nAll responses are optional\nand your information is kept anonymous.\n\n',
          buttonText: 'Start',
        ),
        QuestionStep(
          title: 'Business Aspects',
          text: 'What aspects of your business can be improved?',
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Tech development', value: 'tech'),
              TextChoice(text: 'Product design', value: 'product'),
              TextChoice(text: 'Business operations', value: 'business'),
              TextChoice(text: 'Graphic design', value: 'graphics'),
              TextChoice(text: 'Content production', value: 'content'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        // One question step for each possible input in QuestionStep1
        QuestionStep(
          title: 'Tech Development Aspects',
          text: formatText('tech development'),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Systems', value: 'systems'),
              TextChoice(text: 'Software', value: 'software'),
              TextChoice(text: 'Website', value: 'website'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(title: 'Product Design Aspects',
          text: formatText('product design'),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Logistics', value: 'logistics'),
              TextChoice(text: 'Usability', value: 'usability'),
              TextChoice(text: 'Appeal', value: 'appeal'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Business Operations Aspects',
          text: formatText('processes'),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Performance', value: 'performance'),
              TextChoice(text: 'Conversion', value: 'conversion'),
              TextChoice(text: 'Branding', value: 'branding'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Graphic Design Aspects',
          text: formatText('graphic design'),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Logo', value: 'logo'),
              TextChoice(text: 'Illustration', value: 'illustration'),
              TextChoice(text: 'Collateral', value: 'collateral'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Content Production Aspects',
          text: formatText('content production'),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Writing', value: 'writing'),
              TextChoice(text: 'Audio', value: 'audio'),
              TextChoice(text: 'Video', value: 'video'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Special offer',
          text: 'Are you willing to answer more detailed questions to receive a special offer?\nYour responses will not be shared with third-parties.',
          isOptional: true,
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Yes', value: 'yes'),
              TextChoice(text: 'No', value: 'no'),
            ],
            defaultSelection: TextChoice(text: 'No', value: 'no'),
          ),
        ),
        QuestionStep(
          title: 'Project Timeline',
          text: 'Has your project set a target completion date?\nCode Dart offers focused, expedited service to help you stay ahead.',
          isOptional: true,
          answerFormat: DateAnswerFormat(
              minDate: DateTime.utc(1970),
              defaultDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 365 * 10))
          ),
        ),
        QuestionStep(
          title: 'Project Cost',
          text: 'Has your project set a target cost?\nCode Dart offers flexible package and bundle options to help you keep costs under control.',
          isOptional: true,
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: '\$0 to \$1,000', value: '0'),
              TextChoice(text: '\$1,000 to \$2,500', value: '1000'),
              TextChoice(text: '\$2,500 to \$10,000', value: '2500'),
              TextChoice(text: '\$10,000 to \$25,000', value: '10000'),
              TextChoice(text: '\$25,000 to \$100,000', value: '25000'),
              TextChoice(text: 'Over \$100,000', value: '100000'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Speed vs. Savings',
          text: 'Rate your preference between cost savings and completion speed.',
          isOptional: true,
          answerFormat: const ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 3,
            minimumValueDescription: 'Cost',
            maximumValueDescription: 'Speed',
          ),
        ),
        CustomQuestionStep(
          title: 'Additional Details',
          text:
          'What other aspects of your project are important and how can they be addressed or improved?',
          isOptional: true,
          answerFormat: const CustomTextAnswerFormat(
            maxLines: 20,
            height: 200,
            hint: 'Type your comments here...'
          ),
        ),
        CustomQuestionStep(
          title: 'Email address',
          text:
          'What is an email address where your offer can be delivered?\nNote: Your offer cannot be delivered without a valid email address.',
          isOptional: true,
          answerFormat: const CustomTextAnswerFormat(
            hint: 'your@email.address',
            maxLines: 1,
          ),
        ),
        QuestionStep(
          title: 'Contact time',
          text: 'What is the best time of day to contact you with your offer.',
          answerFormat: const TimeAnswerFormat(
            defaultValue: TimeOfDay(
              hour: 12,
              minute: 0,
            ),
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
      forTriggerStepIdentifier: task.steps[7].stepIdentifier,
      navigationRule: ConditionalNavigationRule(
        resultToStepIdentifierMapper: (input) {
          switch (input) {
            case 'yes':
              return task.steps[8].stepIdentifier;
            default:
              return task.steps[14].stepIdentifier;
          }
        },
      ),
    );
    // Called back the first time Q1 is completed
    task.addNavigationRule(
      forTriggerStepIdentifier: task.steps[1].stepIdentifier,
      navigationRule: ConditionalNavigationRule(
          resultToStepIdentifierMapper: (input) {
            if (input != null && input.isNotEmpty) {
              selections = input.split(',');
              int nextIndex = 2 + areaSteps.indexOf(selections[0]);
              return task.steps[nextIndex].stepIdentifier;
            } return task.steps[7].stepIdentifier;
          }
      ),
    );
    // Called back each time a Q2 is completed until all inputs from Q1 are cleared
    for (int i = 2; i < 7; i++) {
      task.addNavigationRule(
        forTriggerStepIdentifier: task.steps[i].stepIdentifier,
        navigationRule: ConditionalNavigationRule(
          resultToStepIdentifierMapper: (inputs) {
            print(currentSelectionIndex);
            print(selections.length);
            if (selections.length > currentSelectionIndex + 1) {
              currentSelectionIndex++;
              int nextIndex = 2 +
                  areaSteps.indexOf(selections[currentSelectionIndex]);
              return task.steps[nextIndex].stepIdentifier;
            }
            currentSelectionIndex = 0;
            return task.steps[7].stepIdentifier;
          },
        ),
      );
    }
    return Future.value(task);
  }

}
