part of 'shipping_bloc.dart';

sealed class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

final class ShippingInitial extends ShippingState {}

final class ShippingLoading extends ShippingState {}

final class ShippingError extends ShippingState {
  final AppException exception;

  const ShippingError(this.exception);

  @override
  List<Object> get props => [exception];
}

final class ShippingSuccess extends ShippingState {
  final CreateOrderResult result;

  const ShippingSuccess(this.result);

  @override
  List<Object> get props => [result];
}
