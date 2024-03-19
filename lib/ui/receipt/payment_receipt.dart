import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/ui/receipt/bloc/payment_receipt_bloc.dart';

import '../widgets/error.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;

  const PaymentReceiptScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("رسید پرداخت "),
      ),
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) => PaymentReceiptBloc(orderRepository)
          ..add(
            PaymentReceiptStarted(orderId),
          ),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is PaymentReceiptError) {
              return Center(
                child: AppErrorWidget(
                  exception: state.appException,
                  onPressed: () {},
                ),
              );
            } else if (state is PaymentReceiptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              theme.colorScheme.outlineVariant.withOpacity(0.5),
                          width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReceiptData.purchaseSuccess
                              ? "پرداخت با موفقیت انجام شد"
                              : "پرداخت ناموفق",
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: state.paymentReceiptData.purchaseSuccess
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'وضعیت سفارش',
                              style: theme.textTheme.bodyLarge!
                                  .copyWith(color: theme.colorScheme.outline),
                            ),
                            Text(
                              state.paymentReceiptData.paymentStatus,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 32,
                          thickness: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withOpacity(0.5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'مبلغ',
                              style: theme.textTheme.bodyLarge!
                                  .copyWith(color: theme.colorScheme.outline),
                            ),
                            Text(
                              state.paymentReceiptData.payablePrice
                                  .withPriceLabel,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('بازگشت به صفحه اصلی'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
