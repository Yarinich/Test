import 'package:flutter/material.dart';

class PageNameWidget extends StatelessWidget {
  const PageNameWidget(
    this.pageName, {
    this.lastBlocState,
    super.key,
  });

  final String pageName;
  final String? lastBlocState;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Colors.white.withOpacity(0.7),
      backgroundColor: Colors.black.withOpacity(0.3),
      fontSize: 12,
    );
    final lastBlocState = this.lastBlocState;

    return SafeArea(
      child: IgnorePointer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pageName, style: style),
            if (lastBlocState != null && lastBlocState.isNotEmpty)
              Text(lastBlocState, style: style),
          ],
        ),
      ),
    );
  }
}
