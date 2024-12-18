import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugasrestapi/app/models/customers.dart';
//

class CustomersController extends Controller {

     Future<Response> index() async {
          return Response.json({'message':'Hello World'});
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          try {
              request.validate({
                  //'cust_id': 'required|string|max_length:5',
                  'cust_name': 'required|string|max_length:50',
                  'cust_address': 'required|string|max_length:50',
                  'cust_city': 'required|string|max_length:20',
                  'cust_state': 'required|string|max_length:5',
                  'cust_zip': 'required|numeric|max_length:7',
                  'cust_country': 'required|string|max_length:25',
                  'cust_telp': 'required|numeric|max_length:15',
              }, {
                  //'cust_id.required': 'Customer ID wajib diisi.',
                  //'cust_id.string': 'Customer ID harus berupa teks.',
                  //'cust_id.max_length': 'Customer ID maksimal 5 karakter.',
                  'cust_name.required': 'Nama customer wajib diisi.',
                  'cust_name.string': 'Nama customer harus berupa teks.',
                  'cust_name.max_length': 'Nama customer maksimal 50 karakter.',
                  'cust_address.required': 'Alamat wajib diisi.',
                  'cust_address.string': 'Alamat harus berupa teks.',
                  'cust_address.max_length': 'Alamat maksimal 50 karakter.',
                  'cust_city.required': 'Kota wajib diisi.',
                  'cust_city.string': 'Kota harus berupa teks.',
                  'cust_city.max_length': 'Kota maksimal 20 karakter.',
                  'cust_state.required': 'State wajib diisi.',
                  'cust_state.string': 'State harus berupa teks.',
                  'cust_state.max_length': 'State maksimal 5 karakter.',
                  'cust_zip.required': 'Kode pos wajib diisi.',
                  'cust_zip.numeric': 'Kode pos harus berupa angka.',
                  'cust_zip.max_length': 'Kode pos maksimal 7 karakter.',
                  'cust_country.required': 'Negara wajib diisi.',
                  'cust_country.string': 'Negara harus berupa teks.',
                  'cust_country.max_length': 'Negara maksimal 25 karakter.',
                  'cust_telp.required': 'Nomor telepon wajib diisi.',
                  'cust_telp.numeric': 'Nomor telepon harus berupa angka.',
                  'cust_telp.max_length': 'Nomor telepon maksimal 15 karakter.',
              });

              final customerData = request.input();

              customerData['created_at'] = DateTime.now().toIso8601String();
            
              await Customers().query().insert(customerData);

              return Response.json({  
                  'message': 'Customer berhasil ditambahkan.',
                  'data': customerData,
              }, 201);
          } catch (e) {
              if (e is ValidationException) {
                  return Response.json({'errors': e.message}, 400);
              }
              return Response.json({'message': 'Terjadi kesalahan di sisi server.'}, 500);
          }

     }

     Future<Response> show(int id) async {
          final customer = await Customers().query().where('cust_id','=', id).first();
          if (customer == null) {
              return Response.json({'message': 'Customer tidak ditemukan.'}, 404);
          }
          return Response.json(customer);
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request, int id) async {
        try {
            // Validasi input
            request.validate({
                'cust_name': 'required|string|max_length:50',
                'cust_address': 'required|string|max_length:50',
                'cust_city': 'required|string|max_length:20',
                'cust_state': 'required|string|max_length:5',
                'cust_zip': 'required|numeric|max_length:7',
                'cust_country': 'required|string|max_length:25',
                'cust_telp': 'required|numeric',
            });
            // Ambil data input
            final customerData = request.input();
            if (customerData.containsKey('id')) {
                customerData['cust_id'] = customerData['id'];
                customerData.remove('id');
            }
            print('Data yang diterima: $customerData');

            customerData['updated_at'] = DateTime.now().toIso8601String();

            // Proses update di database
            final updated = await Customers()
                .query()
                .where('cust_id', '=', id)
                .update(customerData);
            if (updated == 0) {
                return Response.json({'message': 'Customer tidak ditemukan.'}, 404);
            }
            return Response.json({
                'message': 'Customer berhasil diperbarui.',
                'data': customerData,
            });
        } catch (e) {
            if (e is ValidationException) {
                return Response.json({'errors': e.message}, 400);
            }
            // Cetak error ke log untuk debugging
            print('Error: $e');
            return Response.json({'message': 'Terjadi kesalahan di sisi server.'}, 500);
        }
    }

     Future<Response> destroy(int id) async {
          final deleted = await Customers().query().where('cust_id','=', id).delete();
          if (deleted == 0) {
              return Response.json({'message': 'Customer tidak ditemukan.'}, 404);
          }
          return Response.json({'message': 'Customer berhasil dihapus.'});
     }
}

final CustomersController customersController = CustomersController();