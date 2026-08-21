import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, String>> _items = [];

  List<Map<String, String>> get items => _items;

  void addItem(String judul, String harga, String foto) {
    _items.add({
      'judul': judul,
      'harga': harga,
      'foto': foto,
    });
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalPrice {
    return _items.fold<int>(
      0,
      (sum, item) => sum + int.parse(item['harga']!.replaceAll(RegExp(r'[^0-9]'), '')),
    );
  }
} 