class Review {
  final int? id;
  final String userId;
  final String userName;
  final String userImage;
  final String productId;
  final String productName;
  final String productImage;
  final int rating; // 1-5 stars
  final String reviewText;
  final DateTime createdAt;
  final String reviewType; // 'latest', 'best', 'critical'

  Review({
    this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.reviewType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': createdAt.toIso8601String(),
      'reviewType': reviewType,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      rating: map['rating'] ?? 0,
      reviewText: map['reviewText'] ?? '',
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      reviewType: map['reviewType'] ?? 'latest',
    );
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '${weeks}w ago';
    } else {
      return createdAt.toString().split(' ')[0];
    }
  }

  String getReviewTypeLabel() {
    switch (reviewType) {
      case 'best':
        return '⭐ Best Review';
      case 'critical':
        return '⚠️ Critical Review';
      default:
        return '🕐 Latest Review';
    }
  }

  List<String> getStars() {
    final stars = <String>[];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add('★');
      } else {
        stars.add('☆');
      }
    }
    return stars;
  }
}
