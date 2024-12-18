import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugasrestapi/app/models/orderitems.dart';

class OrderItemsController extends Controller {
  
  Future<Response> index() async {
    try {
      final orderItems = await OrderItems().query().get();
      return Response.json(orderItems);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan data item pesanan.',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required|numeric',
        'prod_id': 'required|numeric',
        'quantity': 'required|numeric',
        'size': 'required|numeric',
      });

      final orderItemData = request.input();

      // Tambahkan created_at field
      orderItemData['created_at'] = DateTime.now().toIso8601String();

      await OrderItems().query().insert(orderItemData);

      return Response.json({
        'message': 'Item pesanan berhasil dibuat.',
        'data': orderItemData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'message': 'Validasi gagal.', 'error': e.message}, 400);
      }
      return Response.json({'message': 'Terjadi kesalahan.', 'error': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final orderItem = await OrderItems().query().where('order_item', '=', id).first();
      if (orderItem == null) {
        return Response.json({'message': 'Item pesanan tidak ditemukan.'}, 404);
      }
      return Response.json(orderItem);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan detail item pesanan.',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'order_num': 'required|numeric',
        'prod_id': 'required|numeric',
        'quantity': 'required|numeric',
        'size': 'required|numeric',
      }, {
        'order_num.required': 'Nomor pesanan harus diisi.',
        'prod_id.required': 'ID produk harus diisi.',
        'quantity.required': 'Jumlah produk harus diisi.',
        'size.required': 'Ukuran produk harus diisi.',
      });

      final orderItemData = request.input();

      // Tambahkan updated_at field
      orderItemData['updated_at'] = DateTime.now().toIso8601String();

      final updated = await OrderItems()
          .query()
          .where('order_item', '=', id)
          .update({
            'updated_at': orderItemData['updated_at'],
          });

      if (updated == 0) {
        return Response.json({'message': 'Item pesanan tidak ditemukan.'}, 404);
      }

      return Response.json({
        'message': 'Item pesanan berhasil diperbarui.',
        'data': orderItemData,
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'errors': e.message}, 400);
      }
      return Response.json({
        'message': 'Gagal memperbarui item pesanan.',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final deleted = await OrderItems().query().where('order_item', '=', id).delete();

      if (deleted == 0) {
        return Response.json({'message': 'Item pesanan tidak ditemukan.'}, 404);
      }

      return Response.json({'message': 'Item pesanan berhasil dihapus.'});
    } catch (e) {
      return Response.json({
        'message': 'Gagal menghapus item pesanan.',
        'error': e.toString()
      }, 500);
    }
  }
}

final OrderItemsController orderItemsController = OrderItemsController();