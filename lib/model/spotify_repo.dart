import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpotifyRepo {
  static var token;

  static Future<void> initializeService() async {
    var clientId = dotenv.env['CLIENT_ID'];
    var clientSecret = dotenv.env['CLIENT_SECRET'];

    var clientCredentials = '${clientId!}:${clientSecret!}';
    var bytes = utf8.encode(clientCredentials);
    var base64Str = base64.encode(bytes);

    var authOptions = {
      'url': 'https://accounts.spotify.com/api/token',
      'headers': {'Authorization': 'Basic $base64Str'},
      'body': {'grant_type': 'client_credentials'}
    };

    var response = await http.post(
      Uri.parse(authOptions['url'] as String),
      headers: authOptions['headers'] as Map<String, String>,
      body: authOptions['body'],
    );

    if (response.statusCode == 200) {
      token = json.decode(response.body)['access_token'];
      print('Token: $token');
    } else {
      print('Failed to fetch token: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> searchArtist(String artist) async {
    List<Map<String, dynamic>> result = [];
    artist = Uri.encodeComponent(artist);
    var url = "https://api.spotify.com/v1/search?q=$artist&type=artist&limit=5";
    var headers = {'Authorization': 'Bearer $token'};
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    print("Response $response");
    if (response.statusCode == 200) {
      Map<String, dynamic> data = await json.decode(response.body);

      List<dynamic> artists = data['artists']['items'];

      for (var artist in artists) {
        print("Artist: ${artist['name']}");
        result.add({
          'name': artist['name'],
          'image': artist['images'].isEmpty ? null : artist['images'][0]['url']
        });
      }
    } else {
      print("Failed to search artist: ${response.statusCode}");
    }
    return result;
  }
}
