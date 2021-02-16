import 'package:flutter/material.dart';

enum FilterOptions {
  Favorites,
  All,
}

class FilterWidget extends StatefulWidget {
  final bool showFavoritesOnly;
  FilterWidget(this.showFavoritesOnly);
  @override
  _FilterWidgetState createState() =>
      _FilterWidgetState(this.showFavoritesOnly);
}

class _FilterWidgetState extends State<FilterWidget> {
  bool showFavoritesOnly;

  _FilterWidgetState(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        setState(() {
          if (selectedValue == FilterOptions.Favorites) {
            this.showFavoritesOnly = true;
          } else {
            showFavoritesOnly = false;
          }
        });
      },
      icon: Icon(Icons.filter_list),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('Only Favorites'),
          value: FilterOptions.Favorites,
        ),
        PopupMenuItem(
          child: Text('Show All'),
          value: FilterOptions.All,
        ),
      ],
    );
  }
}
