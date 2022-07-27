import 'package:flutter/material.dart';

class ExampleCard extends StatelessWidget {
  const ExampleCard({
    Key? key,
    required this.text,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String text;
  final String title;
  final Widget child;

  TextStyle get headerStyle => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      );

  Widget get verticalSpace => const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: headerStyle,
            ),
          ),
          verticalSpace,
          Text(text),
          verticalSpace,
          child,
        ],
      ),
    );
  }
}
