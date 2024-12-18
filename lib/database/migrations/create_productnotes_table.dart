import 'package:vania/vania.dart';

class CreateProductNotesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    await createTableNotExists('productnotes', () {
      bigIncrements('note_id');
      bigInt('prod_id', unsigned: true);
      date('note_date');
      text('note_text');

      primary('note_id');
      foreign('prod_id', 'products', 'prod_id');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();

    await dropIfExists('productnotes');
  }
}