part of 'pay_bloc.dart';

@immutable
class PayState {
  final double amountPay;
  final String money; //CAD,USD, EUR, COP
  final bool activeCard; // if the card is active can to pay
  final CardCredit? card; // the attributes of card

  String get amountPayString => '${(this.amountPay * 100).floor()}';

  PayState({
    this.amountPay = 375.5,
    this.money = 'USD',
    this.activeCard = false,
    this.card,
  });

  PayState copyWith({
    double? amountPay,
    String? money,
    bool? activeCard,
    CardCredit? card,
  }) =>
      PayState(
        money: money ?? this.money,
        amountPay: amountPay ?? this.amountPay,
        activeCard: activeCard ?? this.activeCard,
        card: card ?? this.card,
      );
}
