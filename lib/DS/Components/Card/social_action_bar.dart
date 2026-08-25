import 'package:flutter/material.dart';

class SocialActionBar extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isFavorited;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  const SocialActionBar({
    super.key,
    required this.likeCount,
    required this.commentCount,
    this.isLiked = false,
    this.isFavorited = false,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.redAccent : theme.iconTheme.color,
                  ),
                  onPressed: onLike,
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: onComment,
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: onShare,
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                isFavorited ? Icons.bookmark : Icons.bookmark_border,
                color: isFavorited ? theme.colorScheme.primary : theme.iconTheme.color,
              ),
              onPressed: onFavorite,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              if (likeCount > 0)
                Text(
                  '$likeCount ${likeCount == 1 ? 'curtida' : 'curtidas'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              if (likeCount > 0 && commentCount > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text('•', style: TextStyle(color: Colors.grey)),
                ),
              if (commentCount > 0)
                Text(
                  '$commentCount ${commentCount == 1 ? 'comentário' : 'comentários'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
            ],
          ),
        ),
      ],
    );
  }
}