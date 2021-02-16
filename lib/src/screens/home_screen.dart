import 'package:Gifts/src/common/providers/events_provider.dart';
import 'package:Gifts/src/common/widgets/app_drawer.dart';
import 'package:Gifts/src/common/widgets/registration_card_grid.dart';
import 'package:Gifts/src/common/widgets/rounded_button.dart';
import 'package:Gifts/src/screens/causes_overview_screen.dart';
// import 'package:Gifts/src/screens/ngos_listing_for_cause.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_of_ngos_screen.dart';
import 'user_events_screen.dart';

// String cardTitle;
// String cardImageUrl;

class HomeScreen extends StatelessWidget {
  static const routeName = '/homeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Gift My Wish'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: MediaQuery.of(context).size.height * 0.3,
              child: RegistrationCardGrid(
                cardTitle: 'Socially Responsible Gifting!',
                fontColor: Colors.black,
                fontSize: 20.0,
                cardImageUrl:
                    'https://images.unsplash.com/photo-1527903789995-dc8ad2ad6de0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=707&q=80',
                onTapCallback: () {},
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              // padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RegistrationCardGrid(
                      cardTitle: 'My Events',
                      backgroundColor: Colors.black45.withOpacity(0.75),
                      fontSize: 18.0,
                      cardImageUrl:
                          'https://images.pexels.com/photos/169192/pexels-photo-169192.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                      onTapCallback: () {
                        Provider.of<EventsProvider>(context, listen: false)
                                    .fetchAndSetEvents() ==
                                null
                            ? Navigator.of(context).pushNamed(
                                // RegisterEventScreen.routeName,
                                ListOfNgosScreen.routeName)
                            : Navigator.of(context)
                                .pushNamed(UserEventsScreen.routeName);
                        // Navigator.of(context).pushNamed(
                        //     CausesOverviewScreen.routeName,
                        //     arguments: 'addOrg');
                      },
                    ),
                  ),
                  Expanded(
                    child: RegistrationCardGrid(
                      cardTitle: 'Create Event',
                      backgroundColor: Colors.black45.withOpacity(0.75),
                      fontSize: 18.0,
                      cardImageUrl:
                          'https://images.pexels.com/photos/50675/banquet-wedding-society-deco-50675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                      onTapCallback: () {
                        Navigator.of(context).pushNamed(
                            // RegisterEventScreen.routeName,
                            ListOfNgosScreen.routeName);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    // NgosListingForCause.routeName,
                    CausesOverviewScreen.routeName);
              },
              title: 'Donate or Volunteer',
              color: Colors.blue,
            ),
            // RoundedButton(
            //   onPressed: () {
            //     Navigator.of(context)
            //         .pushNamed(CausesOverviewScreen.routeName);
            //   },
            //   title: 'Volunteer',
            //   color: Colors.blue,
            // ),
          ],
        ),
      ),
    );
  }
}
