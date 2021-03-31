import 'package:flutter/material.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/helpers/helpers.dart';
import 'package:wiredbrain/enums/enums.dart';
import 'package:wiredbrain/models/cart_item.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/services/firestore.dart';
import 'package:wiredbrain/widgets/button.dart';
import 'package:wiredbrain/widgets/loading_snack_bar.dart';

import '../widgets/coffee_additions.dart';
import '../widgets/coffee_count.dart';
import '../widgets/coffee_size.dart';
import '../widgets/coffee_sugar.dart';
import '../models/coffee.dart';
import '../constants.dart';

class MenuDetails extends StatefulWidget {
  const MenuDetails({
    required this.id,
  });

  static String routeName = 'loginScreen';
  static Route<MenuDetails> route({
    required String id,
  }) {
    return MaterialPageRoute<MenuDetails>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => MenuDetails(
        id: id,
      ),
    );
  }

  final String id;

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  final FirestoreService _firestoreService = FirestoreService.instance;
  final AuthService _authService = AuthService.instance;

  int totalCount = 1;
  CoffeeCupSize size = CoffeeCupSize.medium;
  CoffeeSugarCube sugar = CoffeeSugarCube.no;
  List<CoffeeAddition> additions = [CoffeeAddition.cake];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Coffee>(
      stream: _firestoreService.getCoffee(widget.id),
      builder: (context, AsyncSnapshot<Coffee> snapshot) {
        if (snapshot.hasData) {
          final Coffee coffee = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(coffee.name),
            ),
            body: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  color: lightBrown,
                  child: Icon(
                    coffee.iconData,
                    size: 120,
                    color: brown,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CoffeeCount(
                          price: coffee.price,
                          notifyValue: (int count) {
                            setState(() {
                              totalCount = count;
                            });
                          },
                        ),
                        Divider(height: 3),
                        CoffeeSize(
                          onPressed: (CoffeeCupSize cupSize) {
                            setState(() {
                              size = cupSize;
                            });
                          },
                          size: size,
                          icon: coffee.iconData,
                        ),
                        Divider(height: 3),
                        CoffeeSugar(
                          sugar: sugar,
                          onPressed: (CoffeeSugarCube sugarSize) {
                            setState(() {
                              sugar = sugarSize;
                            });
                          },
                        ),
                        Divider(height: 3),
                        CoffeeAdditions(
                          additions: additions,
                          onPressed: (List<CoffeeAddition> coffeeAdditions) {
                            setState(() {
                              additions = coffeeAdditions;
                            });
                          },
                        ),
                        Divider(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Total:",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              "\$${total(coffee.price)}",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                        CommonButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              loadingSnackBar(
                                text: "Adding to Cart...",
                              ),
                            );

                            await _firestoreService.addToUserCart(
                              _authService.currentUser!.uid,
                              CartItem(
                                coffee: coffee,
                                size: size,
                                sugar: sugar,
                                count: totalCount,
                                additions: additions,
                              ),
                            );

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Added to cart!'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            CoffeeRouter.instance.pop();
                          },
                          text: 'Add to cart',
                          highlighColor: true,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  num total(price) {
    return getCartItemsTotal(
      count: totalCount,
      price: price,
      additions: additions.length,
      size: size.index,
      sugar: sugar.index,
    );
  }
}
