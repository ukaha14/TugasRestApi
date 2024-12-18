import 'package:vania/vania.dart';
import 'package:tugasrestapi/app/models/user.dart';
import 'package:vania/src/exception/validation_exception.dart';

class UserController extends Controller {

  Future<Response> index() async {
    Map? user = Auth().user();

    if (user != null) {
      user.remove('password');
      return Response.json({
        'status': 'success',
        'message': 'Data pengguna berhasil diambil',
        'data': user,
      });
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak terautentikasi',
      }, 401);
    }
  }

  Future<Response> updatePassword(Request request) async {
    try {
      request.validate({
        'current_password': 'required',
        'password': 'required|min_length:6|confirmed'
      }, {
        'current_password.required': 'Kolom password saat ini wajib diisi.',
        'password.required': 'Kolom password baru wajib diisi.',
        'password.min_length': 'Inputan password minimal 6 karakter.',
        'password.confirmed': 'Konfirmasi password tidak sesuai.'
      });

      String currentPassword = request.string('current_password');

      Map<String, dynamic>? userData = Auth().user();

      if (userData != null) {
        if (Hash().verify(currentPassword, userData['password'])) {
          await User()
              .query()
              .where('id', '=', Auth().id())
              .update({'password': Hash().make(request.string('password'))});
          return Response.json(
              {'status': 'success', 'massage': 'Password berhasil diperbarui.'},
              200);
        } else {
          return Response.json(
              {'status': 'error', 'message': 'Password saat ini tidak cocok.'},
              401);
        }
      } else {
        return Response.json(
            {'status': 'error', 'message': 'Pengguna tidak tersedia'}, 404);
      }
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      }

      print('Error: ${e.toString()}');
      print('Stacktrace: ${StackTrace.current}');

      return Response.json({
        'message': 'Terjadi kesalahan di sisi server.'
      }, 500);
    }
  }
}
final UserController userController = UserController();