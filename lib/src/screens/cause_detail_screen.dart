import 'package:Gifts/src/common/providers/cart_provider.dart';
import 'package:Gifts/src/common/providers/causes_provider.dart';
import 'package:Gifts/src/common/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class CauseDetailScreen extends StatelessWidget {
  static const routeName = '/causeDetailScreen';

  @override
  Widget build(BuildContext context) {
    final causeId =
        ModalRoute.of(context).settings.arguments as String; // is the id

    final loadedCause = Provider.of<CausesProvider>(
      context,
      listen: false,
    ).findById(causeId);

    // final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedCause.causeTitle),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedCause.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Text(
                //   '\INR ${loadedCause.price}',
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 20,
                //   ),
                // ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Text(
                        'Donate',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  onPressed: () {
                    // cart.addItem(
                    //     loadedCause.id, loadedCause.price, loadedCause.title);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedCause.description,
                textAlign: TextAlign.center,
                softWrap: true,
                // style: TextStyle(
                //   color: Colors.grey,
                //   fontSize: 20,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
