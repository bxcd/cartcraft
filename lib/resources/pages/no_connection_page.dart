//  StoreMob
//
//  Created by Anthony Gordon.
//  2022, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:cartcraft/bootstrap/app_helper.dart';
import 'package:cartcraft/bootstrap/helpers.dart';
import 'package:cartcraft/resources/widgets/buttons.dart';
import 'package:cartcraft/resources/widgets/safearea_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class NoConnectionPage extends StatefulWidget {
  NoConnectionPage();

  @override
  _NoConnectionPageState createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  _NoConnectionPageState();

  @override
  void initState() {
    super.initState();
    if (getEnv('APP_DEBUG') == true) {
      NyLogger.error('WooCommerce site is not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.get(context).background,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Code Dart"),
      ),
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.black54,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  trans("Oops, something went wrong\n\nCheck your connection and try again"),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
              LinkButton(title: trans("Retry"), action: _retry),
            ],
          ),
        ),
      ),
    );
  }

  _retry() async {
    WooSignalApp wooSignalApp = await appWooSignal((api) => api.getApp());

    if (wooSignalApp == null) {
      showToastNotification(context,
          title: trans("Oops"), description: trans("Retry later"));
      return;
    }

    AppHelper.instance.appConfig = wooSignalApp;
    Navigator.pushNamed(context, "/home");
  }
}
