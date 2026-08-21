import '../models/sales.dart';
import '../services/database_service.dart';

class SalesHelper {
  static Future<void> addSampleSales() async {
    final db = DatabaseService();

    // Add comprehensive sample sales data for multiple products
    final sampleSales = [
      // Donat Coklat
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 5,
        totalPrice: 75000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 10)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 8,
        totalPrice: 120000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 14)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 7,
        totalPrice: 105000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 9)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 12,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 11)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 9,
        totalPrice: 135000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 15,
        totalPrice: 225000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 15)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 11,
        totalPrice: 165000,
        soldAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),

      // Donat Vanila
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 3,
        totalPrice: 45000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 12)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 6,
        totalPrice: 90000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 10)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 4,
        totalPrice: 60000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 13)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 8,
        totalPrice: 120000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 9)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 5,
        totalPrice: 75000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 11)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 7,
        totalPrice: 105000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 9,
        totalPrice: 135000,
        soldAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),

      // Donat Polos
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 10,
        totalPrice: 100000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 9)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 14,
        totalPrice: 140000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 11)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 11,
        totalPrice: 110000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 10)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 16,
        totalPrice: 160000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 12)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 13,
        totalPrice: 130000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 9)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 18,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 13)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 14,
        totalPrice: 140000,
        soldAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),

      // Donat Oreo
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 6,
        totalPrice: 120000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 11)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 8,
        totalPrice: 160000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 9)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 7,
        totalPrice: 140000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 14)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 9,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 10,
        totalPrice: 200000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 8,
        totalPrice: 160000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 11)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 11,
        totalPrice: 220000,
        soldAt: DateTime.now().subtract(const Duration(hours: 7)),
      ),

      // Kopi Espresso (assuming product 5)
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 12,
        totalPrice: 144000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 8)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 15,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 12)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 13,
        totalPrice: 156000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 11)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 17,
        totalPrice: 204000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 13)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 14,
        totalPrice: 168000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 18,
        totalPrice: 216000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 16,
        totalPrice: 192000,
        soldAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),

      // Kopi Latte (assuming product 6)
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 10,
        totalPrice: 150000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 13)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 12,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 11,
        totalPrice: 165000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 12)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 14,
        totalPrice: 210000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 11)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 13,
        totalPrice: 195000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 13)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 15,
        totalPrice: 225000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 12,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),

      // Kopi Cappuccino (assuming product 7)
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 8,
        totalPrice: 136000,
        soldAt: DateTime.now().subtract(const Duration(days: 6, hours: 14)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 10,
        totalPrice: 170000,
        soldAt: DateTime.now().subtract(const Duration(days: 5, hours: 13)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 9,
        totalPrice: 153000,
        soldAt: DateTime.now().subtract(const Duration(days: 4, hours: 9)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 11,
        totalPrice: 187000,
        soldAt: DateTime.now().subtract(const Duration(days: 3, hours: 14)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 12,
        totalPrice: 204000,
        soldAt: DateTime.now().subtract(const Duration(days: 2, hours: 14)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 10,
        totalPrice: 170000,
        soldAt: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 13,
        totalPrice: 221000,
        soldAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    for (var sale in sampleSales) {
      await db.addSales(sale);
    }
  }
}
