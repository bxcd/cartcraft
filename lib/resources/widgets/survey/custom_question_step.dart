import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/result/question/text_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/answer_format_not_defined_exception.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/survey_kit.dart';

import 'custom_text_answer_format.dart';
import 'custom_text_answer_view.dart';

@JsonSerializable()
class CustomQuestionStep extends QuestionStep {
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String text;
  @JsonKey(ignore: true)
  final Widget content;
  final AnswerFormat answerFormat;

  CustomQuestionStep({
    bool isOptional = false,
    String buttonText = 'Next',
    StepIdentifier stepIdentifier,
    bool showAppBar = true,
    this.title = '',
    this.text = '',
    this.content = const SizedBox.shrink(),
    this.answerFormat,
  }) : super(
    stepIdentifier: stepIdentifier,
    isOptional: isOptional,
    buttonText: buttonText,
    showAppBar: showAppBar,
    answerFormat: answerFormat,
    title: title,
    text: text,
    content: content,
  );

  @override
  Widget createView({QuestionResult questionResult}) {
    final key = ObjectKey(this.stepIdentifier.id);

    switch (answerFormat.runtimeType) {
      case CustomTextAnswerFormat:
        return CustomTextAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as TextQuestionResult,
        );
      default:
        throw AnswerFormatNotDefinedException();
    }
  }
}
