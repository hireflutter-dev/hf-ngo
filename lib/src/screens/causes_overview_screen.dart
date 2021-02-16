import 'package:Gifts/src/common/providers/causes_provider.dart';
import 'package:Gifts/src/common/widgets/causes_grid.dart';
import 'package:Gifts/src/common/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

var _showFavoritesOnly = false;

class CausesOverviewScreen extends StatelessWidget {
  static const routeName = '/causesOverviewScreen';

  Future<void> _refreshCauses(context) async {
    await Provider.of<CausesProvider>(context, listen: false)
        .fetchAndSetCauses();
  }

  // var showFavs = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as String;
    // final args2 = ModalRoute.of(context).settings.arguments as String;

    Text _title() {
      if (args == 'addOrg') {
        return Text('Select a cause');
      } else {
        return Text('Donate to causes');
      }
    }

    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: _title(),
        actions: <Widget>[
          FilterWidget(_showFavoritesOnly),
          // PopupMenuButton(
          //   onSelected: (FilterOptions selectedValue) {

          //     // setState(() {
          //     //   if (selectedValue == FilterOptions.Favorites) {
          //     //     _showFavoritesOnly = true;
          //     //   } else {
          //     //     _showFavoritesOnly = false;
          //     //   }
          //     // });
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
      body: FutureBuilder<void>(
        future: _refreshCauses(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshCauses(context),
                    child: Consumer<CausesProvider>(
                      builder: (context, causesData, _) => args == 'addOrg'
                          ? CausesGrid2(_showFavoritesOnly)
                          : CausesGrid(_showFavoritesOnly),
                    ),
                  ),
      ),
    );
  }
}
