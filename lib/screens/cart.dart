import 'package:flutter/material.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/constants.dart';
import 'package:wiredbrain/helpers/helpers.dart';
import 'package:wiredbrain/models/additions.dart';
import 'package:wiredbrain/models/cart_item.dart';
import 'package:wiredbrain/models/cup_size.dart';
import 'package:wiredbrain/models/sugar_cube.dart';
import 'package:wiredbrain/screens/menu.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/services/firestore.dart';
import 'package:wiredbrain/widgets/button.dart';

class CartScreen extends StatelessWidget {
  static String routeName = 'Shops';

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final FirestoreService _firestoreService = FirestoreService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    final String userId = _authService.currentUser!.uid;

    return StreamBuilder<List<CartItem>>(
      stream: _firestoreService.getUserCart(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final List<CartItem> items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(
                child: Text(
                  'No items',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            }

            final num cartTotal = items
                .map((item) => item.total)
                .reduce((value, element) => value + element);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedList(
                      key: listKey,
                      initialItemCount: items.length,
                      itemBuilder:
                          (context, index, Animation<double> animation) {
                        final item = items[index];
                        final num total = getCartItemsTotal(
                          count: item.count,
                          price: item.coffee.price,
                          additions: item.additions.length,
                          size: item.size.index,
                          sugar: item.sugar.index,
                        );
                        return Dismissible(
                          key: Key(item.id ?? '$index'),
                          background: Container(color: Colors.red[700]),
                          onDismissed: (direction) {
                            _firestoreService.deleteUserCartItem(
                                userId, item.id!);
                            listKey.currentState!.removeItem(
                              index,
                              (context, animation) {
                                return SizedBox();
                              },
                            );
                          },
                          direction: DismissDirection.endToStart,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {},
                              child: ListTile(
                                title: Text(
                                  item.coffee.name,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                leading: Text('${item.count}  x'),
                                trailing: Text(
                                  '\$${total.toString()}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      item.coffee.iconData,
                                      size: item.size.iconSize,
                                      color: brown,
                                    ),
                                    if (item.sugar == CoffeeSugarCube.one)
                                      Icon(
                                        item.sugar.iconData,
                                        color: brown,
                                      ),
                                    if (item.sugar == CoffeeSugarCube.two)
                                      Row(
                                        children: [
                                          Icon(
                                            item.sugar.iconData,
                                            color: brown,
                                          ),
                                          Icon(
                                            item.sugar.iconData,
                                            color: brown,
                                          ),
                                        ],
                                      ),
                                    ...item.additions
                                        .map(
                                          (e) => Icon(
                                            e.iconData,
                                            color: brown,
                                          ),
                                        )
                                        .toList()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: brown),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total:',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            '\$${cartTotal.toString()}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (items.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CommonButton(
                          text: 'Send Order',
                          highlighColor: true,
                          onPressed: () {
                            _firestoreService.submitOrder(userId, items);
                            CoffeeRouter.instance.pushReplacement(
                              MenuScreen.route(),
                            );
                          },
                        )
                      ],
                    )
                ],
              ),
            );
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
