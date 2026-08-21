import 'dart:html' as html;
import 'dart:convert';
import '../models/review.dart';

Future<List<Review>> webGetReviews() async {
  try {
    final jsonString = html.window.localStorage['fastbites_reviews'];
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((item) => Review.fromMap(item)).toList();
  } catch (e) {
    print('Error getting reviews from web storage: $e');
    return [];
  }
}

Future<bool> webSaveReviews(List<Review> reviews) async {
  try {
    final jsonList = reviews.map((r) => {
      'id': r.id,
      'userId': r.userId,
      'userName': r.userName,
      'userImage': r.userImage,
      'productId': r.productId,
      'productName': r.productName,
      'productImage': r.productImage,
      'rating': r.rating,
      'reviewText': r.reviewText,
      'reviewType': r.reviewType,
      'createdAt': r.createdAt.toIso8601String(),
    }).toList();
    html.window.localStorage['fastbites_reviews'] = jsonEncode(jsonList);
    return true;
  } catch (e) {
    print('Error saving reviews to web storage: $e');
    return false;
  }
}

Future<bool> webClearReviews() async {
  try {
    html.window.localStorage.remove('fastbites_reviews');
    return true;
  } catch (e) {
    print('Error clearing reviews from web storage: $e');
    return false;
  }
}

