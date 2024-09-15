import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/common/widgets/matrices/led_matrix.dart';
import 'package:mosaico_flutter_core/common/widgets/matrices/no_data_matrix.dart';

class EmptyPlaceholder extends StatelessWidget {

  final String? hintText;
  final Function? onRetry;
  const EmptyPlaceholder({super.key, this.hintText, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoDataMatrix(),
          const SizedBox(height: 10),
          Text('No data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
              ),
          if (hintText != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(hintText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white60)
              ),
            ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                onRetry!();
              },
              child: const Text('Retry'),
            ),
        ],
      ));
  }
}
