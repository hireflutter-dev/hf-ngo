import 'package:Gifts/src/common/providers/events_provider.dart';
import 'package:Gifts/src/common/widgets/user_event_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildEventsList extends StatelessWidget {
  final Function onTapCallback;

  const BuildEventsList({@required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(
      builder: (context, eventsData, _) => Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: eventsData.items.length == 0 ? 1 : eventsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              eventsData.items.length == 0
                  ? Center(
                      child: ListTile(
                        onTap: onTapCallback,
                        title: Text(
                          'You have not added an event yet',
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          'Tap here to get started',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : UserEventItem(
                      eventsData.items[i].eventId,
                      eventsData.items[i].eventTitle,
                      eventsData.items[i].imageUrl,
                    ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
