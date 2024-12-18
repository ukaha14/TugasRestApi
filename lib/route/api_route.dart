import 'package:tugasrestapi/app/http/controllers/auth_controller.dart';
import 'package:tugasrestapi/app/http/controllers/customers_controller.dart';
import 'package:tugasrestapi/app/http/controllers/orderitems_controller.dart';
import 'package:tugasrestapi/app/http/controllers/orders_controller.dart';
import 'package:tugasrestapi/app/http/controllers/productnotes_controller.dart';
import 'package:tugasrestapi/app/http/controllers/products_controller.dart';
import 'package:tugasrestapi/app/http/controllers/todo_controller.dart';
import 'package:tugasrestapi/app/http/controllers/user_controller.dart';
import 'package:tugasrestapi/app/http/controllers/vendors_controller.dart';
import 'package:tugasrestapi/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override

  void register(){

    Router.basePrefix('api');

    //Customers
    Router.get('/customers/{id}', customersController.show);
    Router.post('/customers', customersController.store);
    Router.put('/customers/{id}', customersController.update);
    Router.delete('/customers/{id}', customersController.destroy);

    //Orders
    Router.get('/orders', ordersController.index);
    Router.post('/orders', ordersController.store);
    Router.get('/orders/{id}', ordersController.show);
    Router.put('/orders/{id}', ordersController.update);
    Router.delete('/orders/{id}', ordersController.destroy);

    //Vendors 
    Router.get("/vendors", vendorsController.index);
    Router.post("/vendors", vendorsController.store);
    Router.get("/vendors/{id}", vendorsController.show);
    Router.put("/vendors/{id}", vendorsController.update);
    Router.delete("/vendors/{id}", vendorsController.destroy);

    //Vendors Routes
    Router.get("/products", productsController.index);
    Router.post("/products", productsController.store);
    Router.get("/products/{id}", productsController.show);
    Router.put("/products/{id}", productsController.update);
    Router.delete("/products/{id}", productsController.destroy);

    //Vendors Routes
    Router.get("/productnotes", productNotesController.index);
    Router.post("/productnotes", productNotesController.store);
    Router.get("/productnotes/{id}", productNotesController.show);
    Router.put("/productnotes/{id}", productNotesController.update);
    Router.delete("/productnotes/{id}", productNotesController.destroy);

    //OrderItems
    Router.get("/orderitems", orderItemsController.index);
    Router.post("/orderitems", orderItemsController.store);
    Router.get("/orderitems/{id}", orderItemsController.show);
    Router.put("/orderitems/{id}", orderItemsController.update);
    Router.delete("/orderitems/{id}", orderItemsController.destroy);

    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.get('me', authController.me).middleware([AuthenticateMiddleware()]);

    Router.group(() {
      Router.patch('update-password', userController.updatePassword);
      Router.get('', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);

    Router.group(() {
      Router.post('todo', todoController.store);
    }, prefix: 'todo', middleware: [AuthenticateMiddleware()]);

  }
}