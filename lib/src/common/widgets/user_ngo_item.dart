import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNgoItem extends StatelessWidget {
  final String id;
  final String ngoTitle;
  final String imageUrl;
  final String causeId;
  final String causeTitle;
  final Function() onTapCallback;

  UserNgoItem({
    @required this.id,
    @required this.ngoTitle,
    @required this.imageUrl,
    @required this.causeId,
    @required this.causeTitle,
    @required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    return ListTile(
      onTap: onTapCallback,
      title: Text(ngoTitle),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /// get it working in the next phase
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   color: Theme.of(context).primaryColor,
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(
          //       RegisterOrganizationScreen.routeName,
          //       arguments: UserNgoItem(
          //         id,
          //         ngoTitle,
          //         imageUrl,
          //         causeId,
          //         causeTitle,
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<NgosProvider>(context, listen: false)
                    .deleteNgo(id);
              } catch (error) {
                _scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Deleting failed!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}
