import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  final String title;
  final double value;
  final Widget icon;

  const HeaderCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = value < 0
        ? '-€ ${value.abs().toStringAsFixed(2)}'
        : '€ ${value.toStringAsFixed(2)}';

    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formattedValue,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}