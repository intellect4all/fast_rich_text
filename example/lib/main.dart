import 'package:example/live_typing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rich_text/flutter_rich_text.dart';

import 'example_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Rich Text'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final textForDefault =
      '*All texts within me should be bold,* _all texts within me should be italic_, ~and all texts within me should be strikeThrough~ by default';

  final textForChangeStyle =
      '*All texts within me should be red, bold, and bigger,* _all texts within me should be green, italic, and spaced_, ~and all texts within me should be blue and strikeThrough~ by default';

  final textForStyleInStyle =
      '*All texts _within_ me should be bold,* _all ~texts *within* me should~ be italic_, ~and all texts *within me* should be strikeThrough~ by default';

  final textForCustomTags =
      'Email me at /odetechit@gmail.com/, call me on -+2348108678294-, I am #@intellect4all# on Twitter, and you can also connect with me on LinkedIn at &Odewole Abdul-Jemeel&. Thank you';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const LiveTypingWidget(),
            ExampleCard(
              text: textForDefault,
              title: 'Default settings',
              child: FlutterRichText(
                text: textForDefault,
                textStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ExampleCard(
              text: textForChangeStyle,
              title: 'Change style of each group',
              child: FlutterRichText(
                text: textForChangeStyle,
                boldSTextStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                italicTextStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  letterSpacing: 4,
                  fontStyle: FontStyle.italic,
                ),
                strikethroughTextStyle: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.lineThrough,
                ),
                textStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ExampleCard(
              text: textForStyleInStyle,
              title: 'Style in Style',
              child: FlutterRichText(
                text: textForStyleInStyle,
                boldSTextStyle: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                italicTextStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  letterSpacing: 4,
                  fontStyle: FontStyle.italic,
                ),
                strikethroughTextStyle: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.lineThrough,
                ),
                textStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ExampleCard(
              text: textForCustomTags,
              title: 'Define custom tags',
              child: FlutterRichText(
                text: textForCustomTags,
                useCustomParseSymbolsOnly: true,
                customSymbols: const [
                  SymbolParams(
                    symbolCharacter: '-',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                    ),
                  ),
                  SymbolParams(
                    symbolCharacter: '/',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 13,
                    ),
                  ),
                  SymbolParams(
                    symbolCharacter: '#',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                  ),
                  SymbolParams(
                    symbolCharacter: '&',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  )
                ],
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
