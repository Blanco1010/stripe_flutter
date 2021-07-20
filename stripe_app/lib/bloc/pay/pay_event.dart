part of 'pay_bloc.dart';

@immutable
abstract class PayEvent {}

class OnSelectCard extends PayEvent {
  final CardCredit card;

  OnSelectCard(this.card);
}

class OnDeactivateCard extends PayEvent {}
