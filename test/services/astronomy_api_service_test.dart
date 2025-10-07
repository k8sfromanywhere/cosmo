import 'dart:convert';

import 'package:cosmo/services/astronomy_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const expectedAppId = 'a68328c7-c146-4dff-a5da-5cd318450fba';
  const expectedAppSecret =
      '2c6397f08a407f1417f3fbb191b29ff1e81b5999a37f3ddc030680c39a3f8308'
      'df7c2c2e71e1bc9a56a76b82e9ccf8b82bb52a9c6b0e9439ab53af686aa6cfd9'
      '44f085e94a59896e7c1497b6480024544ae2461f7fdd4aedc9526f89382c8061'
      '05d761ca553feb35b12a5cc91a994131';

  final expectedAuthHeader = 'Basic ${base64Encode(
    utf8.encode('$expectedAppId:$expectedAppSecret'),
  )}';

  group('AstronomyApiService.fetchBodyPosition', () {
    test('requests specific body and returns decoded payload', () async {
      late Uri capturedUri;
      late Map<String, String> capturedHeaders;

      final mockClient = MockClient((request) async {
        capturedUri = request.url;
        capturedHeaders = request.headers;

        return http.Response(
          jsonEncode({
            'data': {
              'table': {'rows': []},
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = AstronomyApiService(httpClient: mockClient);
      final result = await service.fetchBodyPosition(
        bodyId: 'mars',
        latitude: 38.775867,
        longitude: -84.39733,
        fromDate: '2024-01-01',
        toDate: '2024-01-01',
        time: '12:00:00',
        elevation: 0,
        output: 'table',
      );

      expect(result, containsPair('data', isA<Map<String, dynamic>>()));
      expect(capturedUri.path, '/api/v2/bodies/positions/mars');
      expect(capturedUri.queryParameters['latitude'], '38.775867');
      expect(capturedUri.queryParameters['longitude'], '-84.39733');
      expect(capturedUri.queryParameters['from_date'], '2024-01-01');
      expect(capturedUri.queryParameters['to_date'], '2024-01-01');
      expect(capturedUri.queryParameters['time'], '12:00:00');
      expect(capturedUri.queryParameters['output'], 'table');
      expect(capturedHeaders['Authorization'], expectedAuthHeader);
    });
  });

  group('AstronomyApiService.fetchAllPositions', () {
    test('requests aggregated positions and returns decoded payload', () async {
      late Uri capturedUri;

      final mockClient = MockClient((request) async {
        capturedUri = request.url;

        return http.Response(
          jsonEncode({'data': []}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = AstronomyApiService(httpClient: mockClient);

      final response = await service.fetchAllPositions(
        latitude: 50.0,
        longitude: 30.0,
        fromDate: '2024-02-02',
        toDate: '2024-02-03',
        time: '06:30:00',
        elevation: 100,
        output: 'vector',
      );

      expect(response, containsPair('data', isA<List<dynamic>>()));
      expect(capturedUri.path, '/api/v2/bodies/positions');
      expect(capturedUri.queryParameters['latitude'], '50.0');
      expect(capturedUri.queryParameters['longitude'], '30.0');
      expect(capturedUri.queryParameters['from_date'], '2024-02-02');
      expect(capturedUri.queryParameters['to_date'], '2024-02-03');
      expect(capturedUri.queryParameters['time'], '06:30:00');
      expect(capturedUri.queryParameters['elevation'], '100');
      expect(capturedUri.queryParameters['output'], 'vector');
    });

    test('throws ClientException when API responds with error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal error', 500);
      });

      final service = AstronomyApiService(httpClient: mockClient);

      expect(
        () => service.fetchAllPositions(
          latitude: 0,
          longitude: 0,
          fromDate: '2024-02-02',
          toDate: '2024-02-02',
          time: '00:00:00',
        ),
        throwsA(isA<http.ClientException>()),
      );
    });
  });
}
