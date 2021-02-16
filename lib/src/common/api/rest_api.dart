import 'package:http/http.dart' as http;
import 'dart:convert';

class RestAPI {
  var payload;

  static const String server = 'https://gifts-c5778.firebaseio.com/';
  static const apiKey = 'AIzaSyAZMbbuCVPxxMQoQQiBYEJGGgkRkXsm3iI';

  String uri;
  RestAPI(
    var payload,
    String uri,
  ) {
    this.payload = payload;
    this.uri = server + uri;
  }

  postData() async {
    print("In postData " + this.payload.toString() + " Uri " + uri);
    var response;
    try {
      response = await http
          .post(
        this.uri,
        body: this.payload,
      )
          .then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        return response;
      });
    } catch (error) {
      print(error.toString());
      throw error;
    }

    var body = json.decode(response.body);
    return body;
  }

  getData() async {
    print("Here in get data");
    var response = await http
        .get(
      this.uri,
    )
        .then((response) {
      return response;
    });

    var body = json.decode(response.body);
    return body;
  }

  getFile() async {
    var response = await http
        .get(
      this.uri,
    )
        .then((response) {
      return response;
    });

    return response.bodyBytes;
  }

  deleteData() async {
    var response = await http
        .delete(
      this.uri,
    )
        .then((response) {
      return response;
    });

    return response.bodyBytes;
  }
}
