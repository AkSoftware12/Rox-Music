class TrendingPodcasts {
  final String url;
  final String title;
  final String image;
  final String subtitle;
  bool isLiked;

  TrendingPodcasts( {
    required this.url,
    required this.title,
    required this.image,
    required this.subtitle,
    this.isLiked = false,
  });
}
