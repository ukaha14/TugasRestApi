import 'package:vania/vania.dart';
import 'package:tugasrestapi/app/models/todo.dart';

class TodoController extends Controller {

  Future<Response> index() async {
    return Response.json({
      'message': 'Hello World',
    });
  }

  Future<Response> store(Request request) async {
    request.validate({
      'title': 'required',
      'description': 'required',
    }, {
      'title.required': 'Judul todo wajib diisi',
      'description.required': 'Deskripsi todo wajib diisi',
    });

    Map<String, dynamic> data = request.all();
    
    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      var todo = await Todo().query().create({
        'user_id': Auth().id(),
        'title': data['title'],
        'description': data['description'],
      });

      return Response.json({
        'status': 'success',
        'message': 'Todo berhasil dibuat',
        'data': todo,
      }, 201); 
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak terautentikasi',
      }, 401); 
    }
  }
}

final TodoController todoController = TodoController();
