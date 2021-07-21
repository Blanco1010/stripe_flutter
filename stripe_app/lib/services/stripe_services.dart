import 'package:dio/dio.dart';
import 'package:stripe_app/models/payment_intent_response.dart';
import 'package:stripe_app/models/stripe_custom_responde.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  // Singleton
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();

  factory StripeService() => _instance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51JFh5jKfThoPE1Io7EDKIJcNtx6Vmi7Cqfn3nbsO1xqwcllwsanQc9PN75ndjMzXf1DMTt1DTAieKZrE1gvmtWBr00EUhlbrsY';
  String _apiKey =
      'pk_test_51JFh5jKfThoPE1Ioe9NjNnNzjqP3g4XknEJMO6xuXWPVCzqZuY0AZ57CDzhlhjxBvmj12j1UyybQUSrG6hzDty9100F74ItwRm';

  final headerOptions = new Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer ${StripeService._secretKey}'});

  void init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: this._apiKey,
      androidPayMode: 'test',
      merchantId: 'test',
    ));
  }

  Future paymentWithCardExist({
    required String amount,
    required String currency,
    required CreditCard card,
  }) async {}

  Future<StripeCustomResponse> paymentWithNewCard({
    required String amount,
    required String currency,
  }) async {
    try {
      //Create a form for create a new credit card
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      final resp =
          await this._createPaymentIntent(amount: amount, currency: currency);

      return StripeCustomResponse(ok: true, msg: '');
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future paymentWithAppleGooglePlay({
    required String amount,
    required String currency,
  }) async {}

  Future<PaymentIntentResponse> _createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final dio = new Dio();
      final data = {'amount': amount, 'currency': currency};

      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions,
      );

      return PaymentIntentResponse.fromJson(resp.data);
    } catch (e) {
      print('ERROR en intento: ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future _makePayment({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {}
}
