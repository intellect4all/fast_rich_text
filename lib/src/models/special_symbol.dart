import 'package:equatable/equatable.dart';

import '../utils/string_to_node_parser.dart';
import 'parsed_node.dart';

class SpecialSymbol extends Equatable {
  /// The symbol to be parsed.
  final String symbolChar;

  /// Indexes where the symbol occurs in the text to be parsed.
  final List<int> indexes;

  /// Indexes of symbols in text.
  ///
  /// All indexes where of all the special parsing symbols occur in the text to
  /// be parsed, including this [indexes], in chronological order.
  final List<int> allIndexes;

  const SpecialSymbol({
    required this.symbolChar,
    this.indexes = const [],
    required this.allIndexes,
  }) : assert(symbolChar.length < 2);

  /// The index of the Character at [pointer] in this symbol.
  int charIndexInSymbolList(int pointer) {
    return indexes.indexOf(allIndexes[pointer]);
  }

  bool isSymbol(int pointer) {
    return indexes.contains(allIndexes[pointer]);
  }

  int getPointerIndexAfterSymbolMatchedPair(int pointer) {
    return allIndexes.indexOf(indexes[nextSymbolIndex(pointer)]) + 1;
  }

  int getPointerIndexBeforeSymbolMatchedPair(int pointer) {
    return allIndexes.indexOf(indexes[nextSymbolIndex(pointer)]) - 1;
  }

  int nextSymbolIndex(pointer) {
    return charIndexInSymbolList(pointer) + 1;
  }

  /// Checks if the next symbol index after this pointer exists within the length of this symbol
  /// [indexes] and the given scope of [allIndexes].
  ///
  /// If [true], then skip this symbol two places, else continue parsing.
  bool isOutOfBound(pointer, {required int startIndex, required int endIndex}) {
    int nextSymbolIndex = charIndexInSymbolList(pointer) + 1;
    return nextSymbolIndex >= indexes.length ||
        indexes[nextSymbolIndex] > allIndexes[endIndex];
  }

  ParsedNode parse(
    int currentIndexPointer, {
    List<SpecialSymbol> symbolsToBeChecked = const [],
    StringToNodeParser? parser,
  }) {
    return ParsedNode(
      startIndex: indexes[charIndexInSymbolList(currentIndexPointer)],
      endIndex: indexes[nextSymbolIndex(currentIndexPointer)],
      symbol: symbolChar,
      children: parser?.parse(
            startIndex: currentIndexPointer + 1,
            endIndex:
                getPointerIndexBeforeSymbolMatchedPair(currentIndexPointer),
            symbolsToBeChecked: symbolsToBeChecked,
          ) ??
          [],
    );
  }

  @override
  List<Object?> get props => [symbolChar, allIndexes];
}
