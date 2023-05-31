import 'package:flutter/material.dart';

class InfoTextWidget extends StatelessWidget {
  const InfoTextWidget({
    required this.name,
    required this.value,
    Key? key,
  }) : super(key: key);

  final String name;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
