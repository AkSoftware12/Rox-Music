class RecentlySongs {
  final String id;
  final String url;
  final String title;
  final String image;
  final String subtitle;
  bool isLiked;

  RecentlySongs( {
    required this.id,
    required this.url,
    required this.title,
    required this.image,
    required this.subtitle,
    this.isLiked = false,
  });
}
