import 'package:flutter_app/resources/pages/account/account_billing_details.dart';
import 'package:flutter_app/resources/pages/account/account_order_detail.dart';
import 'package:flutter_app/resources/pages/account/account_profile_update.dart';
import 'package:flutter_app/resources/pages/account/account_register.dart';
import 'package:flutter_app/resources/pages/product/browse_category.dart';
import 'package:flutter_app/resources/pages/product/browse_search.dart';
import 'package:flutter_app/resources/pages/product/cart.dart';
import 'package:flutter_app/resources/pages/checkout/checkout_confirmation.dart';
import 'package:flutter_app/resources/pages/checkout/checkout_details.dart';
import 'package:flutter_app/resources/pages/checkout/checkout_status.dart';
import 'package:flutter_app/resources/pages/customer_countries.dart';
import 'package:flutter_app/resources/pages/home.dart';
import 'package:flutter_app/resources/pages/home_search.dart';
import 'package:flutter_app/resources/pages/leave_review_page.dart';
import 'package:flutter_app/resources/pages/no_connection_page.dart';
import 'package:flutter_app/resources/pages/product/product_image_viewer_page.dart';
import 'package:flutter_app/resources/pages/product/product_reviews_page.dart';
import 'package:nylo_support/router/router.dart';
import 'package:page_transition/page_transition.dart';

import '../resources/pages/account/account_detail.dart';
import '../resources/pages/account/account_landing.dart';
import '../resources/pages/account/account_shipping_details.dart';
import '../resources/pages/checkout/checkout_payment_type.dart';
import '../resources/pages/checkout/checkout_shipping_type.dart';
import '../resources/pages/product/coupon_page.dart';
import '../resources/pages/product/product_detail.dart';
import '../resources/pages/product/wishlist_page_widget.dart';
import '../resources/widgets/checkout/checkout_paypal.dart';

/*
|--------------------------------------------------------------------------
| App Router
|--------------------------------------------------------------------------
*/

appRouter() => nyRoutes((router) {
      router.route("/home", (context) => HomePage());

      router.route("/cart", (context) => CartPage());

      router.route("/checkout", (context) => CheckoutConfirmationPage());

      router.route("/browse-category", (context) => BrowseCategoryPage(),
          transition: PageTransitionType.fade);

      router.route("/product-search", (context) => BrowseSearchPage(),
          transition: PageTransitionType.fade);

      router.route("/product-detail", (context) => ProductDetailPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route("/product-reviews", (context) => ProductReviewsPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route("/product-leave-review", (context) => LeaveReviewPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route("/product-images", (context) => ProductImageViewerPage(),
          transition: PageTransitionType.fade);

      router.route("/wishlist", (context) => WishListPageWidget(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route(
          "/account-order-detail", (context) => AccountOrderDetailPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route("/checkout-status", (context) => CheckoutStatusPage(),
          transition: PageTransitionType.rightToLeftWithFade);

      router.route("/checkout-details", (context) => CheckoutDetailsPage(),
          transition: PageTransitionType.bottomToTop);

      router.route(
          "/checkout-payment-type", (context) => CheckoutPaymentTypePage(),
          transition: PageTransitionType.bottomToTop);

      router.route(
          "/checkout-shipping-type", (context) => CheckoutShippingTypePage(),
          transition: PageTransitionType.bottomToTop);

      router.route("/checkout-coupons", (context) => CouponPage(),
          transition: PageTransitionType.bottomToTop);

      router.route("/home-search", (context) => HomeSearchPage(),
          transition: PageTransitionType.bottomToTop);

      router.route('/paypal', (context) => PayPalCheckout());

      router.route("/customer-countries", (context) => CustomerCountriesPage(),
          transition: PageTransitionType.bottomToTop);

      router.route("/no-connection", (context) => NoConnectionPage());

      // Account Section

      router.route("/account-landing", (context) => AccountLandingPage(),
          transition: PageTransitionType.bottomToTop);

      router.route("/account-register", (context) => AccountRegistrationPage());

      router.route("/account-detail", (context) => AccountDetailPage());

      router.route("/account-update", (context) => AccountProfileUpdatePage());

      router.route(
          "/account-billing-details", (context) => AccountBillingDetailsPage());

      router.route("/account-shipping-details",
          (context) => AccountShippingDetailsPage());
    });
