import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cartcraft/bootstrap/helpers.dart';
import 'package:cartcraft/resources/widgets/app_loader_widget.dart';
import 'package:cartcraft/resources/widgets/survey/custom_text_answer_format.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:woosignal/models/response/products.dart' as ws_product;

import '../../../app/controllers/product_loader_controller.dart';
import '../../widgets/survey/custom_completion_step.dart';
import '../../widgets/survey/custom_question_step.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  bool _isLoading = true;

  final ProductLoaderController _productLoaderController =
  ProductLoaderController();

  @override
  void initState() {
    super.initState();
    _home();
  }

  _home() async {
    await fetchProducts();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ws_product.Product> products = _productLoaderController.getResults();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(trans("Survey")),
      ),
      body: SafeArea(
        child: _isLoading
          ? AppLoaderWidget()
          : FutureBuilder<Task>(
            future: getSampleTask(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                final task = snapshot.data;
                return SurveyKit(
                  onResult: (SurveyResult r) async {
                    if (kDebugMode) {
                      print(r.finishReason);
                      await saveRecommendations(r, products);
                      _actionWishlist();
                      shareFeedback(r);
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

  int currentSelectionIndex = 0; // Updated each time Q2 is completed for a Q1 input
  bool offerRequested = false;
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
          stepIdentifier: StepIdentifier(id: '0'),
          title: getStepTitle(0),
          text: getStepText(0),
          buttonText: 'Start',
        ),
        QuestionStep(
          stepIdentifier: StepIdentifier(id: '1'),
          title: getStepTitle(1),
          text: getStepText(1),
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
          stepIdentifier: StepIdentifier(id: '2'),
          title: getStepTitle(2),
          text: getStepText(2),
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
        QuestionStep(
          stepIdentifier: StepIdentifier(id: '3'),
          title: getStepTitle(3),
          text: getStepText(3),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Usability', value: 'usability'),
              TextChoice(text: 'Quality', value: 'quality'),
              TextChoice(text: 'Appeal', value: 'appeal'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          stepIdentifier: StepIdentifier(id: '4'),
          title: getStepTitle(4),
          text: getStepText(4),
          isOptional: true,
          answerFormat: const MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Branding', value: 'branding'),
              TextChoice(text: 'Sourcing', value: 'logistics'),
              TextChoice(text: 'Outreach', value: 'outreach'),
              TextChoice(text: 'Other', value: 'other'),
            ],
          ),
        ),
        QuestionStep(
          stepIdentifier: StepIdentifier(id: '5'),
          title: getStepTitle(5),
          text: getStepText(5),
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
          stepIdentifier: StepIdentifier(id: '6'),
          title: getStepTitle(6),
          text: getStepText(6),
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
          stepIdentifier: StepIdentifier(id: '7'),
          title: getStepTitle(7),
          text: getStepText(7),
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
          stepIdentifier: StepIdentifier(id: '8'),
          title: getStepTitle(8),
          text: getStepText(8),
          isOptional: true,
          answerFormat: DateAnswerFormat(
              minDate: DateTime.utc(1970),
              defaultDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 365 * 10))
          ),
        ),
        QuestionStep(
          stepIdentifier: StepIdentifier(id: '9'),
          title: getStepTitle(9),
          text: getStepText(9),
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
          stepIdentifier: StepIdentifier(id: '10'),
          title: getStepTitle(10),
          text: getStepText(10),
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
          stepIdentifier: StepIdentifier(id: '11'),
          title: getStepTitle(11),
          text: getStepText(11),
          isOptional: true,
          answerFormat: const CustomTextAnswerFormat(
              maxLines: 20,
              height: 200,
              hint: 'Type your comments here...'
          ),
        ),
        CustomQuestionStep(
          stepIdentifier: StepIdentifier(id: '12'),
          title: getStepTitle(12),
          text: getStepText(12),
          isOptional: true,
          answerFormat: const CustomTextAnswerFormat(
            hint: 'your@email.address',
            maxLines: 1,
          ),
        ),
        QuestionStep(
          stepIdentifier: StepIdentifier(id: '13'),
          title: getStepTitle(13),
          text: getStepText(13),
          answerFormat: const TimeAnswerFormat(
            defaultValue: TimeOfDay(
              hour: 12,
              minute: 0,
            ),
          ),
        ),
        CustomCompletionStep(
          stepIdentifier: StepIdentifier(id: '14'),
          title: getStepTitle(14),
          text: getStepText(14) + formatOfferText(offerRequested),
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
              offerRequested = true;
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

  _actionWishlist() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/wishlist");
  }

  Future fetchProducts() async {
    await _productLoaderController.loadProducts(
        hasResults: (result) { return result; },
        didFinish: () => setState(() {}));
  }
}
