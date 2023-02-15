import 'package:flutter/cupertino.dart';

class CupertinoListTile extends StatefulWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const CupertinoListTile({
    super.key,
    this.leading = const SizedBox.shrink(),
    this.title = '',
    this.subtitle = '',
    this.trailing = const SizedBox.shrink(),
    this.onTap,
  });

  @override
  State createState() => _StatefulStateCupertino();
}

class _StatefulStateCupertino extends State<CupertinoListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              widget.leading,
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.title,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 25,
                      )),
                  Text(widget.subtitle,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 20,
                      )),
                ],
              ),
            ],
          ),
          widget.trailing,
        ],
      ),
    );
  }
}
