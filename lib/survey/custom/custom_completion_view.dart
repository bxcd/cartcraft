import 'package:flutter/material.dart';
import 'package:survey_kit/src/result/step/completion_step_result.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

import 'custom_completion_step.dart';

class CustomCompletionView extends StatelessWidget {
  final CustomCompletionStep customCompletionStep;
  final DateTime _startDate = DateTime.now();

  CustomCompletionView({Key? key, required this.customCompletionStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: customCompletionStep,
      resultFunction: () => CompletionStepResult(
        customCompletionStep.stepIdentifier,
        _startDate,
        DateTime.now(),
      ),
      title: Text(customCompletionStep.title,
          style: Theme.of(context).textTheme.headline2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          children: [
            Text(
              customCompletionStep.text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              // child: Container(
              //   width: 150.0,
              //   height: 150.0,
              //   child: Lottie.asset(
              //     'assets/fancy_checkmark.json',
              //     package: 'survey_kit',
              //     repeat: false,
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
