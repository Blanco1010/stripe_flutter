import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/models/card_credit.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class CardPage extends StatelessWidget {
  final card = CardCredit(
      cardNumberHidden: '4242',
      cardNumber: '4242424242424242',
      brand: 'visa',
      cvv: '213',
      expiracyDate: '01/25',
      cardHolderName: 'Juan Camilo Blanco Martinez');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Pagar'),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: card.cardNumber,
              child: CreditCardWidget(
                  cardNumber: card.cardNumber,
                  expiryDate: card.expiracyDate,
                  cardHolderName: card.cardHolderName,
                  cvvCode: card.cvv,
                  showBackView: false),
            ),
            Positioned(
              bottom: size.height * 0.02,
              child: TotalPayButton(),
            )
          ],
        ));
  }
}
