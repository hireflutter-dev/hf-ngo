import 'dart:convert';
import 'package:Gifts/src/common/api/rest_api.dart';
import '../models/http_exception.dart';
import 'individual_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final dbUrl = RestAPI.server;

class ProductsProvider extends ChangeNotifier {
  final String authToken;
  final String userId;
  List<IndividualProduct> _items = [];

  ProductsProvider(this.authToken, this.userId, this._items);

  List<IndividualProduct> get items => [..._items];

  List<IndividualProduct> get favoriteItems =>
      _items.where((prodItem) => prodItem.isFavorite).toList();

  IndividualProduct findById(String id) =>
      _items.firstWhere((prod) => prod.id == id);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // final bla = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final filterString =
        filterByUser ? 'orderBy="sellerId"' + '&equalTo=' + '"$userId"' : '';
    var url =
        dbUrl + 'products.json' + '?auth=' + authToken + '&' + filterString;

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      url = dbUrl + 'userFavorites/' + userId + '.json' + '?auth=' + authToken;

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<IndividualProduct> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(IndividualProduct(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> addProduct(IndividualProduct product) async {
    final url = dbUrl + 'products.json' + '?auth=' + authToken;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'sellerId': userId,
          },
        ),
      );

      final newProduct = IndividualProduct(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, IndividualProduct newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = dbUrl + 'products/$id.json' + '?auth=' + authToken;

      try {
        http.patch(
          url,
          body: json.encode(
            {
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            },
          ),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  ///deleting product from db
  ///optimistic updating pattern to roll back if product delete fails.
  Future<void> deleteProduct(String id) async {
    final url = dbUrl + 'products/$id.json' + '?auth=' + authToken;

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
