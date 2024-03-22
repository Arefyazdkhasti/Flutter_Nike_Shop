import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/shipping/shipping.dart';
import 'package:nike_shop/ui/widgets/empty_view.dart';

import '../../common/utils.dart';
import '../auth/auth.dart';
import '../widgets/error.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  bool stateIsSuccess = false;

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc?.add(
      CartAuthInfoChanged(AuthRepository.authChangeNotifier.value),
    );
  }

  @override
  void dispose() {
    // remove listener to avoid memory leak
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("سبد خرید"),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = CartBloc(cartRepository);
          stateStreamSubscription = bloc.stream.listen((state) {
            setState(() {
              stateIsSuccess = state is CartSuccess;
            });
          });
          cartBloc = bloc;
          bloc.add(
            CartStarted(AuthRepository.authChangeNotifier.value),
          );
          return bloc;
        },
        child: Scaffold(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: stateIsSuccess,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShippingScreen(
                          payablePrice: state.cartResponse.payablePrice,
                          totalPrice: state.cartResponse.totalPrice,
                          shippingCost: state.cartResponse.shippingCost,
                        ),
                      ),
                    );
                  }
                },
                label: const Text('پرداخت'),
              ),
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<CartBloc, CartState>(builder: ((context, state) {
              if (state is CartSuccess) {
                return RefreshIndicator(
                  onRefresh: () => Future.sync(() {
                    cartBloc?.add(
                        CartStarted(AuthRepository.authChangeNotifier.value));
                  }),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 50),
                    physics: defaultScrollPhysics,
                    itemCount: state.cartResponse.cartItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CartItem(
                            data: data,
                            theme: theme,
                            onDeleteButtonClicked: () {
                              cartBloc?.add(CartDeleteButtonClicked(data.id));
                            },
                            onIncreaseButtonClicked: () {
                              cartBloc
                                  ?.add(IncreaseCountButtonClicked(data.id));
                            },
                            onDecreaseButtonClicked: () {
                              if (data.count > 1) {
                                cartBloc
                                    ?.add(DecreaseCountButtonClicked(data.id));
                              }
                            },
                          ),
                        );
                      } else {
                        //price info item
                        return PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          totalPrice: state.cartResponse.totalPrice,
                          shippingCost: state.cartResponse.shippingCost,
                        );
                      }
                    },
                  ),
                );
              } else if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartError) {
                return AppErrorWidget(
                  exception: state.appException,
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context).add(
                      CartStarted(AuthRepository.authChangeNotifier.value),
                    );
                  },
                );
                ;
              } else if (state is CartEmpty) {
                return Center(
                  child: EmptyView(
                    message: Text(
                      "سبد خرید شما خالی است",
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    image: SvgPicture.asset(
                      width: 200,
                      'assets/img/empty_cart.svg',
                    ),
                  ),
                );
              } else if (state is CartAuthRequired) {
                return Center(
                  child: EmptyView(
                    message: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید.",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    image: SvgPicture.asset(
                        width: 100, 'assets/img/auth_required.svg'),
                    callToAtion: TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ),
                        );
                      },
                      child: const Text("ورود به حساب کاربری"),
                    ),
                  ),
                );
              } else {
                throw Exception('state is not supported');
              }
            })),
          ),
        ),
      ),
    );
  }
}
