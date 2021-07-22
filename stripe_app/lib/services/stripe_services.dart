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

  Future<StripeCustomResponse> paymentWithCardExist({
    required String amount,
    required String currency,
    required CreditCard card,
  }) async {
    try {
      //Create a form for create a new credit card
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card),
      );

      final resp = await this._makePayment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<StripeCustomResponse> paymentWithNewCard(
      {required String amount, required String currency}) async {
    try {
      //Create a form for create a new credit card
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      final resp = await this._makePayment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<StripeCustomResponse> paymentWithAppleGooglePlay({
    required String amount,
    required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;

      final token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
            currencyCode: currency, totalPrice: amount),
        applePayOptions: ApplePayPaymentOptions(
          countryCode: 'MEX',
          currencyCode: currency,
          items: [
            ApplePayItem(
              label: 'Super producto 1',
              amount: '$newAmount',
            )
          ],
        ),
      );

      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: CreditCard(token: token.tokenId)));

      final resp = await this._makePayment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      await StripePayment.completeNativePayRequest();

      return resp;
    } catch (e) {
      print('ERROR en intento: ${e.toString()}');
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

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

  Future<StripeCustomResponse> _makePayment({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      //Create the intent
      final paymentIntent = await this._createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymentMethod.id,
        ),
      );

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true, msg: '');
      } else {
        return StripeCustomResponse(
            ok: false, msg: 'Fallo: ${paymentResult.status}');
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
