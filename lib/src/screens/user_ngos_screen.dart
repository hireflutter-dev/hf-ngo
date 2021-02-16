import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:Gifts/src/common/widgets/user_ngo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'causes_overview_screen.dart';
import 'ngo_detail_screen.dart';

class UserNgosScreen extends StatelessWidget {
  static const routeName = '/userNgosScreen';

  Future<void> _refreshNgos(BuildContext context) async {
    await Provider.of<NgosProvider>(context, listen: false).fetchAndSetNgos();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as String;
    print('rebuilding...');
    print(args);

    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your NGOs'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                CausesOverviewScreen.routeName,
                arguments: 'addOrg',
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _refreshNgos(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshNgos(context),
                    child: Consumer<NgosProvider>(
                      builder: (context, ngosData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: ngosData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserNgoItem(
                                  id: ngosData.items[i].id,
                                  ngoTitle: ngosData.items[i].ngoTitle,
                                  imageUrl: ngosData.items[i].imageUrl,
                                  causeId: ngosData.items[i].causeId,
                                  causeTitle: ngosData.items[i].causeTitle,
                                  onTapCallback: () {
                                    Navigator.of(context).pushNamed(
                                      NgoDetailScreen.routeName,
                                      arguments: ngosData.items[i].id,
                                    );
                                  }),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
