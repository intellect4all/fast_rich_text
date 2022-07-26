import 'package:flutter_rich_text/src/models/special_symbol.dart';

extension SymbolExtension on List<SpecialSymbol> {
  SpecialSymbol? getMatchingSymbolOrNull(int pointer) {
    final symbol = firstWhere(
      (element) => element.isSymbol(pointer),
      orElse: () => const SpecialSymbol(symbolChar: '', allIndexes: []),
    );

    return symbol.symbolChar.isNotEmpty ? symbol : null;
  }
}
