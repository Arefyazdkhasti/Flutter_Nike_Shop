part of 'payment_receipt_bloc.dart';

sealed class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

final class PaymentReceiptInitial extends PaymentReceiptState {}

final class PaymentReceiptLoading extends PaymentReceiptState {}

final class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceiptData paymentReceiptData;

  const PaymentReceiptSuccess(this.paymentReceiptData);

  @override
  List<Object> get props => [paymentReceiptData];
}

final class PaymentReceiptError extends PaymentReceiptState {
  final AppException appException;

  const PaymentReceiptError(this.appException);

  @override
  List<Object> get props => [appException];
}
