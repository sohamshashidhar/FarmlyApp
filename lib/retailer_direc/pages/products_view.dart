
import 'package:app/retailer_direc/data/product.dart';
import 'package:app/retailer_direc/models/product.dart';
import 'package:app/retailer_direc/widgets/filter_dialog_widget.dart';
import 'package:app/retailer_direc/widgets/product_card.dart';
import 'package:app/retailer_direc/widgets/product_tile.dart';
import 'package:flutter/material.dart';


import 'package:flutter_iconly/flutter_iconly.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //FILTER AND SEARCH TEXT FIELD
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(99),
                          ),
                        ),
                        prefixIcon: const Icon(IconlyLight.search),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton.filled(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FilterDialog();
                          },
                        );
                      },
                      icon: const Icon(IconlyLight.filter),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "All Products",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isListView? const Icon(Icons.list) : const  Icon(Icons.grid_on),
                    // Text(
                    //   "List  ",
                    //   style: Theme.of(context).textTheme.bodyLarge,
                    // ),
                    
                  ],
                ),
              ],
            ),
            isListView ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exampleProducts.length,
              itemBuilder: (context, index) {
                return ProductTile(cartItem: exampleProducts[index]);
              },
            ) :GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: exampleProducts.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: 0.8,
  ),
  itemBuilder: (context, index) {
    return ProductCardRetail(product: exampleProducts[index]);
  },
),


          ],
        ),
      ),
    );
  }
}

class ProductCardRetail extends StatefulWidget {
  final Product product;

  const ProductCardRetail({super.key, required this.product});

  @override
  _ProductCardRetailState createState() => _ProductCardRetailState();
}

class _ProductCardRetailState extends State<ProductCardRetail> {
  int quantity = 1; // Default quantity

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event, e.g., navigate to product details page
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/${widget.product.image}"), // Replace with your image source
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Product Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 16,
                        color: index < widget.product.rating
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Product Price
                  Text(
                    "₹${widget.product.price}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity and Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Control
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _decrementQuantity,
                          ),
                          Text(
                            '$quantity',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _incrementQuantity,
                          ),
                        ],
                      ),
                      // Action Buttons (e.g., Add to Cart / Favorite)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(IconlyLight.chart),
                            onPressed: () {
                              // Handle adding product to cart
                            },
                          ),
                          IconButton(
                            icon: const Icon(IconlyLight.bookmark),
                            onPressed: () {
                              // Handle adding product to favorites
                            },
                          ),
                        ],
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


