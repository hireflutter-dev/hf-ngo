import 'package:Gifts/src/common/providers/cart_provider.dart';
import 'package:Gifts/src/common/providers/events_provider.dart';
import 'package:Gifts/src/common/providers/individual_event_provider.dart';
import 'package:Gifts/src/common/widgets/badge.dart';
import 'package:Gifts/src/screens/list_of_ngos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';

import 'package:share/share.dart';

class EventDetailScreen extends StatelessWidget {
  static const routeName = '/eventDetailScreen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String; // is the id
    print(id);

    final loadedEvent = Provider.of<EventsProvider>(
      context,
      listen: false,
    ).findById(id);

    // final String ngoTitle = Provider.of<NgosProvider>(context).eventNgo;

    // _addNgoToEvent(context) {
    //   final String ngoTitle = Provider.of<NgosProvider>(context).eventNgo;

    //   if (ngoTitle == null) {
    //     return MaterialButton(
    //       minWidth: double.infinity,
    //       color: Colors.lightBlueAccent,
    //       onPressed: () {
    //         Navigator.of(context).pushNamed(ListOfNgos.routeName);
    //       },
    //       child: Text(
    //         'Add NGO',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     );
    //   } else {
    //     Text(ngoTitle);
    //     Provider.of<EventsProvider>(context)
    //         .updateEvent(loadedEvent.eventId, loadedEvent);
    //   }
    // }

    // final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedEvent.eventTitle),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: _buildImageStackContainer(loadedEvent),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildNgoTitleCard(loadedEvent, context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: _buildEventDetailsContainer(loadedEvent),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _share(context, loadedEvent),
        label: Text('Invite friends'),
      ),
    );
  }

  void _share(BuildContext context, IndividualEventProvider loadedEvent) {
    final RenderBox box = context.findRenderObject();
    final String text =
        'You are cordially invited to ${loadedEvent.description} at my ${loadedEvent.eventTitle} party. You can donate to: ${loadedEvent.ngoTitle}. Invite Link: https://docs.google.com/presentation/d/e/2PACX-1vQ-LlEGOXkRGd0ZqTFqTHQlOGh2Svjms56PW68gromfHJ_Izl2VUHSm9ZQKpyxKj4VI70GW9BZ7GBht/pub?start=false&loop=false&delayms=3000';

    Share.share(
      text,
      subject: loadedEvent.eventTitle,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Card _buildNgoTitleCard(
      IndividualEventProvider loadedEvent, BuildContext context) {
    return Card(
      // elevation: 2,
      color: loadedEvent.ngoTitle == null ? Colors.white : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: loadedEvent.ngoTitle == null
                  ? Text(
                      'Add NGO to raise funds',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )
                  : Text(
                      'You are raising funds for',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child:
                  //  _addNgoToEvent(context),
                  loadedEvent.ngoTitle == null
                      ? MaterialButton(
                          minWidth: double.infinity,
                          color: Colors.lightBlueAccent,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ListOfNgosScreen.routeName);
                          },
                          child: Text(
                            'Add NGO',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListTile(
                          title: Text(
                            loadedEvent.ngoTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Your guests will be able to make a contribution',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 10,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildImageStackContainer(IndividualEventProvider loadedEvent) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            loadedEvent.imageUrl,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              loadedEvent.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }

  Container _buildEventDetailsContainer(IndividualEventProvider loadedEvent) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            loadedEvent.description,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          Text(
            'Date: ${loadedEvent.date}',
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          Text(
            'Venue: ${loadedEvent.venue}',
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          Text(
            'Location: ${loadedEvent.venueAddress}',
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: <Widget>[
//     // Text(
//     //   '\INR ${loadedCause.price}',
//     //   style: TextStyle(
//     //     color: Colors.grey,
//     //     fontSize: 20,
//     //   ),
//     // ),

//     //         ListView.builder(
//     // itemCount: taskProvider.taskCount,
//     // itemBuilder: (context, i) {
//     //   final _task = taskProvider.tasks[i];
//     //   return TaskTile(
//     //     taskTitle: _task.name,
//     //     isChecked: _task.isDone,
//     //     checkboxCallback: (checkboxState) {
//     //       taskProvider.updateTask(_task);
//     //     },
//     //     onLongPressCallback: () {
//     //       taskProvider.deleteTask(_task);
//     //     },
//     //   );

//   ],
// ),
// SizedBox(
//   height: 10,
// ),

// Consumer<NgosProvider>(
//   builder: (context, ngosData, _) => Padding(
//     padding: EdgeInsets.all(8),
//     child: showModalBottomSheet(context: context, builder: (ctc) {

//     } )
//   ),
// ),
