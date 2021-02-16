import 'dart:convert';
import 'package:Gifts/src/common/api/rest_api.dart';
import 'package:Gifts/src/common/providers/individual_event_provider.dart';
import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final dbUrl = RestAPI.server;
// String uriString bla;

// String uri;
// var payload;
// dynamic response;

class EventsProvider extends ChangeNotifier {
  EventsProvider(this.authToken, this.userId, this._items);

  final String authToken;
  final String userId;
  List<IndividualEventProvider> _items = [];

  List<IndividualEventProvider> get items => [..._items];

  List<IndividualEventProvider> get favoriteItems =>
      _items.where((eventItem) => eventItem.isFavorite).toList();

  IndividualEventProvider findById(String id) =>
      _items.firstWhere((event) => event.eventId == id);

  overloadNgosProvider(context) {
    Provider.of<NgosProvider>(context);
  }

  Future<void> fetchAndSetEvents([bool filterByUser = false]) async {
    // final bla = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final filterString =
        filterByUser ? 'orderBy="sellerId"' + '&equalTo=' + '"$userId"' : '';
    // final filterCauseString = filterByNgo ? 'orderBy="ngoId"' : '';
    //  + '&equalTo=' + '"$causeId"'
    var url = dbUrl + 'events.json' + '?auth=' + authToken + '&' + filterString;
    //  +filterCauseString;

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      url = dbUrl + 'eventFavorites/' + userId + '.json' + '?auth=' + authToken;

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<IndividualEventProvider> loadedEvents = [];
      extractedData.forEach((eventId, eventData) {
        loadedEvents.add(IndividualEventProvider(
          eventId: eventId,
          imageUrl: eventData['imageUrl'],
          ngoId: eventData['ngoId'],
          eventTitle: eventData['eventTitle'],
          ngoTitle: eventData['ngoTitle'],
          description: eventData['description'],
          contactEmail: eventData['contactEmail'],
          contactMobile: eventData['contactMobile'],
          date: eventData['date'],
          venue: eventData['venue'],
          venueAddress: eventData['venueAddress'],
          isFavorite:
              favoriteData == null ? false : favoriteData[eventId] ?? false,
        ));
      });
      _items = loadedEvents;
      notifyListeners();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> addEvent(IndividualEventProvider event) async {
    print('..here in addEvent post call');
    final url = dbUrl + 'events.json' + '?auth=' + authToken;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'eventTitle': event.eventTitle,
            'ngoId': event.ngoId,
            'ngoTitle': event.ngoTitle,
            'description': event.description,
            'imageUrl': event.imageUrl,
            'contactEmail': event.contactEmail,
            'contactMobile': event.contactMobile,
            'date': event.date.toString(),
            'venue': event.venue,
            'venueAddress': event.venueAddress,
            'sellerId': userId,
          },
        ),
      );

      final newEvent = IndividualEventProvider(
        eventId: json.decode(response.body)['name'],
        eventTitle: event.eventTitle,
        ngoId: event.ngoId,
        ngoTitle: event.ngoTitle,
        description: event.description,
        imageUrl: event.imageUrl,
        contactEmail: event.contactEmail,
        contactMobile: event.contactMobile,
        date: event.date,
        venue: event.venue,
        venueAddress: event.venueAddress,
      );
      _items.add(newEvent);

      notifyListeners();
      print('notified... ${response.toString()}');
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateEvent(String id, IndividualEventProvider newEvent) async {
    final eventIndex = _items.indexWhere((event) => event.eventId == id);

    if (eventIndex >= 0) {
      final url = dbUrl + 'events/$id.json' + '?auth=' + authToken;

      try {
        http.patch(
          url,
          body: json.encode(
            {
              'eventTitle': newEvent.ngoTitle,
              'ngoId': newEvent.ngoId,
              'ngoTitle': newEvent.ngoTitle,
              'description': newEvent.description,
              'imageUrl': newEvent.imageUrl,
              'contactEmail': newEvent.contactEmail,
              'contactMobile': newEvent.contactMobile,
              'date': newEvent.date,
              'venue': newEvent.venue,
              'venueAddress': newEvent.venueAddress,
            },
          ),
        );
        _items[eventIndex] = newEvent;
        print('in update event');
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  ///deleting [event] from db
  ///optimistic updating pattern to roll back if [deleteEvent] fails.

  Future<void> deleteEvent(String id) async {
    final url = dbUrl + 'events/$id.json' + '?auth=' + authToken;

    final existingEventIndex =
        _items.indexWhere((event) => event.eventId == id);
    var existingEvent = _items[existingEventIndex];
    _items.removeAt(existingEventIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingEventIndex, existingEvent);
      notifyListeners();
      throw HttpException('Could not delete Ngo.');
    }
    existingEvent = null;
  }
}
