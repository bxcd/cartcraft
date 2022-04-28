import 'package:flutter/material.dart';
import 'package:cartcraft/bootstrap/app.dart';
import 'package:cartcraft/bootstrap/app_helper.dart';
import 'package:cartcraft/bootstrap/boot.dart';
import 'package:cartcraft/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Nylo nylo = await Nylo.init(router: appRouter(), setup: boot);

  String initialRoute = AppHelper.instance.appConfig.appStatus != null
      ? '/home'
      : '/no-connection';

  runApp(
    AppBuild(
      navigatorKey: nylo.router.navigatorKey,
      onGenerateRoute: nylo.router.generator(),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}
