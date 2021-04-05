import 'package:flutter/material.dart';
import 'package:wiredbrain/models/models.dart';
import 'package:wiredbrain/services/services.dart';

class CartBadge extends StatelessWidget {
  CartBadge({
    required this.child,
    this.color,
    required this.top,
    required this.right,
  });

  final FirestoreService _firestoreService = FirestoreService.instance;
  final AuthService _authService = AuthService.instance;

  final double top;
  final double right;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItem>?>(
        stream: _firestoreService.getUserCart(_authService.currentUser!.uid),
        builder: (context, AsyncSnapshot<List<CartItem>?> snapshot) {
          int cartItems = 0;

          if (snapshot.hasError) {
            print(snapshot.error);
            print('Error!');
            return SizedBox();
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              cartItems = snapshot.data!.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  child,
                  Positioned(
                    right: right,
                    top: top,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: color != null ? color : Colors.red,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartItems.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          }
          return SizedBox();
        });
  }
}
