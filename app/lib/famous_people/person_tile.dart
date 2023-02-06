import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/attribution_widget.dart';

class PersonTile extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String? work;
  final String? place;
  final String? photoBy;
  final String? licence;
  final String? attributionUrl;

  const PersonTile({
    super.key,
    required this.name,
    this.avatarUrl,
    this.work,
    this.place,
    this.photoBy,
    this.licence,
    this.attributionUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: avatarUrl != null,
          replacement: const SizedBox(
            width: 80,
            height: 100,
          ),
          child: Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: NetworkImage(
                  avatarUrl!,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 5),
              Text(
                work ?? '',
                softWrap: true,
              ),
              if (place?.isNotEmpty ?? false) const SizedBox(height: 5),
              if (place?.isNotEmpty ?? false)
                RichText(
                  softWrap: true,
                  text: TextSpan(
                    children: [
                      if (!kIsWeb) //web not working for widget span
                        WidgetSpan(
                          child: Icon(Icons.place,
                              size: 14,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color),
                        ),
                      const TextSpan(
                        text: ' ',
                      ),
                      TextSpan(
                        text: place,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(textBaseline: TextBaseline.ideographic),
                      ),
                    ],
                  ),
                ),
              if (photoBy != "")
                const SizedBox(
                  height: 5,
                ),
              if (photoBy != "")
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: AttributionWidget(
                    photoBy: photoBy,
                    attributionUrl: attributionUrl,
                    licence: licence,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
