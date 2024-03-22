import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/favourite_manager.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/ui/product/details.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class FavouriteListScreen extends StatelessWidget {
  const FavouriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favouriteManeger.listanable,
        builder: (context, box, child) {
          final products = box.values.toList();

          return ListView.separated(
              shrinkWrap: true,
              itemCount: products.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  onLongPress: () {
                    favouriteManeger.delete(product);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: ImageLoadingService(
                            imageUrl: product.imageUrl,
                            imageBorderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title),
                              const SizedBox(height: 24),
                              Text(
                                product.previousPrice.withPriceLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .apply(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade500),
                              ),
                              Text(product.price.withPriceLabel),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
