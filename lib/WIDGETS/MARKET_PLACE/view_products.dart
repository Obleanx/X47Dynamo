class ViewProduct2 {
  final String name;
  final String userId; // Renamed from UserId to userId
  final double price;
  final String description;
  final List<String> images;
  final String sellerName;
  final String sellerJoinDate;
  final String? sellerId; // Optional, can be null
  final String? sellerEmail; // Optional, can be null

  const ViewProduct2({
    required this.name,
    required this.userId, // Updated
    required this.price,
    required this.description,
    required this.images,
    required this.sellerName,
    required this.sellerJoinDate,
    this.sellerId, // Made optional
    this.sellerEmail, // Made optional
  });
}
