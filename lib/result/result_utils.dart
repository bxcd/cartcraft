import 'package:survey_kit/survey_kit.dart';

class ResultUtils {

  static List<String> generateRecommendations(SurveyResult r) {
    List<String> s1ResultStrings = List.generate(1, (index) => "");
    List<String> s2ResultStrings = List.generate(1, (index) => "");
    List<List<String>> s2ResultStringsList = List.generate(1, (index) => s2ResultStrings);
    List<StepResult> sResults = r.results;
    for (int i = 0; i < sResults.length; i++) {
      List<QuestionResult> qResults = sResults[i].results;
      for (int j = 0; j < qResults.length; j++) {
        if (j != 0) { break; }
        else if (i == 0) { continue; }
        else if (i < 7) {
          String? qResultString = qResults[j].valueIdentifier;
          if (qResultString != null) {
            List<String> qResultStrings = qResultString.split(',');
            if (i == 1) { s1ResultStrings.addAll(qResultStrings); }
            else { s2ResultStringsList.add(qResultStrings); }
          }
        }
      }
    }
    List<String> recommendations = List.generate(1, (index) => ',');
    for (int i = 0; i < s1ResultStrings.length; i++) {
      String s1ResultString = s1ResultStrings[i];
      for (int j = 0; j < s2ResultStringsList[i].length; j++) {
        String s2ResultString = s2ResultStringsList[i][j];
        switch (s1ResultString) {
          case "tech":
            switch (s2ResultString) {
              case "systems": break;
              case "software": break;
              case "website": break;
              case "other": break;
            } break;
          case "product":
            switch (s2ResultString) {
              case "usability": break;
              case "appeal": break;
              case "conversion": break;
              case "other": break;
            } break;
          case "business":
            switch (s2ResultString) {
              case "performance": break;
              case "continuity": break;
              case "integration": break;
              case "other": break;
            } break;
          case "graphics":
            switch (s2ResultString) {
              case "logo": break;
              case "illustration": break;
              case "collateral": break;
              case "other": break;
            } break;
          case "content":
            switch (s2ResultString) {
              case "writing": break;
              case "audio": break;
              case "video": break;
              case "other": break;
            } break;
          default:
            break;
        }
      }
    }
    return recommendations;
  }
}