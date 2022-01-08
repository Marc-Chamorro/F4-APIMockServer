import 'package:api_to_sqlite/src/models/employee_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class EmployeeApiProvider {
  Future<List<Employee?>> getAllEmployees() async {
    var url = "http://demo6893197.mockable.io/persona";
    Response response = await Dio().get(url);

    return (response.data as List).map((employee) {
      // ignore: avoid_print
      print('Inserting $employee');
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }

  //Future<Object> postNewEmployee(int? id, String email, String firstName, String lastName, String avatar) async {
  Future<Response> postNewEmployee(int? id, String email, String firstName, String lastName, String avatar) async {
    var url = "http://demo6893197.mockable.io/persona";

    // if (id == null) {
    //   return 'USER DOES NOT EXIST IN BD';
    // }
    return (await Dio().post(url, data: {'id': id, 'email': email, 'firstName': firstName, 'lastName': lastName, 'avatar': avatar}));
  }

  Future<Response> deleteEmployee(int? id, String email, String firstName, String lastName, String avatar) async {
    var url = "http://demo6893197.mockable.io/persona";

    // if (id == null) {
    //   return 'USER DOES NOT EXIST IN BD';
    // }
    return (await Dio().delete(url, data: {'id': id, 'email': email, 'firstName': firstName, 'lastName': lastName, 'avatar': avatar}));
  }
}
