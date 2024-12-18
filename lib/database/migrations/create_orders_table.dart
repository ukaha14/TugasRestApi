import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    await createTableNotExists('orders', () {
      bigIncrements('order_num');
      date('order_date');
      bigInt('cust_id', unsigned: true);

      primary('order_num');
      foreign('cust_id', 'customers', 'cust_id');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();

    await dropIfExists('orders');
  }
}