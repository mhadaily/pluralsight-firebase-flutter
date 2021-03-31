import 'package:flutter/material.dart';
import 'package:wiredbrain/constants.dart';
import 'package:wiredbrain/models/additions.dart';
import 'package:wiredbrain/models/cup_size.dart';
import 'package:wiredbrain/models/order.dart';
import 'package:wiredbrain/models/order_status.dart';
import 'package:wiredbrain/models/sugar_cube.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/services/firestore.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = 'Orders';

  final FirestoreService _firestoreService = FirestoreService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: _firestoreService.getUserOrders(_authService.currentUser!.uid),
      builder: (context, AsyncSnapshot<List<Order>> snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'No orders',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ExpansionTile(
                  tilePadding: EdgeInsets.all(15),
                  leading: Icon(
                    order.status.iconData,
                    color: brown,
                  ),
                  title: Text(
                    order.status.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Order Id: ${order.id ?? ''}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'Updated: ${order.updated}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  childrenPadding: const EdgeInsets.all(15),
                  initiallyExpanded: false,
                  children: [
                    ...order.items.map(
                      (item) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${item.count} x ${item.coffee.name}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                item.coffee.iconData,
                                size: item.size.iconSize,
                              ),
                              SizedBox(width: 3),
                              if (item.sugar == CoffeeSugarCube.one)
                                Icon(
                                  item.sugar.iconData,
                                  size: item.size.iconSize,
                                ),
                              if (item.sugar == CoffeeSugarCube.two) ...[
                                Icon(
                                  item.sugar.iconData,
                                  size: item.size.iconSize,
                                ),
                                Icon(
                                  item.sugar.iconData,
                                  size: item.size.iconSize,
                                )
                              ],
                              ...item.additions
                                  .map(
                                    (CoffeeAddition addition) => Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Icon(
                                        addition.iconData,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                    Text(
                      'total: \$${order.total}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                );
              },
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
