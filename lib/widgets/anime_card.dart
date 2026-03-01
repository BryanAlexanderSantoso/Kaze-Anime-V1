import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/anime_model.dart';
import '../screens/detail_screen.dart';
import '../utils/image_utils.dart';

class AnimeCard extends StatelessWidget {
  final AnimeModel anime;
  final double width;
  final double height;

  const AnimeCard({
    super.key,
    required this.anime,
    this.width = 140,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(animeId: anime.animeId),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: ImageUtils.getSafeImageUrl(anime.poster),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[900]!,
                      highlightColor: Colors.grey[800]!,
                      child: Container(color: Colors.black),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.movie_filter,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  // Rating Badge
                  if (anime.score != null && anime.score!.isNotEmpty)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFAB913),
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              anime.score!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Episode Badge
                  if (anime.episodes != null)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF47521),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          'EPS ${anime.episodes}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            anime.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          if (anime.releaseDay != null)
            Text(
              anime.releaseDay!,
              style: const TextStyle(fontSize: 11, color: Colors.white54),
            ),
        ],
      ),
    );
  }
}
