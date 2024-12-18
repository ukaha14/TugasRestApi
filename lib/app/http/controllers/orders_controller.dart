import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugasrestapi/app/models/orders.dart';

class OrdersController extends Controller {
  
  Future<Response> index() async {
    try {
      final orders = await Orders().query().get();
      return Response.json(orders);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan data pesanan.',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|numeric',
        'order_date': 'required|date',
      });

      final orderData = request.input();

      // Add created_at field
      orderData['created_at'] = DateTime.now().toIso8601String();

      await Orders().query().insert(orderData);

      return Response.json({
        'message': 'Pesanan berhasil dibuat.',
        'data': orderData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        print('Validation Errors: ${e.message}');
        return Response.json({'message': 'Gagal membuat pesanan.', 'error': e.message}, 400);
      }
      return Response.json({'message': 'Terjadi kesalahan.', 'error': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final order = await Orders().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({'message': 'Pesanan tidak ditemukan.'}, 404);
      }
      return Response.json(order);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan detail pesanan.',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
          return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      // Validasi input
      request.validate({
        'cust_id': 'required|numeric',
        'order_date': 'required|date',
      }, {
        'cust_id.required': 'ID Customer harus diisi.',
        'order_date.required': 'Tanggal pesanan harus diisi.',
      });

      final orderData = request.input();
      print('Data input: $orderData');

      // Hapus field 'id' jika ada
      orderData.remove('id');

      // Validasi nilai tidak null
      if (orderData['cust_id'] == null || orderData['order_date'] == null) {
        return Response.json({
          'message': 'Data tidak lengkap.',
          'error': 'cust_id atau order_date tidak boleh null.'
        }, 400);
      }

      // Konversi dan validasi format tanggal
      try {
        final parsedDate = DateTime.parse(orderData['order_date'].toString());
        orderData['order_date'] = parsedDate.toIso8601String();
      } catch (e) {
        return Response.json({
          'message': 'Tanggal pesanan tidak valid.',
          'error': 'Format tanggal harus sesuai dengan YYYY-MM-DD.'
        }, 400);
      }

      // Tambahkan updated_at
      orderData['updated_at'] = DateTime.now().toIso8601String();

      print('Order data after processing: $orderData');

      // Update data di database
      final updated = await Orders()
          .query()
          .where('order_num', '=', id)
          .update({
            'cust_id': orderData['cust_id'],
            'order_date': orderData['order_date'],
            'updated_at': orderData['updated_at'],
          });

      print('Updated rows: $updated');

      if (updated == 0) {
        return Response.json({'message': 'Pesanan tidak ditemukan.'}, 404);
      }

      return Response.json({
        'message': 'Pesanan berhasil diperbarui.',
        'data': orderData,
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'errors': e.message}, 400);
      }
      return Response.json({
        'message': 'Gagal memperbarui pesanan.',
        'error': e.toString()
      }, 500);
    }
  }


  Future<Response> destroy(int id) async {
    try {
      final deleted = await Orders().query().where('order_num', '=', id).delete();

      if (deleted == 0) {
        return Response.json({'message': 'Pesanan tidak ditemukan.'}, 404);
      }

      return Response.json({'message': 'Pesanan berhasil dihapus.'});
    } catch (e) {
      return Response.json({
        'message': 'Gagal menghapus pesanan.',
        'error': e.toString()
      }, 500);
    }
  }
}

final OrdersController ordersController = OrdersController();
