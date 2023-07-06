import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class RestApi {
  final _url = 'valorant-api.com';
  final client = http.Client();

  Future<Map<String, dynamic>> fetchAgent() async {
    log('fetch agents');
    try {
      final uri = Uri.https(_url, '/v1/agents');
      final response = await http.get(uri);

      log('response api', error: response.statusCode);

      if(response.statusCode < 400){
        final responseBody = jsonDecode(response.body);

        return responseBody;
      }
      

      
    } catch (e) {
      log('fetch error', error: e);
    }
    return {};
  } 
}