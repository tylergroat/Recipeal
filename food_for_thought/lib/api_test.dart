import 'dart:convert';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

List<dynamic> users = [];

Future<void> testTheAPI() async {
  print('testing API connection');
  const url =
      'https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=b3cfc04c&app_key=50ba4c92fad5f4d056dff68a6f2547a5';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
}
