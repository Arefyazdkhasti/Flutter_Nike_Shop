import 'package:nike_shop/common/http_client.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment_receipt.dart';
import 'package:nike_shop/data/source/order_data_source.dart';

final OrderRepository orderRepository =
    OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderID) =>
      dataSource.getPaymentReceipt(orderID);

  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();
}
