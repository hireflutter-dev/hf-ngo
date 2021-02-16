import 'package:Gifts/src/screens/add_edit_cause_screen.dart';
import 'package:Gifts/src/screens/user_ngos_screen.dart';

import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello ${user.userId}'),
            // automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),

          // ListTile(
          //   leading: Icon(
          //     Icons.payment,
          //   ),
          //   title: Text('Orders'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(OrdersScreen.routeName);
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     Icons.edit,
          //   ),
          //   title: Text('Manage Products'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(UserProductsScreen.routeName);
          //   },
          // ),
          Container(
            color: Colors.grey.shade200,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Admin Functions',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Add a cause first and then the organization',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                  ),
                  title: Text('Add Cause'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(AddEditCauseScreen.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.group_work,
                  ),
                  title: Text('Manage Organizations'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(UserNgosScreen.routeName);
                  },
                ),
              ],
            ),
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
