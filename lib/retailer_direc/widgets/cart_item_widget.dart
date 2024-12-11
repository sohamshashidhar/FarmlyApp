
import 'dart:async';

import 'package:app/retailer_direc/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({super.key, required this.cartItem});

  final Product cartItem;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Icon(
          IconlyLight.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        // if (direction == DismissDirection.endToStart) {
        //   return await showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text("Delete Item"),
        //         content: const Text(
        //           "Are you sure you want to delete this item?",
        //         ),
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               Navigator.of(context).pop(false);
        //             },
        //             child: const Text("No"),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               Navigator.of(context).pop(true);
        //             },
        //             child: const Text("Yes"),
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }
        // return false;
        final completer = Completer<bool>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text("Removed ${widget.cartItem.name} from cart?"),
            action: SnackBarAction(
              label: "Keep",
              onPressed: () {
                completer.complete(false);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        Timer(const Duration(seconds: 3), () {
          if (!completer.isCompleted) {
            completer.complete(true);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        });

        return await completer.future;
      },
      child: SizedBox(
        height: 135,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(
              color: Colors.grey.shade400,
              width: 0.2,
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.all(10.0),
            child: Row(
              children: [
                // IMAGE OF THE PRODUCT
                Container(
                  width: 90,
                  height: double.infinity,
                  margin:  EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage("assets/${widget.cartItem.image}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // OTHER INFORMATION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cartItem.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.cartItem.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${widget.cartItem.price}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          SizedBox(
                            height: 30,
                            child: ToggleButtons(
                                onPressed: (index) {
                                  setState(() {
                                    if (index == 0 && quantity > 0) {
                                      quantity--; // Decrease quantity
                                    } else if (index == 2) {
                                      quantity++; // Increase quantity
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(99),
                                isSelected: [true, false, true],
                                constraints: const BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 30,
                                ),
                                children: [
                                  const Icon(Icons.remove, size: 20),
                                  Text(
                                    "$quantity",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Icon(Icons.add, size: 20),
                                ],
                              ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
