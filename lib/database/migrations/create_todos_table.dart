import 'package:vania/vania.dart';

class CreateTodosTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('todos', () {
      id();
      bigInt('user_id', unsigned: true);
      string('title');
      text('description');

      foreign('user_id', 'user', 'id');
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('todos');
  }
}
