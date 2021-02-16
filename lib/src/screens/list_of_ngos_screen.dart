import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:Gifts/src/common/widgets/user_ngo_item.dart';
import 'package:Gifts/src/screens/register_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'ngo_detail_screen.dart';

class ListOfNgosScreen extends StatelessWidget {
  static const routeName = '/listOfNgosScreen';

  Future<void> _refreshNgos(BuildContext context) async {
    await Provider.of<NgosProvider>(context, listen: false).fetchAndSetNgos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Organization'),
      ),
      body: FutureBuilder<void>(
        future: _refreshNgos(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshNgos(context),
                child: Consumer<NgosProvider>(
                  builder: (context, ngosData, _) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Thank you for your interest in creating an event. Please select an organization to move forward',
                        ),
                        Divider(),
                        Container(
                          // height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
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
                                      // Navigator.of(context).pushNamed(
                                      //   NgoDetailScreen.routeName,
                                      //   arguments: ngosData.items[i].id,
                                      // );
                                      ngosData.addNgoToEvent(
                                        ngosData.items[i].ngoTitle,
                                        ngosData.items[i].id,
                                      );
                                      // Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed(
                                          RegisterEventScreen.routeName);
                                    }),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
