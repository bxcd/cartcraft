import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/answer_format/boolean_answer_format.dart';
import 'package:survey_kit/src/answer_format/date_answer_format.dart';
import 'package:survey_kit/src/answer_format/integer_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/answer_format/single_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_answer_format.dart';
import 'package:survey_kit/src/answer_format/time_answer_formart.dart';
import 'package:survey_kit/src/result/question/boolean_question_result.dart';
import 'package:survey_kit/src/result/question/date_question_result.dart';
import 'package:survey_kit/src/result/question/integer_question_result.dart';
import 'package:survey_kit/src/result/question/multiple_choice_question_result.dart';
import 'package:survey_kit/src/result/question/scale_question_result.dart';
import 'package:survey_kit/src/result/question/single_choice_question_result.dart';
import 'package:survey_kit/src/result/question/text_question_result.dart';
import 'package:survey_kit/src/result/question/time_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/answer_format_not_defined_exception.dart';
import 'package:survey_kit/src/views/boolean_answer_view.dart';
import 'package:survey_kit/src/views/date_answer_view.dart';
import 'package:survey_kit/src/views/integer_answer_view.dart';
import 'package:survey_kit/src/views/multiple_choice_answer_view.dart';
import 'package:survey_kit/src/views/scale_answer_view.dart';
import 'package:survey_kit/src/views/single_choice_answer_view.dart';
import 'package:survey_kit/src/views/text_answer_view.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/views/time_answer_view.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';

import 'custom_multiple_choice_answer_view.dart';


@JsonSerializable()
class CustomQuestionStep extends QuestionStep {
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String text;
  @JsonKey(ignore: true)
  final Widget content;
  final AnswerFormat answerFormat;
  String selection;

  CustomQuestionStep({
    bool isOptional = false,
    String buttonText = 'Next',
    StepIdentifier? stepIdentifier,
    bool showAppBar = true,
    this.title = '',
    this.text = '',
    this.content = const SizedBox.shrink(),
    required this.answerFormat,
    this.selection = '',
  }) : super(
    isOptional: isOptional,
    buttonText: buttonText,
    stepIdentifier: stepIdentifier,
    showAppBar: showAppBar,
    title: title,
    text: text,
    content: content,
    answerFormat: answerFormat,
  );


  @override
  Widget createView({required QuestionResult? questionResult}) {
    final key = ObjectKey(this.stepIdentifier.id);

    switch (answerFormat.runtimeType) {
      case IntegerAnswerFormat:
        return IntegerAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as IntegerQuestionResult?,
        );
      case TextAnswerFormat:
        return TextAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as TextQuestionResult?,
        );
      case SingleChoiceAnswerFormat:
        return SingleChoiceAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as SingleChoiceQuestionResult?,
        );
      case MultipleChoiceAnswerFormat:
        return CustomMultipleChoiceAnswerView(
          key: key,
          customQuestionStep: this,
          result: questionResult as MultipleChoiceQuestionResult?,
        );
      case ScaleAnswerFormat:
        return ScaleAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as ScaleQuestionResult?,
        );
      case BooleanAnswerFormat:
        return BooleanAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as BooleanQuestionResult?,
        );
      case DateAnswerFormat:
        return DateAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as DateQuestionResult?,
        );
      case TimeAnswerFormat:
        return TimeAnswerView(
          key: key,
          questionStep: this,
          result: questionResult as TimeQuestionResult?,
        );
      default:
        throw AnswerFormatNotDefinedException();
    }
  }
}