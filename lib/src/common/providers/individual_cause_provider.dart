import 'package:Gifts/src/common/api/rest_api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final dbUrl = RestAPI.server;

class IndividualCauseProvider extends ChangeNotifier {
  IndividualCauseProvider({
    @required this.id,
    @required this.causeTitle,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  final String id;
  final String causeTitle;
  final String description;
  final String imageUrl;
  bool isFavorite;

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = dbUrl +
        'userFavorites/' +
        userId +
        '/' +
        id +
        '.json' +
        '?auth=' +
        token;

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
      // throw error;
    }
  }
}
