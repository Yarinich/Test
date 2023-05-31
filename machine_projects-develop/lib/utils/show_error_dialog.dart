import 'package:flutter/material.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/utils/extensions/context_navigation_ext.dart';

Future<void> showErrorDialog(BuildContext context, ErrorState errorState) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        title: const Text('Error'),
        content: Text(errorState.msg ?? ''),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text('OK'),
          )
        ],
      ),
    );
