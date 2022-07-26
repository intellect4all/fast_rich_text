import 'package:flutter_rich_text/src/utils/string_to_node_parser.dart';

import '../models/parsed_node.dart';

import '../models/special_symbol.dart';

class Parser {
  /// the text to be parsed
  final String text;

  /// Symbols to be checked for, e.g '*. Must be a single character
  List<String> symbols;

  final StringToNodeParser _stringToNodeParser;
  bool _isRegisteredSymbol(String i) => symbols.contains(i);
  Parser({
    required this.text,
    required this.symbols,
    required StringToNodeParser stringToNodeParser,
  }) : _stringToNodeParser = stringToNodeParser;

  final _symbolIndexes = <String, List<int>>{};
  final _allSymbols = <SpecialSymbol>[];

  final _allIndexes = <int>[];

  bool get _noMatchingSymbolsExists => _allSymbols.isEmpty;

  ParsedNode parse() {
    // create the symbols to parse
    _createSymbols();

    // return the whole [text] if no symbol has at least one matching pairs
    // i.e nothing to parse
    if (_noMatchingSymbolsExists) {
      return ParsedNode(
        startIndex: 0,
        endIndex: text.length,
      );
    }

    return ParsedNode(
      startIndex: 0,
      endIndex: text.length - 1,
      children: _stringToNodeParser.parse(
        startIndex: 0,
        endIndex: _allIndexes.length - 1,
        symbolsToBeChecked: _allSymbols,
      ),
    );
  }

  /// this will generate the indexes where the parsing symbols appear.
  void _generateIndexes() {
    // clear to avoid duplicates indexes
    _symbolIndexes.clear();

    for (int i = 0; i < text.length; i++) {
      if (_isRegisteredSymbol(text[i])) {
        // symbol already in the registered
        if (_symbolIndexes.containsKey(text[i])) {
          _symbolIndexes[text[i]]!.add(i);
        } else {
          // symbol not yet registered
          _symbolIndexes[text[i]] = [i];
        }

        _allIndexes.add(i);
      }
    }

    // sort the indexes so they can be chronological, since it is impossible to
    // have more than one char at any given indexes in a string
    _allIndexes.sort();
  }

  void _createSymbols() {
    _generateIndexes();

    for (String symbol in symbols) {
      final indexes = _symbolIndexes[symbol] ?? [];

      // we only want to add the symbol if there are at least one matching pair
      // of symbols. i.e two string indexes has been registered
      if (indexes.length >= 2) {
        final specialSymbol = SpecialSymbol(
          symbolChar: symbol,
          indexes: _symbolIndexes[symbol]!,
          allIndexes: _allIndexes,
        );
        _allSymbols.add(specialSymbol);
      }
    }
  }
}
