import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/favourite_manager.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/ui/auth/auth.dart';

import '../../common/utils.dart';
import '../../data/auth_info.dart';
import '../../data/product.dart';
import '../../data/repo/cart_repository.dart';
import '../widgets/image.dart';
import 'bloc/product_bloc.dart';
import 'comment/comment_list.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isAuth = authInfo != null && authInfo.accessToken.isNotEmpty;

            return BlocProvider<ProductBloc>(
              create: (context) {
                final bloc = ProductBloc(cartRepository);
                stateSubscription = bloc.stream.listen((state) {
                  if (state is ProductAddToCartSuccess) {
                    _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                        content: Text('با موفقیت به سبد خرید شما اضافه شد')));
                  } else if (state is ProductAddToCartError) {
                    _scaffoldKey.currentState?.showSnackBar(
                        SnackBar(content: Text(state.exception.message)));
                  }
                });
                return bloc;
              },
              child: ScaffoldMessenger(
                key: _scaffoldKey,
                child: Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) =>
                          FloatingActionButton.extended(
                        onPressed: isAuth
                            ? () {
                                BlocProvider.of<ProductBloc>(context)
                                    .add(CartAddButtonClick(widget.product.id));
                              }
                            : () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AuthScreen(),
                                  ),
                                );
                              },
                        label: state is ProductAddToCartButtonLoading
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )
                            : Text(isAuth
                                ? 'افزودن به سبد خرید'
                                : 'ورود به حساب کابری'),
                      ),
                    ),
                  ),
                  body: CustomScrollView(
                    physics: defaultScrollPhysics,
                    slivers: [
                      SliverAppBar(
                        expandedHeight: MediaQuery.of(context).size.width * 0.8,
                        flexibleSpace: ImageLoadingService(
                            imageUrl: widget.product.imageUrl),
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        actions: [
                          IconButton(
                            onPressed: () {
                              if (favouriteManeger
                                  .isFavourite(widget.product)) {
                                favouriteManeger.delete(widget.product);
                              } else {
                                favouriteManeger.addFavourite(widget.product);
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              favouriteManeger.isFavourite(widget.product)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color:
                                  favouriteManeger.isFavourite(widget.product)
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          )
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    widget.product.title,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.product.previousPrice
                                            .withPriceLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .apply(
                                                decoration:
                                                    TextDecoration.lineThrough),
                                      ),
                                      Text(widget.product.price.withPriceLabel),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                                style: TextStyle(height: 1.4),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'نظرات کاربران',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text('ثبت نظر'))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      CommentList(productId: widget.product.id),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
