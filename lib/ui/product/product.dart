import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/favourite_manager.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';

import '../../data/product.dart';
import '../widgets/image.dart';
import 'details.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemheight = 189,
  }) : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;

  final double itemWidth;
  final double itemheight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: widget.product,
                    ),
                  ),
                )
                .then((value) =>
                    //update ui if the liked state changes
                    setState(() {}));
          },
          child: SizedBox(
            width: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLoadingService(
                        imageUrl: widget.product.imageUrl,
                        imageBorderRadius: widget.borderRadius,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          if (favouriteManeger.isFavourite(widget.product)) {
                            favouriteManeger.delete(widget.product);
                          } else {
                            favouriteManeger.addFavourite(widget.product);
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                              favouriteManeger.isFavourite(widget.product)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color:
                                  favouriteManeger.isFavourite(widget.product)
                                      ? Colors.red
                                      : Colors.black,
                              size: 20),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    widget.product.previousPrice.withPriceLabel,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Text(widget.product.price.withPriceLabel),
                ),
              ],
            ),
          ),
        ));
  }
}
