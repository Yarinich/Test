import 'package:flutter/cupertino.dart';

class TitledWidget extends StatelessWidget {
  const TitledWidget({
    this.title,
    super.key,
    this.child,
    this.titleStyle,
    this.onPressed,
    this.margin,
  });

  final String? title;
  final Widget? child;
  final TextStyle? titleStyle;
  final VoidCallback? onPressed;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final child = this.child;

    return GestureDetector(
      onTap: onPressed,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (title != null)
          Container(
            margin: margin,
            child: Text(title, style: titleStyle),
          ),
        if (child != null) child,
      ]),
    );
  }
}
