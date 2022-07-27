import 'package:flutter/material.dart';


import '../models/parsed_node.dart';
import '../models/symbol_params.dart';
import 'parser.dart';
import 'string_to_node_parser.dart';

class NodeToTextConverter {
  final List<SymbolParams> symbols;

  /// the original text
  final String text;

  final Parser _parser;

  final List<String> _symbolChars;

  NodeToTextConverter({
    required this.symbols,
    required this.text,
  })  : _symbolChars = symbols.map((e) => e.symbolCharacter).toList(),
        _parser = Parser(
          text: text,
          symbols: symbols.map((e) => e.symbolCharacter).toList(),
          stringToNodeParser: StringToNodeParser.it,
        );

  get _getNormalTextStyle => _getSymbolStyle('');

  TextSpan convert() {
    // generate the [ParsedNode] first
    final parsedNode = _parser.parse();
    return _textSpanFromNode(parsedNode);
  }

  // mutually recursive with [_buildTextSpanChildren()]
  TextSpan _textSpanFromNode(ParsedNode node) {
    if (node.children.isEmpty) {
      final string = _getCleanedString(node.startIndex, node.endIndex + 1);
      return TextSpan(
        text: string,
        style: _getSymbolStyle(node.symbol),
      );
    } else {
      return TextSpan(
        text: '',
        children: _buildTextSpanChildren(
          start: node.startIndex,
          end: node.endIndex,
          nodeChildren: node.children,
        ),
        style: symbols
            .firstWhere((element) => element.symbolCharacter == node.symbol)
            .style,
      );
    }
  }

  String _getCleanedString(int startIndex, int endIndex) {
    String string = text.substring(startIndex, endIndex);
    for (var symbolChar in _symbolChars) {
      string = string.replaceAll(symbolChar, '');
    }
    return string;
  }

  List<TextSpan> _buildTextSpanChildren({
    required int start,
    required int end,
    required List<ParsedNode> nodeChildren,
  }) {
    List<TextSpan> children = [];

    ParsedNode lastNode = const ParsedNode(startIndex: 0, endIndex: 0);

    String string = _getCleanedString(start, nodeChildren.first.startIndex);

    children.add(
      TextSpan(
        text: string,
        style: _getNormalTextStyle,
      ),
    );

    for (ParsedNode child in nodeChildren) {
      if (child == nodeChildren.first) {
        children.add(_textSpanFromNode(child));
        lastNode = child;
      } else {
        String string =
            _getCleanedString(lastNode.endIndex, child.startIndex + 1);

        children.add(
          TextSpan(
            text: string,
            style: _getNormalTextStyle,
          ),
        );

        children.add(_textSpanFromNode(child));

        lastNode = child;
      }
    }

    string = _getCleanedString(lastNode.endIndex, end + 1);

    children.add(
      TextSpan(
        text: string,
        style: _getNormalTextStyle,
      ),
    );
    // }

    return children;
  }

  TextStyle? _getSymbolStyle(String symbolChar) {
    try {
      return symbols
          .firstWhere((element) => element.symbolCharacter == symbolChar)
          .style;
    } catch (e) {
      return null;
    }
  }
}
