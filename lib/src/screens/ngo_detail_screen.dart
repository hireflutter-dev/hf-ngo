import 'package:Gifts/src/common/providers/cart_provider.dart';
import 'package:Gifts/src/common/providers/ngos_provider.dart';
import 'package:Gifts/src/common/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class NgoDetailScreen extends StatelessWidget {
  static const routeName = '/ngoDetailScreen';

  @override
  Widget build(BuildContext context) {
    final ngoId =
        ModalRoute.of(context).settings.arguments as String; // is the id

    final loadedNgo = Provider.of<NgosProvider>(
      context,
      listen: false,
    ).findById(ngoId);

    // final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedNgo.ngoTitle),
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
                loadedNgo.imageUrl,
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
                ElevatedButton(
                  // color: Colors.black,
                  // textColor: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const Text('Donate'),
                      const Icon(
                        Icons.shopping_cart,
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
                loadedNgo.description,
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
