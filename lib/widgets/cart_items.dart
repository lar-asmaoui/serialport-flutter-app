import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_calculator/controllers/cart_controller.dart';

// import '../providers/bags.dart';

class CartItems extends StatelessWidget {
  const CartItems({super.key});
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
        ),
        itemCount: cartController.items.length,
        itemBuilder: (context, index) => Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'kg ${cartController.items[index].weight}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('قمح ${index + 1}'),
                ),
                trailing: IconButton(
                  color: Theme.of(context).colorScheme.error,
                  icon: const Icon(Icons.delete),
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    cartController.removeItem(
                      cartController.items[index].id,
                    );
                  },
                ),
              ),
            ));
  }
}
