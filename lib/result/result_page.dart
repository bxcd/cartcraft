import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

import '../home/home_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.title, required this.result}) :
        super(key: key);

  // This widget is the result page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final SurveyResult result;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    void _navigateToHomePage() {
      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(title: 'Code Dart')));
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.black87,
        // Here we take the value from the MyResultPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: OrientationBuilder(
      builder: (context, orientation) =>
        Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SingleChildScrollView(
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                Container(
                  child: Image.asset(
                    'assets/codedart-icon.png',
                    height: 175.0,
                    fit: BoxFit.none,
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                Text(
                  'Your recommendations:\n',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Padding(
                   padding: const EdgeInsets.symmetric(vertical: 24.0),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(150.0, 60.0),
                    ),
                    side: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                        if (state.contains(MaterialState.disabled)) {
                          return const BorderSide(
                            color: Colors.white,
                          );
                        }
                        return const BorderSide(
                          color: Colors.red,
                        );
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    textStyle: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                        if (state.contains(MaterialState.disabled)) {
                          return Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(
                            color: Colors.red,
                          );
                        }
                        return Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                  onPressed:  _navigateToHomePage,
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    child: const Text(
                      'LEARN',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  List<String> _generateRecommendations(SurveyResult r) {
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
