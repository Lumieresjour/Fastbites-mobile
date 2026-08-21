import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/review.dart';
import 'database_service.dart';
import 'web_review_storage.dart';

class ReviewService {
  final DatabaseService _databaseService = DatabaseService();

  // Create new review
  Future<int> createReview(Review review) async {
    try {
      if (kIsWeb) {
        final reviews = await webGetReviews();
        reviews.add(review);
        final saved = await webSaveReviews(reviews);
        return saved ? 1 : 0;
      }
      final db = await _databaseService.database;
      final result = await db.insert(
        'reviews',
        {
          'user_id': review.userId,
          'user_name': review.userName,
          'user_image': review.userImage,
          'product_id': review.productId,
          'product_name': review.productName,
          'product_image': review.productImage,
          'rating': review.rating,
          'review_text': review.reviewText,
          'review_type': review.reviewType,
          'created_at': review.createdAt.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      return result;
    } catch (e) {
      print('Error creating review: $e');
      return 0;
    }
  }

  // Get all reviews
  Future<List<Review>> getAllReviews() async {
    try {
      if (kIsWeb) {
        return await webGetReviews();
      }
      final db = await _databaseService.database;
      final result = await db.query('reviews', orderBy: 'created_at DESC');
      return result.map((map) => Review.fromMap(map)).toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  // Get review by id
  Future<Review?> getReviewById(int id) async {
    try {
      if (kIsWeb) {
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'reviews',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return Review.fromMap(result.first);
    } catch (e) {
      print('Error getting review by id: $e');
      return null;
    }
  }

  // Get reviews by product
  Future<List<Review>> getReviewsByProduct(String productId) async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'reviews',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Review.fromMap(map)).toList();
    } catch (e) {
      print('Error getting reviews by product: $e');
      return [];
    }
  }

  // Get reviews by user
  Future<List<Review>> getReviewsByUser(String userId) async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'reviews',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Review.fromMap(map)).toList();
    } catch (e) {
      print('Error getting reviews by user: $e');
      return [];
    }
  }

  // Get reviews by type
  Future<List<Review>> getReviewsByType(String reviewType) async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'reviews',
        where: 'review_type = ?',
        whereArgs: [reviewType],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Review.fromMap(map)).toList();
    } catch (e) {
      print('Error getting reviews by type: $e');
      return [];
    }
  }

  // Get reviews by rating
  Future<List<Review>> getReviewsByRating(int rating) async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'reviews',
        where: 'rating = ?',
        whereArgs: [rating],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Review.fromMap(map)).toList();
    } catch (e) {
      print('Error getting reviews by rating: $e');
      return [];
    }
  }

  // Update review
  Future<bool> updateReview(Review review) async {
    try {
      if (kIsWeb) {
        return false;
      }
      final db = await _databaseService.database;
      final result = await db.update(
        'reviews',
        {
          'user_id': review.userId,
          'user_name': review.userName,
          'user_image': review.userImage,
          'product_id': review.productId,
          'product_name': review.productName,
          'product_image': review.productImage,
          'rating': review.rating,
          'review_text': review.reviewText,
          'review_type': review.reviewType,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [review.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating review: $e');
      return false;
    }
  }

  // Delete review
  Future<bool> deleteReview(int id) async {
    try {
      if (kIsWeb) {
        final reviews = await webGetReviews();
        reviews.removeWhere((r) => r.id == id);
        return await webSaveReviews(reviews);
      }
      final db = await _databaseService.database;
      final result = await db.delete(
        'reviews',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting review: $e');
      return false;
    }
  }

  // Get average rating for product
  Future<double> getAverageRating(String productId) async {
    try {
      if (kIsWeb) {
        return 0;
      }
      final db = await _databaseService.database;
      final result = await db.rawQuery(
        'SELECT AVG(rating) as avg_rating FROM reviews WHERE product_id = ?',
        [productId],
      );
      if (result.isEmpty) return 0;
      final avgRating = result.first['avg_rating'];
      return avgRating != null ? (avgRating as num).toDouble() : 0;
    } catch (e) {
      print('Error getting average rating: $e');
      return 0;
    }
  }

  // Get rating count for product
  Future<Map<int, int>> getRatingCountForProduct(String productId) async {
    try {
      if (kIsWeb) {
        return {};
      }
      final db = await _databaseService.database;
      final result = await db.rawQuery(
        'SELECT rating, COUNT(*) as count FROM reviews WHERE product_id = ? GROUP BY rating',
        [productId],
      );
      
      final ratingCount = <int, int>{};
      for (var row in result) {
        final rating = row['rating'] as int;
        final count = (row['count'] as num).toInt();
        ratingCount[rating] = count;
      }
      return ratingCount;
    } catch (e) {
      print('Error getting rating count: $e');
      return {};
    }
  }

  // Search reviews
  Future<List<Review>> searchReviews(String query) async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'reviews',
        where: 'user_name LIKE ? OR product_name LIKE ? OR review_text LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Review.fromMap(map)).toList();
    } catch (e) {
      print('Error searching reviews: $e');
      return [];
    }
  }

  // Clear all reviews
  Future<bool> clearAllReviews() async {
    try {
      if (kIsWeb) {
        return await webClearReviews();
      }
      final db = await _databaseService.database;
      await db.delete('reviews');
      return true;
    } catch (e) {
      print('Error clearing all reviews: $e');
      return false;
    }
  }
}
