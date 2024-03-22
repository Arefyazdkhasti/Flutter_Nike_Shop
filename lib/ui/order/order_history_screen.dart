import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_shop/ui/widgets/error.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق سفارش'),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
            builder: (context, state) {
          if (state is OrderHistorySuccess) {
            final orders = state.orders;

            return ListView.separated(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('شناسه سفارش'),
                            Text(order.id.toString())
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor.withOpacity(0.2),
                      ),
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('مبلغ'),
                            Text(order.payablePrice.withPriceLabel)
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor.withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 132,
                        child: ListView.builder(
                            itemCount: order.items.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) => Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.all(8),
                                  child: ImageLoadingService(
                                    imageUrl: order.items[index].imageUrl,
                                    imageBorderRadius: BorderRadius.circular(8),
                                  ),
                                ))),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            );
          } else if (state is OrderHistoryLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is OrderHistoryError) {
            return AppErrorWidget(
              exception: state.exception,
              onPressed: () {
                BlocProvider.of<OrderHistoryBloc>(context)
                    .add(OrderHistoryStarted());
              },
            );
          } else {
            throw Exception('state is not supported $state');
          }
        }),
      ),
    );
  }
}
