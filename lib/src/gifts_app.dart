import 'package:Gifts/src/common/providers/individual_event_provider.dart';
import 'package:Gifts/src/common/providers/individual_ngo_provider.dart';

import 'package:Gifts/src/screens/add_edit_cause_screen.dart';
import 'package:Gifts/src/screens/cause_detail_screen.dart';
import 'package:Gifts/src/screens/causes_overview_screen.dart';
import 'package:Gifts/src/screens/event_detail_screen.dart';
import 'package:Gifts/src/screens/list_of_ngos_screen.dart';
import 'package:Gifts/src/screens/ngo_detail_screen.dart';
import 'package:Gifts/src/screens/ngos_listing_for_cause.dart';
import 'package:Gifts/src/screens/register_event_screen.dart';
import 'package:Gifts/src/screens/register_organization_screen.dart';
import 'package:Gifts/src/screens/user_events_screen.dart';
import 'package:Gifts/src/screens/user_ngos_screen.dart';
import 'common/providers/auth_provider.dart';
import 'common/providers/cart_provider.dart';
import 'common/providers/causes_provider.dart';
import 'common/providers/events_provider.dart';
import 'common/providers/individual_cause_provider.dart';
import 'common/providers/ngos_provider.dart';
import 'common/providers/orders_provider.dart';
import 'common/providers/products_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

String id, ngoTitle, bankAccountNumber, ifsc;

class GiftsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => IndividualEventProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (context, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: (_) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
          update: (context, auth, previousEvents) => EventsProvider(
            auth.token,
            auth.userId,
            previousEvents == null ? [] : previousEvents.items,
          ),
          create: (_) => EventsProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (context) => IndividualCauseProvider(
            id: null,
            causeTitle: null,
            description: null,
            imageUrl: null,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CausesProvider>(
          update: (context, auth, previousCauses) => CausesProvider(
            auth.token,
            auth.userId,
            previousCauses == null ? [] : previousCauses.items,
          ),
          create: (_) => CausesProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (context) => IndividualNgo(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, NgosProvider>(
          update: (context, auth, previousNgos) => NgosProvider(
            auth.token,
            auth.userId,
            previousNgos == null ? [] : previousNgos.items,
          ),
          create: (_) => NgosProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (context, auth, previousOrders) => OrdersProvider(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: (_) => OrdersProvider('', '', []),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gift My Wish',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            ProductsOverviewScreen.routeName: (context) =>
                ProductsOverviewScreen(),
            RegisterOrganizationScreen.routeName: (context) =>
                RegisterOrganizationScreen(),
            UserNgosScreen.routeName: (context) => UserNgosScreen(),
            CausesOverviewScreen.routeName: (context) => CausesOverviewScreen(),
            CauseDetailScreen.routeName: (context) => CauseDetailScreen(),
            AddEditCauseScreen.routeName: (context) => AddEditCauseScreen(),
            NgosListingForCause.routeName: (context) => NgosListingForCause(),
            NgoDetailScreen.routeName: (context) => NgoDetailScreen(),
            RegisterEventScreen.routeName: (context) => RegisterEventScreen(),
            UserEventsScreen.routeName: (context) => UserEventsScreen(),
            EventDetailScreen.routeName: (context) => EventDetailScreen(),
            ListOfNgosScreen.routeName: (context) => ListOfNgosScreen(),
          },
        ),
      ),
    );
  }
}
