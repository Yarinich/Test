import 'package:flutter/widgets.dart';

class SingleScrollWidget extends StatelessWidget {
  const SingleScrollWidget({
    this.child,
    super.key,
    this.isMaxHeight = true,
    this.isMaxWidth = true,
  });

  final Widget? child;
  final bool isMaxHeight;
  final bool isMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) =>
          SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: isMaxWidth
                ? viewportConstraints.maxWidth
                : viewportConstraints.minWidth,
            minHeight: isMaxHeight
                ? viewportConstraints.maxHeight
                : viewportConstraints.minHeight,
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
