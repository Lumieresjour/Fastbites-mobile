import 'package:flutter/material.dart';
import '../../models/review.dart';
import '../../services/review_service.dart';
import '../../utils/app_colors.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<Review> reviews;
  String selectedCategory = 'all'; // 'all', 'latest', 'best', 'critical'
  final ReviewService _reviewService = ReviewService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      // Clear all old reviews
      await _reviewService.clearAllReviews();
      
      // Seed fresh sample data
      await _seedSampleReviews();
      final seededReviews = await _reviewService.getAllReviews();
      setState(() {
        reviews = seededReviews;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedSampleReviews() async {
    final sampleReviews = [
      // Best Reviews
      Review(
        id: 1,
        userId: 'user001',
        userName: 'Budi Santoso',
        userImage: '',
        productId: 'prod001',
        productName: 'Donat Glaze Original',
        productImage: '',
        rating: 5,
        reviewText:
            'Donat ini sangat lezat! Teksturnya empuk dan rasa glazenya pas. Saya pesan 3 kali minggu ini. Paling suka yang original, tapi yang rasa coklat juga bagus! Pelayanannya juga cepat dan ramah.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        reviewType: 'best',
      ),
      Review(
        id: 2,
        userId: 'user002',
        userName: 'Siti Nurhaliza',
        userImage: '',
        productId: 'prod003',
        productName: 'Espresso Premium',
        productImage: '',
        rating: 5,
        reviewText:
            'Kopi espresso terbaik yang pernah saya minum! Aroma kopi yang harum dan rasa yang smooth. Harganya sepadan dengan kualitas yang diberikan. Saya sudah menjadi pelanggan setia selama 6 bulan.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        reviewType: 'best',
      ),
      Review(
        id: 3,
        userId: 'user003',
        userName: 'Rini Wijaya',
        userImage: '',
        productId: 'prod002',
        productName: 'Donat Coklat Berlapis',
        productImage: '',
        rating: 5,
        reviewText:
            'Makanan yang sempurna untuk sarapan atau cemilan! Coklat yang digunakan berkualitas premium dan tidak terlalu manis. Saya sangat merekomendasikan ke teman-teman saya!',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        reviewType: 'best',
      ),
      Review(
        id: 4,
        userId: 'user004',
        userName: 'Ahmad Wijaksono',
        userImage: '',
        productId: 'prod004',
        productName: 'Kopi Latte Premium',
        productImage: '',
        rating: 5,
        reviewText:
            'Latte yang sempurna! Susu yang digunakan sangat lembut, tidak pahit sama sekali. Saya sudah mencoba berbagai warung kopi, ini adalah yang terbaik sampai sekarang!',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        reviewType: 'best',
      ),
      // Critical Reviews
      Review(
        id: 5,
        userId: 'user005',
        userName: 'Hendra Kusuma',
        userImage: '',
        productId: 'prod001',
        productName: 'Donat Glaze Original',
        productImage: '',
        rating: 2,
        reviewText:
            'Donatnya agak keras dan terasa lembab. Rasa glazenya terlalu manis. Saya kecewa karena sudah pesan 5 butir dan hampir semua sama. Harapan saya tidak terpenuhi.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        reviewType: 'critical',
      ),
      Review(
        id: 6,
        userId: 'user006',
        userName: 'Dwi Santoso',
        userImage: '',
        productId: 'prod003',
        productName: 'Espresso Premium',
        productImage: '',
        rating: 2,
        reviewText:
            'Kopinya terlalu pahit dan keasaman yang tidak seimbang. Suaranya sangat berisik saat waktu sibuk. Harga terlalu mahal untuk kualitas yang diberikan. Tidak worth it.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        reviewType: 'critical',
      ),
      Review(
        id: 7,
        userId: 'user007',
        userName: 'Lisa Marlina',
        userImage: '',
        productId: 'prod002',
        productName: 'Donat Coklat Berlapis',
        productImage: '',
        rating: 1,
        reviewText:
            'Donat tiba dalam kondisi rusak, coklat sudah mengering dan pemesanannya salah. Customer service tidak responsif sama sekali. Sangat mengecewakan!',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        reviewType: 'critical',
      ),
      // Latest Reviews
      Review(
        id: 8,
        userId: 'user008',
        userName: 'Bambang Pratama',
        userImage: '',
        productId: 'prod004',
        productName: 'Kopi Latte Premium',
        productImage: '',
        rating: 4,
        reviewText:
            'Kopi yang enak dan fresh. Pelayanannya cepat. Sedikit kecewa dengan suhu yang tidak konsisten, kadang terlalu panas.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        reviewType: 'latest',
      ),
      Review(
        id: 9,
        userId: 'user009',
        userName: 'Mira Gunawan',
        userImage: '',
        productId: 'prod001',
        productName: 'Donat Glaze Original',
        productImage: '',
        rating: 4,
        reviewText:
            'Donatnya lumayan enak, meski agak manis. Packaging rapih dan tiba tepat waktu. Akan pesan lagi next time!',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        reviewType: 'latest',
      ),
    ];
    for (final review in sampleReviews) {
      await _reviewService.createReview(review);
    }
  }

  List<Review> _getFilteredReviews() {
    if (selectedCategory == 'all') {
      return reviews;
    }
    return reviews.where((review) => review.reviewType == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Ulasan Pelanggan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final filteredReviews = _getFilteredReviews();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Ulasan Pelanggan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildCategoryButton('Semua', 'all'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('Terbaru', 'latest'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('Terbaik', 'best'),
                  const SizedBox(width: 10),
                  _buildCategoryButton('Kritis', 'critical'),
                ],
              ),
            ),
          ),
          // Reviews List
          Expanded(
            child: filteredReviews.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 64,
                          color: AppColors.lightGreen,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada ulasan',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.lightText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ...filteredReviews.map((review) {
                            return _buildReviewCard(review);
                          }),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, String category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.primaryGreen, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Badge & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getReviewTypeColor(review.reviewType).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getReviewTypeIcon(review.reviewType),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        review.getReviewTypeLabel().split(' ').skip(1).join(' '),
                        style: TextStyle(
                          color: _getReviewTypeColor(review.reviewType),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.getFormattedDate(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // User Profile Row
            Row(
              children: [
                // User Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        Colors.teal[700]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      review.userName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        review.productName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Rating with Stars
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...review.getStars().map((star) {
                    return Text(
                      star,
                      style: TextStyle(
                        color:
                            star == '★'
                                ? AppColors.primaryGreen
                                : Colors.grey[300],
                        fontSize: 16,
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '${review.rating}/5',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Review Text
            Text(
              review.reviewText,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.6,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      Icons.thumb_up_outlined,
                      'Berguna',
                      () {},
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      Icons.share_outlined,
                      'Bagikan',
                      () {},
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getReviewTypeIcon(String type) {
    switch (type) {
      case 'best':
        return '⭐';
      case 'critical':
        return '⚠️';
      default:
        return '🕐';
    }
  }

  Color _getReviewTypeColor(String type) {
    switch (type) {
      case 'best':
        return AppColors.success;
      case 'critical':
        return AppColors.error;
      default:
        return Colors.blue;
    }
  }
}
