import 'package:Gifts/src/common/providers/events_provider.dart';
import 'package:Gifts/src/screens/event_detail_screen.dart';
import 'package:Gifts/src/screens/register_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserEventItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          EventDetailScreen.routeName,
          arguments: (id),
        );
      },
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RegisterEventScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<EventsProvider>(context, listen: false)
                      .deleteEvent(id);
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
      ),
    );
  }
}
