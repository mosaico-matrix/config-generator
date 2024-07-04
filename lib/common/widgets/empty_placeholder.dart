import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/common/widgets/matrices/led_matrix.dart';
import 'package:mosaico_flutter_core/common/widgets/matrices/no_data_matrix.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoDataMatrix(),
          const SizedBox(height: 20),
          Text('No data available',
              style: TextStyle(fontSize: 20),
              ),
        ],
      ));
  }
}
