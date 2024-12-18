import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    await createTableNotExists('products', () {
      bigIncrements('prod_id',);
      bigInt('vend_id', unsigned: true);
      string('prod_name', length: 25);
      decimal('prod_price', precision: 10, scale: 2);
      text('prod_desc');

      primary('prod_id');
      foreign('vend_id', 'vendors', 'vend_id');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();

    await dropIfExists('products');
  }
}