import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/predefined_steps/completion_step.dart';

import 'custom_completion_view.dart';

@JsonSerializable()
class CustomCompletionStep extends CompletionStep {
  final String title;
  final String text;

  CustomCompletionStep({
    bool isOptional = false,
    StepIdentifier stepIdentifier,
    String buttonText = 'End Survey',
    bool showAppBar = true,
    this.title,
    this.text,
  }) : super(
          isOptional: isOptional,
          stepIdentifier: stepIdentifier,
          buttonText: buttonText,
          showAppBar: showAppBar,
          title: title,
          text: text,
        );

  @override
  Widget createView({QuestionResult questionResult}) {
    return CustomCompletionView(customCompletionStep: this,);
  }

  bool operator ==(o) =>
      super == (o) && o is CustomCompletionStep && o.title == title && o.text == text;
  int get hashCode => super.hashCode ^ title.hashCode ^ text.hashCode;
}
