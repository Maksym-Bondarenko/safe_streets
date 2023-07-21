import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsletterPage extends StatelessWidget {
  NewsletterPage({super.key});

  final List<NewsPost> newsPosts = [
    NewsPost(
      title: 'New Feature Release',
      content: 'We are excited to announce the release of our new feature!',
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/91ac167d372b41248755.png',
      link: 'https://flutter.dev/news',
      publicationDate: 'September 15, 2023',
    ),
    NewsPost(
      title: 'Version 1.0.0 Release',
      content: 'We are excited to announce the start of Alpha-Testing phase!',
      imageUrl: 'https://mysafestreets.org/static/media/home-banner-image.fd3d8816518e14481e81.png',
      link: 'https://mysafestreets.org/',
      publicationDate: 'September 1, 2023',
    ),
    // Add more news posts here
  ];

// Function to launch the URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Handle error if the URL cannot be launched
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsletter'),
      ),
      body: ListView.builder(
        itemCount: newsPosts.length,
        itemBuilder: (context, index) {
          return _buildNewsPostCard(newsPosts[index]);
        },
      ),
    );
  }

  Widget _buildNewsPostCard(NewsPost post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.publicationDate,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            if (post.imageUrl != null)
              Image.network(
                post.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Display a placeholder image or an error message here
                  return const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  );
                },
              ),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            if (post.link != null)
              ElevatedButton(
                onPressed: () {
                  _launchURL(post.link!);
                },
                child: const Text('Read More'),
              ),
          ],
        ),
      ),
    );
  }
}

class NewsPost {
  final String title;
  final String content;
  final String? imageUrl;
  final String? link;
  final String publicationDate;

  NewsPost({
    required this.title,
    required this.content,
    this.imageUrl,
    this.link,
    required this.publicationDate,
  });
}
