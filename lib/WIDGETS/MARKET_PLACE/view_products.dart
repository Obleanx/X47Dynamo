class ViewProduct {
  final String name;
  final String UserId; // New field

  final double price;
  final String description;
  final List<String> images;
  final String sellerName;
  final String sellerJoinDate;

  const ViewProduct({
    required this.name,
    required this.UserId,
    required this.price,
    required this.description,
    required this.images,
    required this.sellerName,
    required this.sellerJoinDate,
  });
}
