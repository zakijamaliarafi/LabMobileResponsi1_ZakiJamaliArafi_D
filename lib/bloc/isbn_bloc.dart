import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/isbn.dart';

class IsbnBloc {
  static Future<List<Isbn>> getIsbns() async {
    String apiUrl = ApiUrl.listIsbn;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listIsbn = (jsonObj as Map<String, dynamic>)['data'];
    List<Isbn> isbns = [];
    for (int i = 0; i < listIsbn.length; i++) {
      isbns.add(Isbn.fromJson(listIsbn[i]));
    }
    return isbns;
  }

  static Future addIsbn({Isbn? isbn}) async {
    String apiUrl = ApiUrl.createIsbn;

    var body = {
      "isbn_code": isbn!.isbnCode,
      "format": isbn.format,
      "print_length": isbn.printLength.toString()
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateIsbn({required Isbn isbn}) async {
    String apiUrl = ApiUrl.updateIsbn(isbn.id!);
    print(apiUrl);

    var body = {
      "isbn_code": isbn.isbnCode,
      "format": isbn.format,
      "print_length": isbn.printLength.toString()
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteIsbn({int? id}) async {
    String apiUrl = ApiUrl.deleteIsbn(id!);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
