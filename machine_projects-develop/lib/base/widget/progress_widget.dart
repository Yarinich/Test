import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: InkWell(
        // ignore: no-empty-block
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // Todo starter: change or remove logo.
                FlutterLogo(),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
