import 'package:vania/vania.dart';
import 'package:tugasrestapi/app/models/products.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductsController extends Controller {
  
  // Get all products
  Future<Response> index() async {
    try {
      final products = await Products().query().get();
      return Response.json(products);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan data produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Create a new product
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'prod_name': 'required|string',
        'prod_price': 'required|numeric',
        'prod_desc': 'required|string',
        'vend_id': 'required|numeric',  // Vendor ID harus ada
      });

      final productData = request.input();

      // Log data yang diterima
      print("Product Data Received: $productData");

      // Tambahkan created_at field
      productData['created_at'] = DateTime.now().toIso8601String();

      // Simpan data ke database
      await Products().query().insert(productData);

      return Response.json({
        'message': 'Produk berhasil dibuat.',
        'data': productData,
      }, 201);
    } catch (e) {
      // Menampilkan error validasi secara lebih jelas
      if (e is ValidationException) {
        print('Validation Errors: ${e.message}'); // Menampilkan pesan error validasi
        return Response.json({'message': 'Gagal membuat produk.', 'error': e.message}, 400);
      }

      print("Error creating product: $e");
      return Response.json({
        'message': 'Gagal membuat produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Get a product by ID
  Future<Response> show(int id) async {
    try {
      final product = await Products().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json({'message': 'Produk tidak ditemukan.'}, 404);
      }
      return Response.json(product);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mendapatkan detail produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Update a product
  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'prod_name': 'required|string',
        'prod_price': 'required|numeric',
        'prod_desc': 'required|string',
        'vend_id': 'required|numeric', // Vendor ID harus ada
      });

      final productData = request.input();

      productData['updated_at'] = DateTime.now().toIso8601String();

      final updated = await Products()
          .query()
          .where('prod_id', '=', id)
          .update({
            'updated_at': productData['updated_at'],
          });

      if (updated == 0) {
        return Response.json({'message': 'Produk tidak ditemukan.'}, 404);
      }

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productData,
      });
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui produk.',
        'error': e.toString()
      }, 500);
    }
  }

  // Delete a product
  Future<Response> destroy(int id) async {
    try {
      final deleted = await Products().query().where('prod_id', '=', id).delete();

      if (deleted == 0) {
        return Response.json({'message': 'Produk tidak ditemukan.'}, 404);
      }

      return Response.json({'message': 'Produk berhasil dihapus.'});
    } catch (e) {
      return Response.json({
        'message': 'Gagal menghapus produk.',
        'error': e.toString()
      }, 500);
    }
  }
}

final ProductsController productsController = ProductsController();