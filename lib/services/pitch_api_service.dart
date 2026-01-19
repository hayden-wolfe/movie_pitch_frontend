import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_pitch_generator/models/pitch_result.dart';

/// Service for communicating with the movie pitch generation API.
class PitchApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String generatePitchEndpoint = '/generate-pitch';

  final http.Client _client;

  PitchApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Generates a movie pitch based on the provided wheel selections.
  Future<PitchResult> generatePitch({
    required List<String> characters,
    required List<String> locations,
    required List<String> genres,
    required List<String> creatives,
  }) async {
    final uri = Uri.parse('$baseUrl$generatePitchEndpoint');

    final requestBody = {
      'characters': characters,
      'locations': locations,
      'genres': genres,
      'creatives': creatives,
    };

    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return PitchResult.fromJson(jsonData);
      } else {
        throw PitchApiException(
          'Failed to generate pitch: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is PitchApiException) rethrow;
      throw PitchApiException('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Exception thrown when the pitch API fails.
class PitchApiException implements Exception {
  final String message;
  final int? statusCode;

  PitchApiException(this.message, {this.statusCode});

  @override
  String toString() => 'PitchApiException: $message';
}
