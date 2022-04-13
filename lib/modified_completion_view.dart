import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:survey_kit/src/result/step/completion_step_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/completion_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

import 'modified_completion_step.dart';

class ModifiedCompletionView extends StatelessWidget {
  final ModifiedCompletionStep modifiedCompletionStep;
  final DateTime _startDate = DateTime.now();

  ModifiedCompletionView({required this.modifiedCompletionStep});

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: modifiedCompletionStep,
      resultFunction: () => CompletionStepResult(
        modifiedCompletionStep.stepIdentifier,
        _startDate,
        DateTime.now(),
      ),
      title: Text(modifiedCompletionStep.title,
          style: Theme.of(context).textTheme.headline2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
          children: [
            Text(
              modifiedCompletionStep.text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Container(
                width: 150.0,
                height: 150.0,
                child: Lottie.asset(
                  'assets/fancy_checkmark.json',
                  package: 'survey_kit',
                  repeat: false,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
