import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/shipping/bloc/shipping_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repo/order_repository.dart';
import '../payment_webview.dart';
import '../receipt/payment_receipt.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int totalPrice;
  final int shippingCost;

  const ShippingScreen({
    super.key,
    required this.payablePrice,
    required this.totalPrice,
    required this.shippingCost,
  });

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'عارف');

  final TextEditingController lastNameController =
      TextEditingController(text: 'یزدخواستی');

  final TextEditingController postalCodeController =
      TextEditingController(text: '6193445871');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09901876797');

  final TextEditingController addressController =
      TextEditingController(text: 'اصفهان خیابان فیض کوچه اقابابایی واحد 2');

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('تحویل گیرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((event) async {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(event.exception.message),
                ),
              );
            } else if (event is ShippingSuccess) {
              if (event.result.bankGatewayUrl.isNotEmpty) {
                /* avigator.of(
                  context,
                  rootNavigator: true,
                ).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentGatewayScreen(
                      bankGatewayUrl: event.result.bankGatewayUrl,
                    ),
                  ),
                ); */
                if (!await launchUrl(Uri.parse(event.result.bankGatewayUrl))) {
                  throw Exception(
                      'Could not launch ${event.result.bankGatewayUrl}');
                }
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentReceiptScreen(
                      orderId: event.result.orderId,
                    ),
                  ),
                );
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    label: Text('نام'),
                  ),
                  controller: firstNameController,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    label: Text('نام خانوادگی'),
                  ),
                  controller: lastNameController,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    label: Text('کد پستی'),
                  ),
                  controller: postalCodeController,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    label: Text('شماره تماس'),
                  ),
                  controller: phoneNumberController,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    label: Text('آدرس'),
                  ),
                  controller: addressController,
                ),
                const SizedBox(height: 12),
                PriceInfo(
                  payablePrice: widget.payablePrice,
                  totalPrice: widget.totalPrice,
                  shippingCost: widget.shippingCost,
                ),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoading
                        ? const Center(child: CupertinoActivityIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(
                                      CreateOrderParams(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phoneNumber:
                                              phoneNumberController.text,
                                          address: addressController.text,
                                          postalCode: postalCodeController.text,
                                          paymentMethod:
                                              PaymentMethod.cashOnDelivery),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'پرداخت در محل',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(
                                      CreateOrderParams(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        phoneNumber: phoneNumberController.text,
                                        address: addressController.text,
                                        postalCode: postalCodeController.text,
                                        paymentMethod: PaymentMethod.online,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'پرداخت اینترنتی',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                              ),
                            ],
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
