import 'dart:io';
import 'package:vania/vania.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_productnotes_table.dart';
import 'create_vendors_table.dart';
import 'create_products_table.dart';
import 'create_orderitems_table.dart';
import 'create_user_table.dart';
import 'create_personal_access_tokens.dart';
import 'create_todos_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();

  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }

  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  Future<void> registry() async {
		 await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateProductNotesTable().up();
    await CreateOrderItemsTable().up();
		await CreateUserTable().up();
		await CreatePersonalAccessTokens().up();
    await CreateUserTable().up();
    await CreatePersonalAccessTokens().up();
		await CreateTodosTable().up();
	}

  Future<void> dropTables() async {
		await CreateTodosTable().down();
		await CreatePersonalAccessTokens().up();
    await CreateUserTable().up();
		await CreatePersonalAccessTokens().down();
		await CreateUserTable().down();
		await CreateOrderItemsTable().down();
    await CreateProductNotesTable().down();
    await CreateProductsTable().down();
    await CreateVendorsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomersTable().down();
	 }
}