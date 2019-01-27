import 'package:flutter/material.dart';

/// based on Flutter gallery home.dart/_CategoryItem
class IconTileButton extends StatelessWidget {
  const IconTileButton(
      {Key key,
      @required this.label,
      @required this.icon,
      @required this.onTap,
      this.size})
      : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // This repaint boundary prevents the entire _CategoriesPage from being
    // repainted when the button's ink splash animates.
    return Container(
      width: size,
      height: size,
      alignment: AlignmentDirectional.bottomEnd,
      child: RepaintBoundary(
        child: RawMaterialButton(
          padding: EdgeInsets.zero,
          splashColor: theme.primaryColor.withOpacity(0.12),
          highlightColor: Colors.transparent,
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  icon,
                  size: 60.0,
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subhead.copyWith(
                    fontFamily: 'GoogleSans',
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
