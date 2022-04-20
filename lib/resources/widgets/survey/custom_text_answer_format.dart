import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/survey_kit.dart';

@JsonSerializable()
class CustomTextAnswerFormat extends TextAnswerFormat {
  final int maxLines;
  @JsonKey(defaultValue: '')
  final String hint;

  /// Regular expression by which the text gets validated
  ///  e.g '^(?!\s*$).+' checks if the entered text is empty
  final String validationRegEx;

  const CustomTextAnswerFormat({
    this.maxLines,
    this.hint = '',
    this.validationRegEx,
  }) : super();
}
