part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;

  const CartStarted(this.authInfo);
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class IncreaseCountButtonClicked extends CartEvent {
  final int cartItemId;

  const IncreaseCountButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class DecreaseCountButtonClicked extends CartEvent {
  final int cartItemId;

  const DecreaseCountButtonClicked(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}
