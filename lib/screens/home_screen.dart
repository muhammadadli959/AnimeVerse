import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/anime.dart';
import '../widgets/anime_view.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/genre_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'All';

  List<Anime> get _filteredAnime {
    final query = _searchQuery.trim().toLowerCase();
    return DummyData.animeList.where((anime) {
      final matchesTitle = anime.title.toLowerCase().contains(query);
      final matchesGenre =
          _selectedGenre == 'All' ||
          anime.genre
              .split(',')
              .map((genre) => genre.trim().toLowerCase())
              .contains(_selectedGenre.toLowerCase());
      return matchesTitle && matchesGenre;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          "AnimeVerse",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.075,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            GenreList(
              selected: _selectedGenre,
              onGenreSelected: (genre) =>
                  setState(() => _selectedGenre = genre),
            ),
            SizedBox(height: screenHeight * 0.03),
            AnimeView(animeList: _filteredAnime),
            SizedBox(height: screenHeight * 0.025),
          ],
        ),
      ),
    );
  }
}
