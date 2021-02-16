import 'dart:convert';
import 'package:Gifts/src/common/api/rest_api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final dbUrl = RestAPI.server;

class IndividualEventProvider extends ChangeNotifier {
  IndividualEventProvider({
    this.eventId,
    this.eventTitle,
    this.description,
    this.ngoId, //
    this.ngoTitle, //
    this.imageUrl,
    this.contactEmail,
    this.contactMobile,
    this.date,
    this.venue,
    this.venueAddress,
    this.isFavorite = false,
    // this.authToken,
  });

  final String eventId;
  final String eventTitle;
  final String description;
  final String ngoId;
  final String ngoTitle;
  final String imageUrl;
  final String contactEmail;
  final String contactMobile;
  final String date;
  final String venue;
  final String venueAddress;

  bool isFavorite;
  // final String authToken;

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = dbUrl +
        'eventFavorites/' +
        userId +
        '/' +
        eventId +
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
