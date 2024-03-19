import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/common/utils.dart';

import '../../data/cart_item.dart';
import '../widgets/image.dart';

class CartItem extends StatelessWidget {
  final CartItemEntity data;
  final ThemeData theme;
  final GestureTapCallback onDeleteButtonClicked;
  final GestureTapCallback onIncreaseButtonClicked;
  final GestureTapCallback onDecreaseButtonClicked;

  const CartItem({
    super.key,
    required this.data,
    required this.theme,
    required this.onDeleteButtonClicked,
    required this.onIncreaseButtonClicked,
    required this.onDecreaseButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ImageLoadingService(
                      imageUrl: data.product.imageUrl,
                      imageBorderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(
                    data.product.title,
                    style: theme.textTheme.titleSmall,
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تعداد",
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: onIncreaseButtonClicked,
                            icon: const Icon(
                              CupertinoIcons.plus_rectangle,
                            ),
                          ),
                          data.changeCountLoading
                              ? CupertinoActivityIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                )
                              : Text(
                                  data.count.toString(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                          IconButton(
                            onPressed: onDecreaseButtonClicked,
                            icon: const Icon(CupertinoIcons.minus_rectangle),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.product.previousPrice.withPriceLabel,
                        style: theme.textTheme.labelMedium!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        data.product.price.withPriceLabel,
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.colorScheme.surfaceVariant,
            ),
            data.deleteButtonLoading
                ? const SizedBox(
                    height: 48,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                : TextButton(
                    onPressed: onDeleteButtonClicked,
                    child: Text('حذف از سبد خرید'),
                  )
          ],
        ),
      ),
    );
  }
}
