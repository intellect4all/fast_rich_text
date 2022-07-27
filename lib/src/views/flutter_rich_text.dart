import 'package:flutter/material.dart';
import 'package:flutter_rich_text/src/utils/node_to_text_converter.dart';
import 'package:flutter_rich_text/src/models/symbol_params.dart';

class FlutterRichText extends StatelessWidget {
  /// The formatted input string to be parsed into rich text
  final String text;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [text] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any. If there is no ambient
  /// [Directionality], then this must not be null.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// whether to use the user defined-symbols
  ///
  /// defaults to false, i.e it uses symbols of bold, italic, and emphasis.
  ///
  /// It will also default false when [customSymbols] is empty
  final bool useCustomParseSymbols;

  /// user-defined symbols.
  ///
  /// must be not be if [useCustomParseSymbols] is true
  final List<SymbolParams> customSymbols;

  /// The [TextStyle] to apply to normal texts.
  final TextStyle textStyle;

  /// Custom [TextStyle] to apply to bold texts.
  final TextStyle? boldSTextStyle;

  /// Custom [TextStyle] to apply to italic texts.
  final TextStyle? italicTextStyle;

  /// Custom [TextStyle] to apply to strikethrough texts.
  final TextStyle? strikethroughTextStyle;

  FlutterRichText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.boldSTextStyle,
    this.softWrap = true,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textHeightBehavior,
    this.useCustomParseSymbols = false,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.textWidthBasis = TextWidthBasis.parent,
    this.customSymbols = const [],
    this.italicTextStyle,
    required this.textStyle,
    this.textDirection,
    this.strikethroughTextStyle,
  }) : super(key: key);

  final List<SymbolParams> _allSymbols = [];

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox();

    if (useCustomParseSymbols && customSymbols.isEmpty) {
      return returnStringUnparsed();
    }

    _allSymbols.clear();
    _allSymbols.addAll(customSymbols);
    _addDefaultSymbols();

    final distinctSymbols = <SymbolParams>[];

    // Set can be used to, but set does not guarantee an order, it is better
    // to iterate over the list once, to give user defined symbols priority
    for (SymbolParams symbol in _allSymbols) {
      if (!distinctSymbols.contains(symbol)) {
        distinctSymbols.add(symbol);
      }
    }
    final textSpan = NodeToTextConverter(
      symbols: distinctSymbols,
      text: text,
    ).convert();

    return RichText(
      text: textSpan,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
    );
  }

  Widget returnStringUnparsed() {
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
    );
  }

  void _addDefaultSymbols() {
    final list = <SymbolParams>[];

    // include the textStyle for normal texts
    list.add(
      SymbolParams(
        symbolCharacter: '',
        style: textStyle,
      ),
    );

    // add bold default
    list.add(
      SymbolParams(
        symbolCharacter: '*',
        style: boldSTextStyle ??
            textStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );

    // add italic default
    list.add(
      SymbolParams(
        symbolCharacter: '_',
        style: italicTextStyle ??
            textStyle.copyWith(
              fontStyle: FontStyle.italic,
            ),
      ),
    );

    // add strikethrough
    list.add(
      SymbolParams(
        symbolCharacter: '~',
        style: strikethroughTextStyle ??
            textStyle.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
      ),
    );

    _allSymbols.addAll(list);
  }
}
