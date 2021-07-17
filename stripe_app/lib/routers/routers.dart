import 'package:flutter/material.dart';
import 'package:stripe_app/pages/card_page.dart';
import 'package:stripe_app/pages/full_payment_page.dart';
import 'package:stripe_app/pages/home_page.dart';

final Map<String, Widget Function(BuildContext)> routes =
    <String, WidgetBuilder>{
  'home': (_) => Homepage(),
  'fullPayment': (_) => FullPaymentPage(),
  'card': (_) => CardPage(),
};
