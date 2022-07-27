import 'package:example/example_card.dart';
import 'package:fast_rich_text/fast_rich_text.dart';
import 'package:flutter/material.dart';

class LiveTypingWidget extends StatefulWidget {
  const LiveTypingWidget({Key? key}) : super(key: key);

  @override
  State<LiveTypingWidget> createState() => _LiveTypingWidgetState();
}

class _LiveTypingWidgetState extends State<LiveTypingWidget> {
  final _textEditingController = TextEditingController();
  String _text = '';
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Start typing',
              ),
              onChanged: (value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            ExampleCard(
              text: _text,
              title: 'Parsed Text',
              child: FastRichText(
                text: _text,
                boldSTextStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                italicTextStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
                strikethroughTextStyle: const TextStyle(
                  fontSize: 15,
                  decoration: TextDecoration.lineThrough,
                ),
                textStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
