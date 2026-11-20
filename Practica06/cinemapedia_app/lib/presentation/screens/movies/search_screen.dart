import 'dart:async';

import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/explore_providers.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  static const name = 'search-screen';

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(ref.watch(selectedCountryProvider));
    final query = _query;

    return Scaffold(
      appBar: AppBar(title: Text(strings.searchMovies)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _search,
              onSubmitted: (value) => setState(() => _query = value.trim()),
              decoration: InputDecoration(
                hintText: strings.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).deleteButtonTooltip,
                        onPressed: () {
                          _controller.clear();
                          _debounce?.cancel();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: query.length < 2
                ? Center(child: Text(strings.searchMovies))
                : ref
                      .watch(searchMoviesProvider(query))
                      .when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(strings.loadError),
                              TextButton(
                                onPressed: () =>
                                    ref.invalidate(searchMoviesProvider(query)),
                                child: Text(strings.retry),
                              ),
                            ],
                          ),
                        ),
                        data: (movies) => movies.isEmpty
                            ? Center(child: Text(strings.noSearchResults))
                            : MovieGrid(movies: movies),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        strings: strings,
        selectedIndex: 0,
      ),
    );
  }
}
