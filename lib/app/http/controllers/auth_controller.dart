import 'dart:io';
import 'package:vania/vania.dart';
import 'package:tugasrestapi/app/models/user.dart';

class AuthController extends Controller {

  Future<Response> register(Request request) async {
      request.validate({
        'name': 'required',
        'email': 'required|email',
        'password': 'required|min_length:6|confirmed',
      }, {
        'name.required': 'nama tidak boleh kosong',
        'email.required': 'email tidak boleh kosong',
        'email.email': 'email tidak valid',
        'password.required': 'password tidak boleh kosong',
        'password.min_length': 'password harus terdiri dari minimal 6 karakter',
        'password.confirmed': 'konfirmasi password tidak sesuai',
      });

      final name = request.input('name');
      final email = request.input('email');
      var password = request.input('password');

      var user = await User().query().where('email', '=', email).first();
      if (user != null) {
        return Response.json({
          "message": "user sudah ada",
        }, 409);
      }

      password = Hash().make(password);
      await User().query().insert({
        "name": name,
        "email": email,
        "password": password,
        "created_at": DateTime.now().toIso8601String(),
      });

      return Response.json({"message": "berhasil mendaftarkan user"}, 201);
    }


  Future<Response> login(Request request) async {
    request.validate({
      'email': 'required|email',
      'password': 'required',
    }, {
      'email.required': 'Email tidak boleh kosong',
      'email.email': 'Email tidak valid',
      'password.required': 'Password tidak boleh kosong',
    });

    final email = request.input('email');
    var password = request.input('password').toString();

    var user = await User().query().where('email', email).first();

    if (user == null) {
      return Response.json({
        "message": "User belum terdaftar",
      }, 409); 
    }

    if (!Hash().verify(password, user['password'])) {
      return Response.json({
        "message": "Kata sandi yang Anda masukkan salah",
      }, 401); 
    }

    final token = await Auth()
        .login(user)
        .createToken(expiresIn: Duration(days: 30), withRefreshToken: true);

    return Response.json({
      "message": "Berhasil login",
      "token": token,
    });
  }

  Future<Response> me() async{
    Map? user = Auth().user();

    if (user !=null) {
      user.remove('password');
      return Response.json({
        "message" : "Berhasil",
        "data" : user,
      }, HttpStatus.ok);
    }
    
    return Response.json({
      "massage" : "Berhasil",
      "data" : "",
    }, HttpStatus.notFound);
  }
}

final AuthController authController = AuthController();