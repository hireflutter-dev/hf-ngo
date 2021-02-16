import 'package:Gifts/src/common/providers/individual_cause_provider.dart';
import 'package:Gifts/src/screens/ngos_listing_for_cause.dart';
import 'package:Gifts/src/screens/register_organization_screen.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CauseItem extends StatelessWidget {
  final String causeId;
  final String causeTitle;
  final int causeFilter;
  CauseItem(this.causeId, this.causeTitle, this.causeFilter);

  @override
  Widget build(BuildContext context) {
    final cause = Provider.of<IndividualCauseProvider>(context, listen: false);
    final causeId = cause.id;
    final causeTitle = cause.causeTitle;

    // final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    // print('product rebuilds');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              NgosListingForCause.routeName,
              arguments: CauseItem(
                causeId,
                causeTitle,
                causeFilter,
              ),
            );
          },
          child: Image.network(
            cause.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: Consumer<IndividualCauseProvider>(
          builder: (context, cause, _) => GridTileBar(
            leading: IconButton(
              icon: Icon(
                cause.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cause.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            cause.causeTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CauseItem2 extends StatelessWidget {
  final String causeId;
  final String causeTitle;
  final int causeFilter;
  CauseItem2(this.causeId, this.causeTitle, this.causeFilter);

  @override
  Widget build(BuildContext context) {
    final cause = Provider.of<IndividualCauseProvider>(context, listen: false);
    final causeId = cause.id;
    final causeTitle = cause.causeTitle;

    // final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    // print('product rebuilds');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RegisterOrganizationScreen.routeName,
              arguments: CauseItem2(
                causeId,
                causeTitle,
                causeFilter,
              ),
            );
          },
          child: Image.network(
            cause.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: Consumer<IndividualCauseProvider>(
          builder: (context, cause, _) => GridTileBar(
            leading: IconButton(
              icon: Icon(
                cause.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cause.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            cause.causeTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
