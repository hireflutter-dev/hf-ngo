import 'package:Gifts/src/common/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'individual_cause_provider.dart';
import '../api/rest_api.dart';

final dbUrl = RestAPI.server;
enum FilterOptions {
  Favorites,
  All,
}

class CausesProvider extends ChangeNotifier {
  CausesProvider(this.authToken, this.userId, this._items);

  final String authToken;
  final String userId;
  List<IndividualCauseProvider> _items = [];
  var showFavoritesOnly = false;

  List<IndividualCauseProvider> get items => [..._items];

  List<IndividualCauseProvider> get favoriteItems =>
      _items.where((causeItem) => causeItem.isFavorite).toList();

  IndividualCauseProvider findById(String id) {
    return _items.firstWhere((cause) => cause.id == id);
  }

  Future<void> favoriteFilter(selectedValue) async {
    if (selectedValue == FilterOptions.Favorites) {
      showFavoritesOnly = true;
    } else {
      showFavoritesOnly = false;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetCauses([bool filterByUser = false]) async {
    // final bla = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final filterString =
        filterByUser ? 'orderBy="sellerId"' + '&equalTo=' + '"$userId"' : '';
    var url = dbUrl + 'causes.json' + '?auth=' + authToken + '&' + filterString;

    try {
      final response = await http.get(url);
      print('get response body: ' + json.decode(response.body).toString());

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      url = dbUrl + 'causeFavorites/' + userId + '.json' + '?auth=' + authToken;

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<IndividualCauseProvider> loadedCauses = [];
      extractedData.forEach((causeId, causeData) {
        loadedCauses.add(IndividualCauseProvider(
          id: causeId,
          causeTitle: causeData['causeTitle'],
          description: causeData['description'],
          imageUrl: causeData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[causeId] ?? false,
        ));
      });
      _items = loadedCauses;
      notifyListeners();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> addCause(IndividualCauseProvider cause) async {
    final url = dbUrl + 'causes.json' + '?auth=' + authToken;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'causeTitle': cause.causeTitle,
            'description': cause.description,
            'imageUrl': cause.imageUrl,
            'sellerId': userId,
          },
        ),
      );

      final newCause = IndividualCauseProvider(
        causeTitle: cause.causeTitle,
        description: cause.description,
        imageUrl: cause.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newCause);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCause(String id, IndividualCauseProvider newCause) async {
    final causeIndex = _items.indexWhere((cause) => cause.id == id);

    if (causeIndex >= 0) {
      final url = dbUrl + 'causes/$id.json' + '?auth=' + authToken;

      try {
        http.patch(
          url,
          body: json.encode(
            {
              'causeTitle': newCause.causeTitle,
              'description': newCause.description,
              'imageUrl': newCause.imageUrl,
            },
          ),
        );
        _items[causeIndex] = newCause;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteCause(String id) async {
    final url = dbUrl + 'causes/$id.json' + '?auth=' + authToken;

    final existingCauseIndex = _items.indexWhere((cause) => cause.id == id);
    var existingCause = _items[existingCauseIndex];
    _items.removeAt(existingCauseIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingCauseIndex, existingCause);
      notifyListeners();
      throw HttpException('Could not delete Cause.');
    }
    existingCause = null;
  }
}
