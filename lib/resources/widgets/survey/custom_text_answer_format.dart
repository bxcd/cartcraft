import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/survey_kit.dart';

@JsonSerializable()
class CustomTextAnswerFormat implements TextAnswerFormat {
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

  factory CustomTextAnswerFormat.fromJson(Map<String, dynamic> json) =>
      _$CustomTextAnswerFormatFromJson(json);
  Map<String, dynamic> toJson() => _$CustomTextAnswerFormatToJson(this);
}

CustomTextAnswerFormat _$CustomTextAnswerFormatFromJson(Map<String, dynamic> json) {
  return CustomTextAnswerFormat(
    maxLines: json['maxLines'] as int,
    hint: json['hint'] as String ?? '',
    validationRegEx: json['validationRegEx'] as String,
  );
}

Map<String, dynamic> _$CustomTextAnswerFormatToJson(CustomTextAnswerFormat instance) =>
    <String, dynamic>{
      'maxLines': instance.maxLines,
      'hint': instance.hint,
      'validationRegEx': instance.validationRegEx,
    };
