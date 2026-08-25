import 'package:flutter/material.dart';
import '../social_action_bar.dart';

class BaseCardWrapper extends StatelessWidget {
  final String authorName;
  final String? authorAvatarUrl;
  final String? authorRole;
  final String timeAgo;
  final Widget content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isFavorited;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onFavorite;
  final VoidCallback? onOptionsTap;

  const BaseCardWrapper({
    super.key,
    required this.authorName,
    this.authorAvatarUrl,
    this.authorRole,
    required this.timeAgo,
    required this.content,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isFavorited = false,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onFavorite,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do Autor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: authorAvatarUrl != null
                        ? NetworkImage(authorAvatarUrl!)
                        : null,
                    child: authorAvatarUrl == null
                        ? Text(authorName.isNotEmpty ? authorName[0].toUpperCase() : 'D')
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (authorRole != null)
                          Text(
                            '$authorRole • $timeAgo',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: onOptionsTap,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Conteúdo Especializado (Post, Termo ou Snippet)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: content,
            ),
            const SizedBox(height: 8),

            // Barra Social
            SocialActionBar(
              likeCount: likeCount,
              commentCount: commentCount,
              isLiked: isLiked,
              isFavorited: isFavorited,
              onLike: onLike,
              onComment: onComment,
              onShare: onShare,
              onFavorite: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
}