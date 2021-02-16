import 'package:Gifts/src/common/providers/events_provider.dart';
import 'package:Gifts/src/common/widgets/buld_events_list.dart';
import 'package:Gifts/src/screens/list_of_ngos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventsScreen extends StatelessWidget {
  static const routeName = '/userEventsScreen';

  Future<void> _refreshEvents(BuildContext context) async {
    await Provider.of<EventsProvider>(context, listen: false)
        .fetchAndSetEvents(true);
  }

  final GlobalKey _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');

    return Scaffold(
      key: _scaffold,
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Events'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ListOfNgosScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _refreshEvents(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshEvents(context),
                    child: BuildEventsList(
                      onTapCallback: () => Navigator.of(context)
                          .pushNamed(ListOfNgosScreen.routeName),
                    ),
                  ),
        // BuildEventsList(),
      ),
    );
  }
}
