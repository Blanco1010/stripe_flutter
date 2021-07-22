import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stripe_app/bloc/pay/pay_bloc.dart';
import 'package:stripe_app/services/stripe_services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_payment/stripe_payment.dart';

//Evelyn es una toxica
class TotalPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final payBloc = BlocProvider.of<PayBloc>(context).state;

    return Container(
      width: width,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('${payBloc.amountPay} ${payBloc.money}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal))
            ],
          ),
          BlocBuilder<PayBloc, PayState>(builder: (context, state) {
            return _BtnPay(state);
          }),
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  final PayState state;

  const _BtnPay(this.state);

  @override
  Widget build(BuildContext context) {
    return state.activeCard
        ? buildButtonCredit(context)
        : buildAppleAndGoogle(context);
  }

  Widget buildButtonCredit(BuildContext context) {
    return Container(
      child: MaterialButton(
        height: 50,
        minWidth: 150,
        shape: StadiumBorder(),
        elevation: 0,
        color: Colors.black,
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.creditCard,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Pagar',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
        onPressed: () async {
          showLoading(context);

          final stripeService = new StripeService();
          final state = BlocProvider.of<PayBloc>(context).state;
          final card = state.card;
          final monthYears = card!.expiracyDate.split('/');

          final resp = await stripeService.paymentWithCardExist(
            amount: state.amountPayString,
            currency: state.money,
            card: CreditCard(
              number: card.cardNumber,
              expMonth: int.parse(monthYears[0]),
              expYear: int.parse(monthYears[1]),
            ),
          );
          Navigator.pop(context);

          if (resp.ok) {
            showAlert(context, 'Tarjeta OK', 'Todo correcto');
          } else {
            showAlert(context, 'Algo salío mal', resp.msg);
          }
        },
      ),
    );
  }

  Widget buildAppleAndGoogle(BuildContext context) {
    return Container(
      child: MaterialButton(
        height: 50,
        minWidth: 150,
        shape: StadiumBorder(),
        elevation: 0,
        color: Colors.black,
        child: Row(
          children: [
            Icon(
              Platform.isAndroid
                  ? FontAwesomeIcons.google
                  : FontAwesomeIcons.apple,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Pay',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
        onPressed: () async {
          final stripeService = new StripeService();
          final state = BlocProvider.of<PayBloc>(context).state;

          final resp = await stripeService.paymentWithAppleGooglePlay(
            amount: state.amountPayString,
            currency: state.money,
          );
        },
      ),
    );
  }
}
