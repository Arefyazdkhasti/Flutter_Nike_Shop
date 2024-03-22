import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/data/auth_info.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/auth/auth.dart';
import 'package:nike_shop/ui/favourites/favourites.dart';
import 'package:nike_shop/ui/order/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    width: 65,
                    height: 65,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Image.asset('assets/img/nike_logo.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(isLogin ? authInfo.emailAddress : 'کاربر مهمان'),
                  const SizedBox(height: 32),
                  Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FavouriteListScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.heart),
                          SizedBox(width: 12),
                          Text('لیست علاقه مندی ها')
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.cart),
                          SizedBox(width: 12),
                          Text('سوابق سفارش')
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                  InkWell(
                    onTap: isLogin
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      title: const Text('خروج  از حساب کاربری'),
                                      content: const Text(
                                          'آیا میخواهید از حساب خود خارج شوید؟'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            //close dialouge
                                            Navigator.pop(context);
                                            //logout
                                            CartRepository.cartItemCountNotifier
                                                .value = 0;
                                            authRepository.signOut();
                                          },
                                          child: const Text('بله'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('خیر'),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                        : () {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(),
                              ),
                            );
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.arrow_right_square),
                          const SizedBox(width: 12),
                          Text(
                            isLogin
                                ? 'خروج از حساب کاربری'
                                : 'ورود به حساب کاربری',
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
