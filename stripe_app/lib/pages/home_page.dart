import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pay/pay_bloc.dart';

import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/card_page.dart';
import 'package:stripe_app/data/cards.dart';

import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/services/stripe_services.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class Homepage extends StatelessWidget {
  final stripeService = new StripeService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final paymentBloc = BlocProvider.of<PayBloc>(context);

              final amount = paymentBloc.state.amountPayString;
              final currency = paymentBloc.state.money;

              final resp = await this.stripeService.paymentWithNewCard(
                    amount: amount,
                    currency: currency,
                  );

              if (resp.ok) {
                showAlert(context, 'Tarjeta OK', 'Todo correcto');
              } else {
                showAlert(context, 'Algo salío mal', resp.msg);
              }

              // showLoading(context);

              // await Future.delayed(Duration(seconds: 1));

              // Navigator.pop(context);

              // showAlert(context, 'Hola', 'Mundo');
            },
            icon: Icon(Icons.payments),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            height: size.height,
            width: size.width,
            top: size.width / 2,
            child: PageView.builder(
                controller: PageController(viewportFraction: 1),
                physics: BouncingScrollPhysics(),
                itemCount: cards.length,
                itemBuilder: (_, i) {
                  final card = cards[i];

                  return GestureDetector(
                    onTap: () {
                      final blocCard = BlocProvider.of<PayBloc>(context);
                      blocCard.add(OnSelectCard(card));

                      Navigator.push(
                          context, navigationFadeIn(context, CardPage()));
                    },
                    child: Hero(
                      tag: card.cardNumber,
                      child: CreditCardWidget(
                          cardNumber: card.cardNumber,
                          expiryDate: card.expiracyDate,
                          cardHolderName: card.cardHolderName,
                          cvvCode: card.cvv,
                          showBackView: false),
                    ),
                  );
                }),
          ),
          Positioned(
            bottom: size.height * 0.02,
            child: TotalPayButton(),
          )
        ],
      ),
    );
  }
}
