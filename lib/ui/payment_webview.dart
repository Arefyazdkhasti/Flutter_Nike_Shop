import 'package:flutter/material.dart';
import 'package:nike_shop/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  final String bankGatewayUrl;

  const PaymentGatewayScreen({
    super.key,
    required this.bankGatewayUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: bankGatewayUrl,
          javascriptMode: JavascriptMode.disabled,
          onPageStarted: (url) {
            debugPrint(url);
            final uri = Uri.parse(url);
            if (uri.pathSegments.contains('checkout') &&
                uri.host == 'expertdevelopers.ir') {
              final orderId = int.parse(uri.queryParameters['order_id']!);
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentReceiptScreen(orderId: orderId),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
