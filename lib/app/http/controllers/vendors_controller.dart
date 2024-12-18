import 'package:vania/vania.dart';
import 'package:tugasrestapi/app/models/vendors.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorsController extends Controller {

  // Get all vendors
  Future<Response> index() async {
    try {
      final vendors = await Vendors().query().get();
      return Response.json(vendors);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan data vendor.',
        'error': e.toString()
      }, 500);
    }
  }

  // Create a new vendor
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'vend_name': 'required|string',
        'vend_address': 'required|string',
        'vend_kota': 'required|string',
        'vend_state': 'required|string',
        'vend_zip': 'required|numeric',
        'vend_country': 'required|string',
      });

      final vendorData = request.input();

      // Log data yang diterima
      print("Vendor Data Received: $vendorData");

      // Tambahkan created_at field
      vendorData['created_at'] = DateTime.now().toIso8601String();

      // Simpan data ke database
      await Vendors().query().insert(vendorData);

      return Response.json({
        'message': 'Vendor berhasil dibuat.',
        'data': vendorData,
      }, 201);
    } catch (e) {
      // Menampilkan error validasi secara lebih jelas
      if (e is ValidationException) {
        print('Validation Errors: ${e.message}'); // Menampilkan pesan error validasi
        return Response.json({'message': 'Gagal membuat vendor.', 'error': e.message}, 400);
      }

      print("Error creating vendor: $e");
      return Response.json({
        'message': 'Gagal membuat vendor.',
        'error': e.toString()
      }, 500);
    }
  }


  Future<Response> show(int id) async {
    try {
      final vendor = await Vendors().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan.'}, 404);
      }
      return Response.json(vendor);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan detail vendor.',
        'error': e.toString()
      }, 500);
    }
  }

  // Update a vendor
  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'vend_name': 'required|string',
        'vend_address': 'required|string',
        'vend_kota': 'required|string',
        'vend_state': 'required|string',
        'vend_zip': 'required|numeric',
        'vend_country': 'required|string',
      });

      final vendorData = request.input();

      vendorData['updated_at'] = DateTime.now().toIso8601String();

      final updated = await Vendors()
          .query()
          .where('vend_id', '=', id)  // Perbaiki di sini dengan vend_id
          .update({
            'updated_at': vendorData['updated_at'],
          });

      if (updated == 0) {
        return Response.json({'message': 'Vendor tidak ditemukan.'}, 404);
      }

      return Response.json({
        'message': 'Vendor berhasil diperbarui.',
        'data': vendorData,
      });
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui vendor.',
        'error': e.toString()
      }, 500);
    }
  }

  // Delete a vendor
  Future<Response> destroy(int id) async {
    try {
      final deleted = await Vendors().query().where('vend_id', '=', id).delete();

      if (deleted == 0) {
        return Response.json({'message': 'Vendor tidak ditemukan.'}, 404);
      }

      return Response.json({'message': 'Vendor berhasil dihapus.'});
    } catch (e) {
      return Response.json({
        'message': 'Gagal menghapus vendor.',
        'error': e.toString()
      }, 500);
    }
  }
}

final VendorsController vendorsController = VendorsController();