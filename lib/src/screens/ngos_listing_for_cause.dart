// import 'package:Gifts/src/common/providers/individual_ngo_provider.dart';
import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:Gifts/src/common/widgets/cause_item.dart';
// import 'package:Gifts/src/common/widgets/filter_widget.dart';
import 'package:Gifts/src/common/widgets/ngos_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

var _showFavoritesOnly = false;

class NgosListingForCause extends StatelessWidget {
  static const routeName = '/ngosListingForCauseScreen';

  Future<void> _refreshNgos(BuildContext context) async {
    await Provider.of<NgosProvider>(context, listen: false).fetchAndSetNgos();
  }

  // var showFavs = false;

  @override
  Widget build(BuildContext context) {
    // CauseItem args = ModalRoute.of(context).settings.arguments;
    // final argsCauseId = args.causeId;

    try {
      return _buildScaffoldForGridView(context);
    } catch (error) {
      print(error);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:
              const Text('No organizations added as yet. Please visit later'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
    return null;
    // return _buildScaffoldForGridView(context);
  }

  Scaffold _buildScaffoldForGridView(context) {
    CauseItem args = ModalRoute.of(context).settings.arguments;
    final argsCauseId = args.causeId;
    final title = args.causeTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          // FilterWidget(showFavoritesOnly),
          // PopupMenuButton(
          //   onSelected: (FilterOptions selectedValue) {
          //     setState(() {
          //       if (selectedValue == FilterOptions.Favorites) {
          //         _showFavoritesOnly = true;
          //       } else {
          //         _showFavoritesOnly = false;
          //       }
          //     });
          //   },
          //   icon: Icon(Icons.filter_list),
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('Only Favorites'),
          //       value: FilterOptions.Favorites,
          //     ),
          //     PopupMenuItem(
          //       child: Text('Show All'),
          //       value: FilterOptions.All,
          //     ),
          //   ],
          // ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshNgos(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshNgos(context),
                child: Consumer<NgosProvider>(builder: (context, ngosData, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          // 'Donate to organizations dealing with ${args.causeTitle}',
                          'Donate or Volunteer for $title',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: NgosGrid(
                                  id: argsCauseId,
                                  showFavs: _showFavoritesOnly,
                                ) ==
                                null
                            ? const Text('bla')
                            : NgosGrid(
                                id: argsCauseId,
                                showFavs: _showFavoritesOnly,
                              ),
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }
}
