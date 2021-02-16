import 'package:Gifts/src/common/providers/individual_cause_provider.dart';
import 'package:Gifts/src/common/providers/individual_ngo_provider.dart';
import 'package:Gifts/src/screens/ngo_detail_screen.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NgoItem extends StatelessWidget {
  NgoItem(this.id);

  final String id;

  @override
  Widget build(BuildContext context) {
    final ngo = Provider.of<IndividualNgo>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);

    if (ngo.causeId == id) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: _buildNgoGridTile(context, ngo, authData),
      );
    } else {
      return const SizedBox();
    }
  }

  ClipRRect _buildNgoGridTile(
      BuildContext context, IndividualNgo ngo, AuthProvider authData) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        // MediaQuery.of(context).size.width * 0.75,
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                // CauseDetailScreen.routeName,
                // arguments: ngo.causeId,
                NgoDetailScreen.routeName,
                arguments: ngo.id,
              );
            },
            child: Image.network(
              ngo.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: Consumer<IndividualCauseProvider>(
            builder: (context, cause, _) => GridTileBar(
              backgroundColor: Colors.black87,
              trailing: IconButton(
                icon: Icon(
                  ngo.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  ngo.toggleFavoriteStatus(authData.token, authData.userId);
                },
              ),
              title: Text(
                ngo.ngoTitle,
                textAlign: TextAlign.center,
                // style: TextStyle(
                //   fontSize: 8,
                // ),
              ),
            ),
          ),
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topRight,
              child: Chip(
                backgroundColor: Colors.white.withOpacity(0.75),
                label: Text(
                  ngo.causeTitle,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
