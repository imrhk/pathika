import 'package:flutter/material.dart';

import '../core/adt_details.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';
import '../widgets/info_card.dart';
import 'movie_item_card.dart';

class MoviesListCard extends StatelessWidget
    implements Details<List<MovieDetails>> {
  @override
  final List<MovieDetails> details;
  final String? countryName;
  const MoviesListCard({
    super.key,
    required this.details,
    this.countryName,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.indigo,
      heading: '${context.localize('movies_from', 'Movies from')} $countryName',
      body: SizedBox(
        height: 250,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(0),
          shrinkWrap: false,
          itemBuilder: (ctx, index) {
            final item = details[index];
            return MovieItemCard(
              name: item.title,
              posterUrl: item.posterUrl,
            );
          },
          itemCount: details.length,
        ),
      ),
    );
  }
}
