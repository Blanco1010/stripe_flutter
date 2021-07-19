import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/data/cards.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
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

                  return CreditCardWidget(
                      cardNumber: card.cardNumber,
                      expiryDate: card.expiracyDate,
                      cardHolderName: card.cardHolderName,
                      cvvCode: card.cvv,
                      showBackView: false);
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
