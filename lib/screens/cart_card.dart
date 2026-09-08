import 'package:flutter/material.dart';
import 'package:vroom/model/cart.dart';

class CartCard extends StatelessWidget{
  final CartItem cartItem;
  final VoidCallback increment;
  final VoidCallback decrement;

  const CartCard({
    super.key,
    required this.cartItem,
    required this.increment,
    required this.decrement
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.product.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.product.name),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Text('KES ${cartItem.product.price}'),

                      Spacer(flex: 1),

                      Row(children: [
                        IconButton(
                          onPressed: decrement, icon: Icon(Icons.remove)
                          ),
                        Text(cartItem.quantity.toString()),
                        IconButton(onPressed: increment, icon: Icon(Icons.add))
                      ],)


                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}