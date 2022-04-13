import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/views/completion_view.dart';
import 'package:survey_kit/src/steps/predefined_steps/completion_step.dart';
import '/ModifiedCompletionView.java';

@JsonSerializable()
class ModifiedCompletionStep extends CompletionStep {
  final String title;
  final String text;

  ModifiedCompletionStep({
    bool isOptional = false,
    required StepIdentifier stepIdentifier,
    String buttonText = 'End Survey',
    bool showAppBar = true,
    required this.title,
    required this.text,
  }) : super(
          isOptional: isOptional,
          stepIdentifier: stepIdentifier,
          buttonText: buttonText,
          showAppBar: showAppBar,
          title: title,
          text: text,
        );

  @override
  Widget createView({required QuestionResult? questionResult}) {
    return ModifiedCompletionView(completionStep: this);
  }

  bool operator ==(o) =>
      super == (o) && o is ModifiedCompletionStep && o.title == title && o.text == text;
  int get hashCode => super.hashCode ^ title.hashCode ^ text.hashCode;
}
