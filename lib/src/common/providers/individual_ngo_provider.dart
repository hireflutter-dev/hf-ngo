import 'dart:convert';
import 'package:Gifts/src/common/api/rest_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

final dbUrl = RestAPI.server;

class IndividualNgo extends ChangeNotifier {
  IndividualNgo({
    this.id,
    this.ngoTitle,
    this.causeId,
    this.causeTitle,
    this.description,
    this.imageUrl,
    this.address,
    this.registrationCertificateUrl,
    this.contactPerson,
    this.phone,
    this.mobile,
    this.email,
    this.bankAccountNumber,
    this.ifsc,
    this.paymentUrl,
    this.isFavorite = false,
  });

  final String id;
  final String ngoTitle;
  final String causeId;
  final String causeTitle;
  final String description;
  final String address;
  final String imageUrl;
  final String registrationCertificateUrl; //check back
  final String contactPerson;
  final String phone;
  final String mobile;
  final String email;
  final String bankAccountNumber;
  final String ifsc;
  final String paymentUrl;
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
        'ngoFavorites/' +
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
