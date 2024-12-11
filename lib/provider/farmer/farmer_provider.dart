import 'package:app/farmer_direc/dashboard/model/farmer_model.dart';
import 'package:app/farmer_direc/inventory/model/farmer_inventory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FarmerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFarmer(FarmerModel farmer) async {
    try {
      await _firestore.collection('farmers').doc(farmer.id).set(farmer.toFirestore());
      notifyListeners();  // Notify listeners to update UI or perform actions
    } catch (e) {
      print("Failed to add farmer: $e");
      // Handle errors as needed
    }
  }

Future<void> addInventoryItems(String farmerId, FarmerInventoryItem item) async {
  try {
    // Reference to the farmer's document
    final farmerDocRef = _firestore.collection('farmers').doc(farmerId);

    // Loop through each inventory item and add to the inventory sub-collection
    
      await farmerDocRef.collection('inventory').doc(item.itemId).set(item.toFirestore());
    

    notifyListeners();  // Notify listeners to update UI or perform actions
  } catch (e) {
    print("Failed to add inventory items: $e");
    // Handle errors as needed
  }
}


  Future<FarmerModel?> getFarmer(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('farmers').doc(id).get();
      if (doc.exists) {
        return FarmerModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Failed to get farmer: $e");
    }
    return null;
  }
Future<List<FarmerInventoryItem>> getInventoryList(String farmerId, [String? query]) async {
  try {
    final farmerDocRef = _firestore.collection('farmers').doc(farmerId);
    Query inventoryQuery = farmerDocRef.collection('inventory');

    if (query != null && query.isNotEmpty) {
      inventoryQuery = inventoryQuery.where('name', isGreaterThanOrEqualTo: query);
    }

    final snapshot = await inventoryQuery.get();
    final items = snapshot.docs.map((doc) {
  final data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>

if (data == null) {
  return FarmerInventoryItem(
    itemId: '',
    imageUrl: 'assets/placeholder.png',
    name: 'Unnamed Item',
    price: '0.0',
    kgCount: '0',
    farmerID: '',
  );
}

return FarmerInventoryItem(
  itemId: data['itemId'] ?? '',
  imageUrl: data['imageUrl'] ?? 'assets/placeholder.png',
  name: data['name'] ?? 'Unnamed Item',
  price: data['price'] ?? 0.0,
  kgCount: data['kgCount'] ?? 0,
  farmerID: data['farmerID'] ?? '',
);



    }).toList();

    return items;
  } catch (e) {
    print("Failed to get inventory list: $e");
    return [];
  }
}

  Future<FarmerInventoryItem?> getInventoryItemById(String farmerId, String itemId) async {
    try {
      // Reference to the farmer's document
      final farmerDocRef = _firestore.collection('farmers').doc(farmerId);

      // Fetch the item from the inventory sub-collection
      final doc = await farmerDocRef.collection('inventory').doc(itemId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return FarmerInventoryItem(
          itemId: data['itemId'],
          imageUrl: data['imageUrl'],
          name: data['name'],
          price: data['price'],
          kgCount: data['kgCount'],
          farmerID: data['farmerID'],
        );
      }
    } catch (e) {
      print("Failed to get inventory item by ID: $e");
      // Handle errors as needed
    }
    return null;
  }

  Future<void> deleteInventoryItem(String farmerId, String itemId) async {
  try {
    // Reference to the farmer's document
    final farmerDocRef = _firestore.collection('farmers').doc(farmerId);

    // Delete the item from the inventory sub-collection
    await farmerDocRef.collection('inventory').doc(itemId).delete();

    notifyListeners();  // Notify listeners to update the UI or perform actions
  } catch (e) {
    print("Failed to delete inventory item: $e");
    // Handle errors as needed
  }
}

}
