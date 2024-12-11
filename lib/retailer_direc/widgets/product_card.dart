import 'package:app/retailer_direc/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details page when the card is tapped
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.grey.shade400, width: 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.product.image),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Handle image loading errors
                    print("Error loading image: $exception");
                  },
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        // Handle add to favorites/bookmark
                      },
                      icon: const Icon(IconlyLight.bookmark),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // Product Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  // Ratings
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < widget.product.rating
                            ? Colors.orange
                            : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Price
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "₹${widget.product.price}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      // Quantity Control
                      quantity == 0
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                                // Add to cart logic here (use product for cart)
                              },
                              icon: const Icon(Icons.add),
                            )
                          : SizedBox(
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
                            ),
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
