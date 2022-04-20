import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/views/decoration/input_decoration.dart';
import 'package:survey_kit/src/result/question/text_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';
import 'package:survey_kit/survey_kit.dart';

import 'custom_text_answer_format.dart';

class CustomTextAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final TextQuestionResult result;

  const CustomTextAnswerView({
    Key key,
    this.questionStep,
    this.result,
  }) : super(key: key);

  @override
  _CustomTextAnswerViewState createState() => _CustomTextAnswerViewState();
}

class _CustomTextAnswerViewState extends State<CustomTextAnswerView> {
  CustomTextAnswerFormat _textAnswerFormat;
  DateTime _startDate;

  TextEditingController _controller;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.result?.result ?? '';
    _textAnswerFormat = widget.questionStep.answerFormat as CustomTextAnswerFormat;
    _checkValidation(_controller.text);
    _startDate = DateTime.now();
  }

  void _checkValidation(String text) {
    setState(() {
      if (_textAnswerFormat.validationRegEx != null) {
        RegExp regExp = RegExp(_textAnswerFormat.validationRegEx);
        _isValid = regExp.hasMatch(text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () => TextQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: _controller.text,
        result: _controller.text,
      ),
      title: widget.questionStep.title.isNotEmpty
          ? Text(
        widget.questionStep.title,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      )
          : widget.questionStep.content,
      isValid: _isValid || widget.questionStep.isOptional,
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.only(bottom: 32.0, left: 14.0, right: 14.0),
            child: Text(
              widget.questionStep.text,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: _textAnswerFormat.height,
            color: Theme.of(context).textTheme.bodyText1.color,
            child: TextField(
              decoration: textFieldInputDecoration(
                hint: _textAnswerFormat.hint,
              ),
              minLines: 1,
              maxLines: _textAnswerFormat.maxLines,
              controller: _controller,
              style: TextStyle(
                color: Theme.of(context).backgroundColor,
                fontStyle: Theme.of(context).textTheme.bodyText1.fontStyle,
              ),
              textAlign: TextAlign.center,
              onChanged: (String text) {
                _checkValidation(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
