class ApiHeaders {
  static Future<Map<String, dynamic>> getHeaders() async {
    Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    return headers;
  }
}
