//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2022, WooSignal Ltd. All rights reserved.
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

//  This file has been modified from its original form by Code Dart.

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cartcraft/app/models/billing_details.dart';
import 'package:cartcraft/app/models/cart.dart';
import 'package:cartcraft/app/models/cart_line_item.dart';
import 'package:cartcraft/app/models/checkout_session.dart';
import 'package:cartcraft/app/models/default_shipping.dart';
import 'package:cartcraft/app/models/payment_type.dart';
import 'package:cartcraft/app/models/user.dart';
import 'package:cartcraft/bootstrap/app_helper.dart';
import 'package:cartcraft/bootstrap/enums/symbol_position_enums.dart';
import 'package:cartcraft/bootstrap/shared_pref/shared_key.dart';
import 'package:cartcraft/config/app_currency.dart';
import 'package:cartcraft/config/app_payment_gateways.dart';
import 'package:cartcraft/config/app_theme.dart';
import 'package:cartcraft/resources/themes/styles/base_styles.dart';
import 'package:cartcraft/resources/widgets/product/no_results_for_products_widget.dart';
import 'package:cartcraft/resources/widgets/woosignal_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:status_alert/status_alert.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:woosignal/woosignal.dart';
import 'package:woosignal/models/response/products.dart';

String getStepTitle(int step) {
  switch (step) {
    case (0): return "";
    case (7): return "Special Offer";
    case (8): return "Project Timeline";
    case (9): return "Project Cost";
    case (10): return "Speed vs. Savings";
    case (11): return "Additional Details";
    case (12): return "Email address";
    case (13): return "Contact Time";
    case (14): return "Thank you";
    default: return getAspect(step) + " Aspect";
  }
}

String getStepText(int step) {
  switch (step) {
    case (0): return "Get service recommendations from Code Dart\nby submitting a brief form.\n\n\n\nAll responses are optional\nand your information is kept anonymous.\n\n";
    case (7): return "Are you willing to answer more detailed questions to receive a special offer?\nYour responses will not be shared with third-parties.";
    case (8): return "Has your project set a target completion date?\nCode Dart offers focused, expedited service to help you stay ahead.";
    case (9): return "Has your project set a target cost?\nCode Dart offers flexible package and bundle options to help you keep costs under control.";
    case (10): return "Rate your preference between cost savings and completion speed.";
    case (11): return "What other aspects of your project are important and how can they be addressed or improved?";
    case (12): return "What is an email address where your offer can be delivered?\nNote: Your offer cannot be delivered without a valid email address.";
    case (13): return "What is the best time of day to contact you with your offer.";
    case (14): return "\n\nTap NEXT to generate your recommendations,\nwhich will appear in your wishlist.\n\n\n\n"
        "if you chose to receive a special offer,\ninclude in the email form any\nother pertinent project details before sending.";
    default: return formatStepText(getStepTitle(step).toLowerCase());
  }
}

String formatStepText(String s) { return "What aspects of your " + s + " can be improved?"; }


String getAspect(int step) {
  switch (step) {
    case (1): return "Company";
    case (2): return "Tech Development";
    case (3): return "Product Design";
    case (4): return "Business Operations";
    case (5): return "Graphic Design";
    case (6): return "Content Production";
    default: return "";
  }
}

Future shareFeedback(SurveyResult r) async {
  String message = "";
  List<StepResult> stepResults = r.results;
  for (int i = 0; i < stepResults.length; i++) {
    List<QuestionResult> questionResults = stepResults[i].results;
    for (int j = 0; j < questionResults.length; j++) {
      String resultStr = questionResults[j].valueIdentifier;
      String titleStr = getStepTitle(int.parse(questionResults[j].id.id));
      message += (titleStr + ": " + resultStr + "\n");
    }
  }
  print(message);
  // TODO: Replace with push to Firebase RT DB or CM
  final Email email = Email(
    body: message,
    subject: 'Survey Feedback',
    recipients: ['info@coded.art'],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}

Future saveRecommendations(SurveyResult r, List<Product> pList) async {
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
        String qResultString = qResults[j].valueIdentifier;
        if (qResultString != null) {
          List<String> qResultStrings = qResultString.split(',');
          if (i == 1) { s1ResultStrings.addAll(qResultStrings); }
          else { s2ResultStringsList.add(qResultStrings); }
        }
      }
    }
  }
  // int daysRemaining; // Determine days remaining from service date
  // int costPerProject; // Determine estimated cost per project
  // int speedOverSavings; // Get speed over savings rating
  for (int i = 0; i < s1ResultStrings.length; i++) {
    String s1ResultString = s1ResultStrings[i];
    for (int j = 0; j < s2ResultStringsList[i].length; j++) {
      String s2ResultString = s2ResultStringsList[i][j];
      switch (s1ResultString) {
        case "tech":
          switch (s2ResultString) {
            // case "systems":
            //   String sku = "TEC-ALL-SVC";
            //   Product p = getProductFromList(pList, sku);
            //   await saveWishlistProduct(product: p);
            //   break;
            case "software":
              String sku = "TEC-APP-PKG";
              Product p = getProductFromList(pList, sku);
              await saveWishlistProduct(product: p);
              break;
            case "website":
              String sku = "TEC-WEB-PKG";
              Product p = getProductFromList(pList, sku);
              await saveWishlistProduct(product: p);
              break;
            default:
              Product p = getProductFromList(pList, "TEC-ALL-SVC");
              await saveWishlistProduct(product: p);
              break;
          } break;
        case "product":
          // switch (s2ResultString) {
          //   case "usability":
          //     Product p = getProductFromList(pList, "PRD-ALL-SVC");
          //     recommendations.add(p);
          //     break;
          //   case "quality":
          //     Product p = getProductFromList(pList, "PRD-ALL-SVC");
          //     recommendations.add(p);
          //     break;
          //   case "appeal":
          //     Product p = getProductFromList(pList, "PRD-ALL-SVC");
          //     recommendations.add(p);
          //     break;
          //   case "other":
              Product p = getProductFromList(pList, "PRD-ALL-SVC");
              await saveWishlistProduct(product: p);
          //     break;
/*          } */break;
        case "business":
          // switch (s2ResultString) {
          //   case "branding":
          //     Product p = getProductFromList(pList, "BUS-ALL-SVC");
          //     recommendations.add(p);
          //     break;
          //   case "sourcing":
          //     Product p = getProductFromList(pList, "BUS-ALL-SVC");
          //     recommendations.add(p);
          //     break;
          //   case "outreach":
          //     Product p = getProductFromList(pList, "BUS-ALL-SVC");
          //     recommendations.add(p);
          //     break;
          //   case "other":
              Product p = getProductFromList(pList, "BUS-ALL-SVC");
              await saveWishlistProduct(product: p);
          //     break;
/*          } */break;
        case "graphics":
          switch (s2ResultString) {
            case "logo":
              Product p = getProductFromList(pList, "GFX-LOG-PKG");
              await saveWishlistProduct(product: p);
              break;
            // case "illustration":
            //   Product p = getProductFromList(pList, "GFX-ALL-SVC");
            //   await saveWishlistProduct(product: p);
            //   break;
            case "collateral":
              Product p1 = getProductFromList(pList, "GFX-CRD-PKG");
              Product p2 = getProductFromList(pList, "GFX-ALL-SVC");
              await saveWishlistProduct(product: p1);
              await saveWishlistProduct(product: p2);
              break;
            default:
              Product p = getProductFromList(pList, "GFX-ALL-SVC");
              await saveWishlistProduct(product: p);
              break;
          } break;
        case "content":
          // switch (s2ResultString) {
          //   case "writing":
          //     break;
          //   case "audio":
          //     break;
          //   case "video":
          //     break;
          //   case "other":
          //     break;
          Product p = getProductFromList(pList, "CTT-ALL-SVC");
          await saveWishlistProduct(product: p);
/*          } */break;
        default:
          break;
      }
    }
  }
}

Product getProductFromList(List<Product> pList, String sku) {
  for (Product p in pList) {
    if (p.sku == sku) return p;
  }
  return null;
}


Future<User> getUser() async =>
    (await NyStorage.read<User>(SharedKey.authUser, model: User()));

Future appWooSignal(Function(WooSignal) api) async {
  return await api(WooSignal.instance);
}

/// helper to find correct color from the [context].
class ThemeColor {
  static BaseColorStyles get(BuildContext context) {
    return ((Theme.of(context).brightness == Brightness.light)
        ? ThemeConfig.light().colors
        : ThemeConfig.dark().colors);
  }
}

/// helper to set colors on TextStyle
extension ColorsHelper on TextStyle {
  TextStyle setColor(
      BuildContext context, Color Function(BaseColorStyles color) newColor) {
    return copyWith(color: newColor(ThemeColor.get(context)));
  }
}

List<PaymentType> getPaymentTypes() {
  List<PaymentType> paymentTypes = [];
  for (var appPaymentGateway in app_payment_gateways) {
    if (paymentTypes.firstWhere(
            (paymentType) => paymentType.name != appPaymentGateway,
            orElse: () => null) ==
        null) {
      paymentTypes.add(paymentTypeList.firstWhere(
          (paymentTypeList) => paymentTypeList.name == appPaymentGateway,
          orElse: () => null));
    }
  }

  if (!app_payment_gateways.contains('Stripe') &&
      AppHelper.instance.appConfig.stripeEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhere((element) => element.name == "Stripe", orElse: () => null));
  }
  if (!app_payment_gateways.contains('PayPal') &&
      AppHelper.instance.appConfig.paypalEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhere((element) => element.name == "PayPal", orElse: () => null));
  }
  if (!app_payment_gateways.contains('CashOnDelivery') &&
      AppHelper.instance.appConfig.codEnabled == true) {
    paymentTypes.add(paymentTypeList.firstWhere(
        (element) => element.name == "CashOnDelivery",
        orElse: () => null));
  }

  return paymentTypes.where((v) => v != null).toList();
}

dynamic envVal(String envVal, {dynamic defaultValue}) =>
    (getEnv(envVal) ?? defaultValue);

PaymentType addPayment(
        {@required int id,
        @required String name,
        @required String desc,
        @required String assetImage,
        @required Function pay}) =>
    PaymentType(
      id: id,
      name: name,
      desc: desc,
      assetImage: assetImage,
      pay: pay,
    );

showStatusAlert(context,
    {@required String title, String subtitle, IconData icon, int duration}) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: duration ?? 2),
    title: title,
    subtitle: subtitle,
    configuration: IconConfiguration(icon: icon ?? Icons.done, size: 50),
  );
}

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  return parse(document.body.text).documentElement.text;
}

String moneyFormatter(double amount) {
  MoneyFormatter fmf = MoneyFormatter(
    amount: amount,
    settings: MoneyFormatterSettings(
      symbol: AppHelper.instance.appConfig.currencyMeta.symbolNative,
    ),
  );
  if (app_currency_symbol_position == SymbolPositionType.left) {
    return fmf.output.symbolOnLeft;
  } else if (app_currency_symbol_position == SymbolPositionType.right) {
    return fmf.output.symbolOnRight;
  }
  return fmf.output.symbolOnLeft;
}

String formatDoubleCurrency({@required double total}) {
  return moneyFormatter(total);
}

String formatStringCurrency({@required String total}) {
  double tmpVal = 0;
  if (total != null && total != "") {
    tmpVal = parseWcPrice(total);
  }
  return moneyFormatter(tmpVal);
}

String workoutSaleDiscount(
    {@required String salePrice, @required String priceBefore}) {
  double dSalePrice = parseWcPrice(salePrice);
  double dPriceBefore = parseWcPrice(priceBefore);
  return ((dPriceBefore - dSalePrice) * (100 / dPriceBefore))
      .toStringAsFixed(0);
}

openBrowserTab({@required String url}) async {
  await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(toolbarColor: Colors.white70));
}

bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

checkout(
    TaxRate taxRate,
    Function(String total, BillingDetails billingDetails, Cart cart)
        completeCheckout) async {
  String cartTotal = await CheckoutSession.getInstance
      .total(withFormat: false, taxRate: taxRate);
  BillingDetails billingDetails = CheckoutSession.getInstance.billingDetails;
  Cart cart = Cart.getInstance;
  return await completeCheckout(cartTotal, billingDetails, cart);
}

double strCal({@required String sum}) {
  if (sum == null || sum == "") {
    return 0;
  }
  Parser p = Parser();
  Expression exp = p.parse(sum);
  ContextModel cm = ContextModel();
  return exp.evaluate(EvaluationType.REAL, cm);
}

Future<double> workoutShippingCostWC({@required String sum}) async {
  if (sum == null || sum == "") {
    return 0;
  }
  List<CartLineItem> cartLineItem = await Cart.getInstance.getCart();
  sum = sum.replaceAllMapped(defaultRegex(r'\[qty\]', strict: true), (replace) {
    return cartLineItem
        .map((f) => f.quantity)
        .toList()
        .reduce((i, d) => i + d)
        .toString();
  });

  String orderTotal = await Cart.getInstance.getSubtotal();

  sum = sum.replaceAllMapped(defaultRegex(r'\[fee(.*)]'), (replace) {
    if (replace.groupCount < 1) {
      return "()";
    }
    String newSum = replace.group(1);

    // PERCENT
    String percentVal = newSum.replaceAllMapped(
        defaultRegex(r'percent="([0-9\.]+)"'), (replacePercent) {
      if (replacePercent != null && replacePercent.groupCount >= 1) {
        String strPercentage = "( (" +
            orderTotal.toString() +
            " * " +
            replacePercent.group(1).toString() +
            ") / 100 )";
        double calPercentage = strCal(sum: strPercentage);

        // MIN
        String strRegexMinFee = r'min_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMinFee).hasMatch(newSum)) {
          String strMinFee =
              defaultRegex(strRegexMinFee).firstMatch(newSum).group(1) ?? "0";
          double doubleMinFee = double.parse(strMinFee);

          if (calPercentage < doubleMinFee) {
            return "(" + doubleMinFee.toString() + ")";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMinFee), "");
        }

        // MAX
        String strRegexMaxFee = r'max_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMaxFee).hasMatch(newSum)) {
          String strMaxFee =
              defaultRegex(strRegexMaxFee).firstMatch(newSum).group(1) ?? "0";
          double doubleMaxFee = double.parse(strMaxFee);

          if (calPercentage > doubleMaxFee) {
            return "(" + doubleMaxFee.toString() + ")";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMaxFee), "");
        }
        return "(" + calPercentage.toString() + ")";
      }
      return "";
    });

    percentVal = percentVal
        .replaceAll(
            defaultRegex(r'(min_fee=\"([0-9\.]+)\"|max_fee=\"([0-9\.]+)\")'),
            "")
        .trim();
    return percentVal;
  });

  return strCal(sum: sum);
}

Future<double> workoutShippingClassCostWC(
    {@required String sum, List<CartLineItem> cartLineItem}) async {
  if (sum == null || sum == "") {
    return 0;
  }
  sum = sum.replaceAllMapped(defaultRegex(r'\[qty\]', strict: true), (replace) {
    return cartLineItem
        .map((f) => f.quantity)
        .toList()
        .reduce((i, d) => i + d)
        .toString();
  });

  String orderTotal = await Cart.getInstance.getSubtotal();

  sum = sum.replaceAllMapped(defaultRegex(r'\[fee(.*)]'), (replace) {
    if (replace.groupCount < 1) {
      return "()";
    }
    String newSum = replace.group(1);

    // PERCENT
    String percentVal = newSum.replaceAllMapped(
        defaultRegex(r'percent="([0-9\.]+)"'), (replacePercent) {
      if (replacePercent != null && replacePercent.groupCount >= 1) {
        String strPercentage = "( (" +
            orderTotal.toString() +
            " * " +
            replacePercent.group(1).toString() +
            ") / 100 )";
        double calPercentage = strCal(sum: strPercentage);

        // MIN
        String strRegexMinFee = r'min_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMinFee).hasMatch(newSum)) {
          String strMinFee =
              defaultRegex(strRegexMinFee).firstMatch(newSum).group(1) ?? "0";
          double doubleMinFee = double.parse(strMinFee);

          if (calPercentage < doubleMinFee) {
            return "(" + doubleMinFee.toString() + ")";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMinFee), "");
        }

        // MAX
        String strRegexMaxFee = r'max_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMaxFee).hasMatch(newSum)) {
          String strMaxFee =
              defaultRegex(strRegexMaxFee).firstMatch(newSum).group(1) ?? "0";
          double doubleMaxFee = double.parse(strMaxFee);

          if (calPercentage > doubleMaxFee) {
            return "(" + doubleMaxFee.toString() + ")";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMaxFee), "");
        }
        return "(" + calPercentage.toString() + ")";
      }
      return "";
    });

    percentVal = percentVal
        .replaceAll(
            defaultRegex(r'(min_fee=\"([0-9\.]+)\"|max_fee=\"([0-9\.]+)\")'),
            "")
        .trim();
    return percentVal;
  });

  return strCal(sum: sum);
}

RegExp defaultRegex(
  String pattern, {
  bool strict,
}) {
  return RegExp(
    pattern,
    caseSensitive: strict ?? false,
    multiLine: false,
  );
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

navigatorPush(BuildContext context,
    {@required String routeName,
    Object arguments,
    bool forgetAll = false,
    int forgetLast}) {
  if (forgetAll) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }
  if (forgetLast != null) {
    int count = 0;
    Navigator.of(context).popUntil((route) {
      return count++ == forgetLast;
    });
  }
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

PlatformDialogAction dialogAction(BuildContext context,
    {@required title, ActionType actionType, Function() action}) {
  return PlatformDialogAction(
    actionType: actionType ?? ActionType.Default,
    child: Text(title ?? ""),
    onPressed: action ??
        () {
          Navigator.of(context).pop();
        },
  );
}

showPlatformAlertDialog(BuildContext context,
    {String title,
    String subtitle,
    List<PlatformDialogAction> actions,
    bool showDoneAction = true}) {
  if (showDoneAction) {
    actions.add(dialogAction(context, title: trans("Done"), action: () {
      Navigator.of(context).pop();
    }));
  }
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return PlatformAlertDialog(
        title: Text(title ?? ""),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(subtitle ?? ""),
            ],
          ),
        ),
        actions: actions,
      );
    },
  );
}

DateTime parseDateTime(String strDate) => DateTime.parse(strDate);

DateFormat formatDateTime(String format) => DateFormat(format);

String dateFormatted({@required String date, @required String formatType}) =>
    formatDateTime(formatType).format(parseDateTime(date));

enum FormatType {
  dateTime,
  date,
  time,
}

String formatForDateTime(FormatType formatType) {
  switch (formatType) {
    case FormatType.date:
      {
        return "yyyy-MM-dd";
      }
    case FormatType.dateTime:
      {
        return "dd-MM-yyyy hh:mm a";
      }
    case FormatType.time:
      {
        return "hh:mm a";
      }
    default:
      {
        return "";
      }
  }
}

double parseWcPrice(String price) => (double.tryParse(price ?? "0") ?? 0);

Widget refreshableScroll(context,
    {@required refreshController,
    @required VoidCallback onRefresh,
    @required VoidCallback onLoading,
    @required List<Product> products,
    @required onTap,
    key}) {
  return SmartRefresher(
    enablePullDown: true,
    enablePullUp: true,
    footer: CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(trans("pull up load"));
        } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text(trans("Load Failed! Click retry!"));
        } else if (mode == LoadStatus.canLoading) {
          body = Text(trans("release to load more"));
        } else {
          body = Text(trans("No more products"));
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    ),
    controller: refreshController,
    onRefresh: onRefresh,
    onLoading: onLoading,
    child: (products.length != null && products.isNotEmpty
        ? StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 200,
                child: ProductItemContainer(
                  product: products[index],
                  onTap: onTap,
                ),
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          )
        : NoResultsForProductsWidget()),
  );
}

class UserAuth {
  UserAuth._privateConstructor();
  static final UserAuth instance = UserAuth._privateConstructor();

  String redirect = "/home";
}

Future<List<DefaultShipping>> getDefaultShipping(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context)
      .loadString("public/assets/json/default_shipping.json");
  dynamic dataJson = json.decode(data);
  List<DefaultShipping> shipping = [];

  dataJson.forEach((key, value) {
    DefaultShipping defaultShipping =
        DefaultShipping(code: key, country: value['country'], states: []);
    if (value['states'] != null) {
      value['states'].forEach((key1, value2) {
        defaultShipping.states
            .add(DefaultShippingState(code: key1, name: value2));
      });
    }
    shipping.add(defaultShipping);
  });
  return shipping;
}

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}...' : data;
}

Future<List<dynamic>> getWishlistProducts() async {
  List<dynamic> favouriteProducts = [];
  String currentProductsJSON = await NyStorage.read(SharedKey.wishlistProducts);
  if (currentProductsJSON != null) {
    favouriteProducts =
        (jsonDecode(currentProductsJSON) as List<dynamic>).toList();
  }
  return favouriteProducts;
}

hasAddedWishlistProduct(int productId) async {
  List<dynamic> favouriteProducts = await getWishlistProducts();
  List<int> productIds =
  favouriteProducts.map((e) => e['id']).cast<int>().toList();
  if (productIds.isEmpty) {
   return false;
  }
  return productIds.contains(productId);
}

saveWishlistProduct({@required Product product}) async {
  List<dynamic> products = await getWishlistProducts();
  if (products.any((wishListProduct) => wishListProduct['id'] == product.id) ==
      false) {
    products.add({"id": product.id});
  }
  String json = jsonEncode(products.map((i) => {"id": i['id']}).toList());
  await NyStorage.store(SharedKey.wishlistProducts, json);
}

removeWishlistProduct({@required Product product}) async {
  List<dynamic> products = await getWishlistProducts();
  products.removeWhere((element) => element['id'] == product.id);

  String json = jsonEncode(products.map((i) => {"id": i['id']}).toList());
  await NyStorage.store(SharedKey.wishlistProducts, json);
}
