import 'dart:convert';
import 'package:http/http.dart' as http;

class AstronomyApiService {
  static const String _appId = 'a68328c7-c146-4dff-a5da-5cd318450fba';
  static const String _appSecret =
      '2c6397f08a407f1417f3fbb191b29ff1e81b5999a37f3ddc030680c39a3f8308'
      'df7c2c2e71e1bc9a56a76b82e9ccf8b82bb52a9c6b0e9439ab53af686aa6cfd9'
      '44f085e94a59896e7c1497b6480024544ae2461f7fdd4aedc9526f89382c8061'
      '05d761ca553feb35b12a5cc91a994131';

  final http.Client _httpClient;

  AstronomyApiService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> fetchAllPositions({
    required double latitude,
    required double longitude,
    required String fromDate, // формат YYYY-MM-DD
    required String toDate, // формат YYYY-MM-DD
    required String time, // формат HH:MM:SS
    int elevation = 0,
    String output = 'table',
  }) async {
    final credentials = '$_appId:$_appSecret';
    final base64Auth = base64Encode(utf8.encode(credentials));

    final uri = Uri.https('api.astronomyapi.com', '/api/v2/bodies/positions', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'from_date': fromDate,
      'to_date': toDate,
      'time': time,
      'elevation': elevation.toString(),
      'output': output,
    });

    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Basic $base64Auth'},
    );

    if (response.statusCode != 200) {
      throw http.ClientException(
        'Ошибка ${response.statusCode}: ${response.body}',
        uri,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchBodyPosition({
    required String bodyId,
    required double latitude,
    required double longitude,
    required String fromDate, // формат YYYY-MM-DD
    required String toDate, // формат YYYY-MM-DD
    required String time, // формат HH:MM:SS
    int elevation = 0,
    String output = 'table',
  }) async {
    final credentials = '$_appId:$_appSecret';
    final base64Auth = base64Encode(utf8.encode(credentials));

    final uri =
        Uri.https('api.astronomyapi.com', '/api/v2/bodies/positions/$bodyId', {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'from_date': fromDate,
          'to_date': toDate,
          'time': time,
          'elevation': elevation.toString(),
          'output': output,
        });

    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Basic $base64Auth'},
    );

    if (response.statusCode != 200) {
      throw http.ClientException(
        'Ошибка ${response.statusCode}: ${response.body}',
        uri,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void dispose() => _httpClient.close();
}
