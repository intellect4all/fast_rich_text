
import '../models/parsed_node.dart';
import 'extensions.dart';
import '../models/special_symbol.dart';

class StringToNodeParser {
  static StringToNodeParser? _instance;

  const StringToNodeParser._();

  static StringToNodeParser get it {
    return _instance ??= const StringToNodeParser._();
  }

  List<ParsedNode> parse({
    required int startIndex,
    required int endIndex,
    required List<SpecialSymbol> symbolsToBeChecked,
  }) {
    List<ParsedNode> parsedNodes = [];
    int pointer = startIndex;

    if (symbolsToBeChecked.isEmpty || startIndex >= endIndex) {
      return [];
    }

    while (pointer < endIndex) {
      final matchedSymbol = symbolsToBeChecked.getMatchingSymbolOrNull(pointer);

      // no symbol matches this index
      if (matchedSymbol == null) {
        pointer++;
        continue;
      }

      if (matchedSymbol.isOutOfBound(
        pointer,
        startIndex: startIndex,
        endIndex: endIndex,
      )) {
        pointer += 2;
        continue;
      }

      // check if the next special symbol is also the current symbol
      if (matchedSymbol.isSymbol(pointer + 1)) {
        parsedNodes.add(
          matchedSymbol.parse(
            pointer,
          ),
        );

        pointer += 2;
        continue;
      } else {
        parsedNodes.add(
          matchedSymbol.parse(
            pointer,
            symbolsToBeChecked: symbolsToBeChecked
                .where((element) => element != matchedSymbol)
                .toList(),
            parser: it,
          ),
        );

        pointer = matchedSymbol.getPointerIndexAfterSymbolMatchedPair(pointer);
        continue;
      }
    }
    return parsedNodes;
  }
}
