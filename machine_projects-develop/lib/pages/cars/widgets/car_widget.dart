import 'package:flutter/material.dart';
import 'package:machine/data/models/car.dart';
import 'package:machine/pages/cars/widgets/info_text_widget.dart';

class CarWidget extends StatelessWidget {
  const CarWidget({
    required this.carInfo,
    Key? key,
  }) : super(key: key);

  final Car carInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${carInfo.brand} ${carInfo.model}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Classification:  ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        carInfo.classification ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            InfoTextWidget(
              name: 'Engine: ',
              value: carInfo.engine,
            ),
            const SizedBox(height: 16),
            InfoTextWidget(
              name: 'Consumption: ',
              value: carInfo.consumption,
            ),
            const SizedBox(height: 16),
            InfoTextWidget(
              name: 'Air: ',
              value: carInfo.air,
            ),
          ],
        ),
      ),
    );
  }
}
