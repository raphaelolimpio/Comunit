import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';


class GithubProfileCard extends StatelessWidget {
  final String username;
  final int totalCommits;
  final int publicRepos;
  final int starredRepos;
  final int pulledRequests;
  final List<Map<String, dynamic>> techBadges; // Nome e cor da badge

  const GithubProfileCard({
    Key? key,
    required this.username,
    required this.totalCommits,
    required this.publicRepos,
    required this.starredRepos,
    required this.pulledRequests,
    required this.techBadges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: techSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: techBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. SEÇÃO DE LINGUAGENS & FERRAMENTAS (Badges)
          // ==========================================
          const Row(
            children: [
              Icon(Icons.terminal, color: techPrimary, size: 18),
              SizedBox(width: 8),
              Text(
                'Languages & Tools',
                style: TextStyle(
                  color: techTextWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Grid ou Wrap de Badges Estilizadas
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: techBadges.map((badge) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badge['color'] ?? const Color(0xFF21262D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge['name'].toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: techBorderColor, height: 1),
          ),

          // ==========================================
          // 2. SEÇÃO DE ATIVIDADE & HÁBITOS (GitHub Stats)
          // ==========================================
          Row(
            children: [
              const Icon(Icons.insights, color: Colors.blueAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                'Activity & Coding Habits ($username)',
                style: const TextStyle(
                  color: techTextWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Métricas em Linhas / Colunas organizadas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn(Icons.commit, '$totalCommits', 'Commits'),
              _buildMetricColumn(Icons.book_outlined, '$publicRepos', 'Repositórios'),
              _buildMetricColumn(Icons.star_border, '$starredRepos', 'Starred'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn(Icons.alt_route, '$pulledRequests', 'Pull Requests'),
              _buildMetricColumn(Icons.people_outline, 'Active', 'Contribuições'),
              _buildMetricColumn(Icons.code_outlined, 'Top 4', 'Linguagens'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: techBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: techBorderColor.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: techTextGray, size: 16),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: techTextWhite,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: techTextGray,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}