import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/routes.dart';
import '../data/favorite_store.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/favorite_anime_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Anime",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.075),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: screenWidth * 0.02,
                    offset: Offset(0, screenHeight * 0.005),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Anime Title",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.04,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: screenWidth * 0.06,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.075),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.075),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.075),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Color(0xFF0b395e),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.015,
                  ),
                ),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.01),

          Expanded(
            child: AnimatedBuilder(
              animation: FavoriteStore.instance,
              builder: (context, _) {
                final query = _searchQuery.trim().toLowerCase();
                final favorites = FavoriteStore.instance.favorites
                    .where((anime) => anime.title.toLowerCase().contains(query))
                    .toList();

                if (favorites.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No favorite anime yet'
                          : 'No favorites match your search',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final anime = favorites[index];
                    return FavoriteAnimeCard(
                      title: anime.title,
                      genre: anime.genre,
                      rating: anime.rating,
                      imagePath: anime.imagePath,
                      onTap: () =>
                          context.push('${AppRoutes.details}/${anime.id}'),
                      onRemove: () => FavoriteStore.instance.toggle(anime.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
