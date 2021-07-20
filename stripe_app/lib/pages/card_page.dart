import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pay/pay_bloc.dart';

import 'package:stripe_app/widgets/total_pay_button.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final card = context.watch<PayBloc>().state.card;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Pagar'),
          leading: IconButton(
              onPressed: () {
                final blocCard = BlocProvider.of<PayBloc>(context);
                blocCard.add(OnDeactivateCard());

                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: card!.cardNumber,
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
