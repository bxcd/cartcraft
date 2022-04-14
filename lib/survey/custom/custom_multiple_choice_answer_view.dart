import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_choice.dart';
import 'package:survey_kit/src/views/widget/selection_list_tile.dart';
import 'package:survey_kit/src/result/question/multiple_choice_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

import 'custom_question_step.dart';

class CustomMultipleChoiceAnswerView extends StatefulWidget {
  final CustomQuestionStep customQuestionStep;
  final MultipleChoiceQuestionResult? result;

  const CustomMultipleChoiceAnswerView({
    Key? key,
    required this.customQuestionStep,
    required this.result,
  }) : super(key: key);

  @override
  _MultipleChoiceAnswerView createState() => _MultipleChoiceAnswerView();
}

class _MultipleChoiceAnswerView extends State<CustomMultipleChoiceAnswerView> {
  late final DateTime _startDateTime;
  late final MultipleChoiceAnswerFormat _multipleChoiceAnswer;

  List<TextChoice> _selectedChoices = [];

  @override
  void initState() {
    super.initState();
    _multipleChoiceAnswer =
    widget.customQuestionStep.answerFormat as MultipleChoiceAnswerFormat;
    _selectedChoices =
        widget.result?.result ?? _multipleChoiceAnswer.defaultSelection;
    _startDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.customQuestionStep,
      resultFunction: () => MultipleChoiceQuestionResult(
        id: widget.customQuestionStep.stepIdentifier,
        startDate: _startDateTime,
        endDate: DateTime.now(),
        valueIdentifier:
        _selectedChoices.map((choices) => choices.value).join(','),
        result: _selectedChoices,
      ),
      isValid: widget.customQuestionStep.isOptional || _selectedChoices.isNotEmpty,
      title: widget.customQuestionStep.title.isNotEmpty
          ? Text(
        widget.customQuestionStep.selection,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      )
          : widget.customQuestionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                widget.customQuestionStep.text + " for " + widget.customQuestionStep.selection + "?",
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey,
                ),
                ..._multipleChoiceAnswer.textChoices
                    .map(
                      (TextChoice tc) => SelectionListTile(
                    text: tc.text,
                    onTap: () {
                      setState(
                            () {
                          if (_selectedChoices.contains(tc)) {
                            _selectedChoices.remove(tc);
                          } else {
                            _selectedChoices = [..._selectedChoices, tc];
                          }
                        },
                      );
                    },
                    isSelected: _selectedChoices.contains(tc),
                  ),
                )
                    .toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
