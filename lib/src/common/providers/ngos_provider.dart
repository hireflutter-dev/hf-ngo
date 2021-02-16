import 'dart:convert';
import 'package:Gifts/src/common/api/rest_api.dart';
import 'package:Gifts/src/common/providers/individual_ngo_provider.dart';
import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final dbUrl = RestAPI.server;
String uri;
var payload;
dynamic response;
// String causeFilter;

class NgosProvider extends ChangeNotifier {
  NgosProvider(this.authToken, this.userId, this._items);

  final String authToken;
  final String userId;
  List<IndividualNgo> _items = [];

  List<IndividualNgo> get items => [..._items];

  List<IndividualNgo> get favoriteItems {
    return _items.where((ngoItem) => ngoItem.isFavorite).toList();
  }

  IndividualNgo findById(String id) {
    return _items.firstWhere((ngo) => ngo.id == id);
  }

  IndividualNgo findByCauseTitle(String causeTitle) {
    return _items.firstWhere((ngo) => ngo.causeTitle == causeTitle);
  }

  String eventNgoTitle;
  String eventNgoId;

  Future<void> addNgoToEvent(ngoTitle, ngoId) async {
    eventNgoTitle = ngoTitle;
    eventNgoId = ngoId;
    print('in provider: $eventNgoTitle | $eventNgoTitle');

    notifyListeners();
  }

  List<String> ngoToCause = [];

  Future<void> addNgoToCause(causeId, id) async {
    if (causeId == id) {}
  }

  Future<void> fetchAndSetNgos(
      [bool filterByUser = false, bool filterByCause = false]) async {
    // final bla = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final filterString =
        filterByUser ? 'orderBy="sellerId"' + '&equalTo=' + '"$userId"' : '';
    final filterCauseString = filterByCause ? 'orderBy="causeId"' : '';
    //  + '&equalTo=' + '"$causeId"'
    var url = dbUrl +
        'ngos.json' +
        '?auth=' +
        authToken +
        '&' +
        filterString +
        filterCauseString;

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      url = dbUrl + 'ngoFavorites/' + userId + '.json' + '?auth=' + authToken;

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<IndividualNgo> loadedNgos = [];
      extractedData.forEach((ngoId, ngoData) {
        loadedNgos.add(IndividualNgo(
          id: ngoId,
          ngoTitle: ngoData['ngoTitle'],
          causeId: ngoData['causeId'],
          causeTitle: ngoData['causeTitle'],
          description: ngoData['description'],
          imageUrl: ngoData['imageUrl'],
          address: ngoData['address'],
          registrationCertificateUrl: ngoData['registrationCertificateUpload'],
          contactPerson: ngoData['contactPerson'],
          phone: ngoData['phone'],
          mobile: ngoData['mobile'],
          email: ngoData['email'],
          bankAccountNumber: ngoData['bankAccountNumber'],
          ifsc: ngoData['ifsc'],
          paymentUrl: ngoData['paymentUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[ngoId] ?? false,
        ));
      });
      _items = loadedNgos;
      notifyListeners();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> addNgo(IndividualNgo ngo) async {
    final url = dbUrl + 'ngos.json' + '?auth=' + authToken;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'ngoTitle': ngo.ngoTitle,
            'causeId': ngo.causeId,
            'causeTitle': ngo.causeTitle,

            'description': ngo.description,
            'address': ngo.address,
            'imageUrl': ngo.imageUrl,
            'registrationCertificateUpload':
                ngo.registrationCertificateUrl, //check back
            'contactPerson': ngo.contactPerson,
            'phone': ngo.phone,
            'mobile': ngo.mobile,
            'email': ngo.email,
            'bankAccountNumber': ngo.bankAccountNumber,
            'ifsc': ngo.ifsc,
            'paymentUrl': ngo.paymentUrl,
            'sellerId': userId,
          },
        ),
      );

      final newNgo = IndividualNgo(
          id: json.decode(response.body)['name'],
          ngoTitle: ngo.ngoTitle,
          causeId: ngo.causeId,
          causeTitle: ngo.causeTitle,
          description: ngo.description,
          imageUrl: ngo.imageUrl,
          address: ngo.address,
          registrationCertificateUrl:
              ngo.registrationCertificateUrl, //check back
          contactPerson: ngo.contactPerson,
          phone: ngo.phone,
          mobile: ngo.mobile,
          email: ngo.email,
          bankAccountNumber: ngo.bankAccountNumber,
          ifsc: ngo.ifsc,
          paymentUrl: ngo.paymentUrl);
      _items.add(newNgo);

      notifyListeners();
      print('notified... ${response.toString()}');
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateNgo(String id, IndividualNgo newNgo) async {
    final ngoIndex = _items.indexWhere((ngo) => ngo.id == id);

    if (ngoIndex >= 0) {
      final url = dbUrl + 'ngos/$id.json' + '?auth=' + authToken;

      try {
        http.patch(
          url,
          body: json.encode(
            {
              'ngoTitle': newNgo.ngoTitle,
              'causeId': newNgo.causeId,
              'causeTitle': newNgo.causeTitle,
              'description': newNgo.description,
              'imageUrl': newNgo.imageUrl,
              'address': newNgo.address,
              'registrationCertificateUpload':
                  newNgo.registrationCertificateUrl, //check back
              'contactPerson': newNgo.contactPerson,
              'phone': newNgo.phone,
              'mobile': newNgo.mobile,
              'email': newNgo.email,
              'bankAccountNumber': newNgo.bankAccountNumber,
              'ifsc': newNgo.ifsc,
              'paymentUrl': newNgo.paymentUrl,
            },
          ),
        );
        _items[ngoIndex] = newNgo;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  ///deleting ngo from db
  ///optimistic updating pattern to roll back if product ngo fails.
  Future<void> deleteNgo(String id) async {
    final url = dbUrl + 'ngos/$id.json' + '?auth=' + authToken;

    final existingNgoIndex = _items.indexWhere((ngo) => ngo.id == id);
    var existingNgo = _items[existingNgoIndex];
    _items.removeAt(existingNgoIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingNgoIndex, existingNgo);
      notifyListeners();
      throw HttpException('Could not delete Ngo.');
    }
    existingNgo = null;
  }
}
