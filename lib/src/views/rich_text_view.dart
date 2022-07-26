import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  /// The formatted input string to be parsed into rich text
  final String text;

  /// The symbol to match texts to bold in the input string.
  ///
  /// It should be one character. The default is '*'.
  final String? boldSymbol;

  /// The symbol to match texts to italicize in the input string.
  ///
  /// It should be one character. The default is '_'.
  final String? italicSymbol;

  /// The symbol to match texts to italicize in the input string.
  ///
  /// It should be one character. The default is '~'.
  final String? strikethroughSymbol;

  /// Custom [TextStyle] to apply to bold texts.
  final TextStyle? boldSTextStyle;

  /// Custom [TextStyle] to apply to italic texts.
  final TextStyle? italicTextStyle;

  /// Custom [TextStyle] to apply to strikethrough texts.
  final TextStyle? strikethroughTextStyle;

  const RichTextWidget({
    Key? key,
    required this.text,
    this.boldSymbol = '*',
    this.italicSymbol = '_',
    this.strikethroughSymbol = '~',
    this.boldSTextStyle,
    this.italicTextStyle,
    this.strikethroughTextStyle,
  })  : assert((boldSymbol?.length ?? 0) == 1),
        assert((italicSymbol?.length ?? 0) == 1),
        assert((strikethroughSymbol?.length ?? 0) == 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox();
    return Container();
  }
}
