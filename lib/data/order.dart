import 'product.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResult(
    this.orderId,
    this.bankGatewayUrl,
  );

  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.postalCode,
    required this.address,
    required this.paymentMethod,
  });
}

enum PaymentMethod {
  online,
  cashOnDelivery,
}

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id, this.payablePrice, this.items);

  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        items = (json['order_items'] as List)
            .map((e) => ProductEntity.fromJson(e['product']))
            .toList();
}
