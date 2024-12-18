import 'package:vania/vania.dart';
import 'package:tugasrestapi/app/models/productnotes.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductNotesController extends Controller {
  
  // Get all product notes
  Future<Response> index() async {
    try {
      final productNotes = await Productnotes().query().get();
      return Response.json(productNotes);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan data catatan produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Create a new product note
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'prod_id': 'required|numeric',  // Product ID harus ada
        'note_date': 'required|date',
        'note_text': 'required|string',
      });

      final productNoteData = request.input();

      // Log data yang diterima
      print("Product Note Data Received: $productNoteData");

      // Tambahkan created_at field
      productNoteData['created_at'] = DateTime.now().toIso8601String();

      // Simpan data ke database
      await Productnotes().query().insert(productNoteData);

      return Response.json({
        'message': 'Catatan produk berhasil dibuat.',
        'data': productNoteData,
      }, 201);
    } catch (e) {
      // Menampilkan error validasi secara lebih jelas
      if (e is ValidationException) {
        print('Validation Errors: ${e.message}'); // Menampilkan pesan error validasi
        return Response.json({'message': 'Gagal membuat catatan produk.', 'error': e.message}, 400);
      }

      print("Error creating product note: $e");
      return Response.json({
        'message': 'Gagal membuat catatan produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Get a product note by ID
  Future<Response> show(int id) async {
    try {
      final productNote = await Productnotes().query().where('note_id', '=', id).first();
      if (productNote == null) {
        return Response.json({'message': 'Catatan produk tidak ditemukan.'}, 404);
      }
      return Response.json(productNote);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan detail catatan produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Update a product note
  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'prod_id': 'required|numeric',  // Product ID harus ada
        'note_date': 'required|date',
        'note_text': 'required|string',
      });

      final productNoteData = request.input();

      productNoteData['updated_at'] = DateTime.now().toIso8601String();

      final updated = await Productnotes()
          .query()
          .where('note_id', '=', id)
          .update({
            'updated_at': productNoteData['updated_at'],
          });

      if (updated == 0) {
        return Response.json({'message': 'Catatan produk tidak ditemukan.'}, 404);
      }

      return Response.json({
        'message': 'Catatan produk berhasil diperbarui.',
        'data': productNoteData,
      });
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui catatan produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Delete a product note
  Future<Response> destroy(int id) async {
    try {
      final deleted = await Productnotes().query().where('note_id', '=', id).delete();

      if (deleted == 0) {
        return Response.json({'message': 'Catatan produk tidak ditemukan.'}, 404);
      }

      return Response.json({'message': 'Catatan produk berhasil dihapus.'});
    } catch (e) {
      return Response.json({
        'message': 'Gagal menghapus catatan produk.',
        'error': e.toString()
      }, 500);
    }
  }
}

final ProductNotesController productNotesController = ProductNotesController();
