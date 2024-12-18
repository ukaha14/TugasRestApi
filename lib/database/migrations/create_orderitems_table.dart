import 'package:vania/vania.dart';

class CreateOrderItemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    await createTableNotExists('orderitems', () {
      bigIncrements('order_item');
      bigInt('order_num', unsigned: true);
      bigInt('prod_id', unsigned: true);
      integer('quantity');
      integer('size');

      primary('order_item');
      foreign('order_num', 'orders', 'order_num');
      foreign('prod_id', 'products', 'prod_id');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();

    await dropIfExists('orderitems');
  }
}
