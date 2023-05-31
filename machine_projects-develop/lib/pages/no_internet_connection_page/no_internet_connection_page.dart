import 'package:flutter/material.dart';

class NoInternetConnectionPage extends StatelessWidget {
  const NoInternetConnectionPage({Key? key}) : super(key: key);

  static const routeName = '/no-internet-connection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              Spacer(),
              Icon(
                Icons.wifi_off_rounded,
                size: 100,
              ),
              SizedBox(height: 32),
              Text(
                'No connection..',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                "Oops... it's seems you can't connect to our network. Please, check your internet connection.",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
