import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../widgets/info_card.dart';

class LocationMapCard extends StatelessWidget implements Details<List<String>> {
  @override
  final List<String> details;
  const LocationMapCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return _LocationMapStackCardInternal(
      items: details,
    );
  }
}

class _LocationMapStackCardInternal extends StatefulWidget {
  final List<String> items;

  const _LocationMapStackCardInternal({
    this.items = const [],
  });

  @override
  State createState() => __LocationMapItemsStackCardInternalState();
}

// Precaching 2 images in advance so that the transition would be smooth.
class __LocationMapItemsStackCardInternalState
    extends State<_LocationMapStackCardInternal> {
  int index = 0;

  @override
  void didChangeDependencies() {
    for (var item in widget.items.sublist(0, min(widget.items.length, 3))) {
      _precacheMapImage(item);
    }
    super.didChangeDependencies();
  }

  void _precacheMapImage(String item) {
    precacheImage(
      NetworkImage(item),
      context,
      onError: (exception, stackTrace) {
        context.read<Logger>().e(
              'could not load $item',
              error: exception,
              stackTrace: stackTrace,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        index++;
        if (index < index % widget.items.length) {
          for (var i in [1, 2]) {
            _precacheMapImage(
                widget.items.elementAt((index + i) % widget.items.length));
          }
        }
        setState(() {});
      },
      child: InfoCard(
        color: context.showColorsOnCards ? Colors.lightBlue : null,
        padding: const EdgeInsets.all(0.0),
        body: AspectRatio(
          aspectRatio: 1.72,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Image.network(
              widget.items.elementAt(index % widget.items.length),
              key:
                  ValueKey(widget.items.elementAt(index % widget.items.length)),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        isAudiable: false,
      ),
    );
  }
}
