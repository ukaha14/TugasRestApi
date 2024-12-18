import 'package:vania/vania.dart';

class CreateUserTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('user', () {
      id();
      string('name', length: 100);
      string('email', length: 150);
      string('password', length: 140);
      dateTime('created_at', nullable: true);
      dateTime('updated_at', nullable: true);
      dateTime('deleted_at', nullable: true);
      //timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('user');
  }
}