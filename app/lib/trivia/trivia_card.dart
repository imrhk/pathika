import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';

class TriviaListCard extends StatelessWidget implements Details<List<String>> {
  @override
  final List<String> details;
  const TriviaListCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.blueGrey,
      heading: context.read<LocalizationBloc>().localize('trivia', 'Trivia'),
      body: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _TriviaListTile(
          key: ValueKey(details[index]),
          trivia: details[index],
          leading: '#${index + 1}',
        ),
        separatorBuilder: (_, __) => const Divider(
          thickness: 2,
        ),
        itemCount: details.length,
      ),
    );
  }
}

class _TriviaListTile extends StatelessWidget {
  final String trivia;
  final String leading;
  const _TriviaListTile(
      {super.key, required this.trivia, required this.leading});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trivia),
      leading: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.05),
        foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
        radius: 20,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            leading,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
