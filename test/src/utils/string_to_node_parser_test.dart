import 'package:flutter_rich_text/src/models/parsed_node.dart';
import 'package:flutter_rich_text/src/models/special_symbol.dart';
import 'package:flutter_rich_text/src/utils/string_to_node_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'string_to_node_parser_test.mocks.dart';

@GenerateMocks([SpecialSymbol])
void main() {
  final tParser1 = StringToNodeParser.it;
  const starSymbolChar = '*';
  const starSymbolIndexes = [2, 5, 8, 12, 15, 18];
  const allIndexes = [2, 3, 4, 5, 6, 7, 8, 10, 12, 15, 18, 20, 29, 38];

  SpecialSymbol tStarSymbol = const SpecialSymbol(
    symbolChar: starSymbolChar,
    indexes: starSymbolIndexes,
    allIndexes: allIndexes,
  );

  const underscoreSymbolChar = '_';
  const underScoreSymbolIndexes = [3, 4, 6, 7];

  SpecialSymbol tUnderscoreSymbol = const SpecialSymbol(
    symbolChar: underscoreSymbolChar,
    indexes: underScoreSymbolIndexes,
    allIndexes: allIndexes,
  );

  MockSpecialSymbol mockSymbol = MockSpecialSymbol();

  test(
    'should test that StringToNode is a singleton class',
    () async {
      // arrange

      final tParser2 = StringToNodeParser.it;
      // act

      // assert
      expect(tParser1, tParser2);
    },
  );

  group(
    'parse()',
    () {
      test(
        'should return an empty list when symbols to be check is empty',
        () async {
          // arrange
          const tStartIndex = 0;
          const tEndIndex = 2;
          // act
          final result = tParser1.parse(
            startIndex: tStartIndex,
            endIndex: tEndIndex,
            symbolsToBeChecked: [],
          );

          // assert
          expect(result, []);
        },
      );

      test(
        'should return an empty list when startIndex is >= endIndex',
        () async {
          // arrange
          const tStartIndex = 1;
          const tEndIndex = 1;

          // act
          final result = tParser1.parse(
            startIndex: tStartIndex,
            endIndex: tEndIndex,
            symbolsToBeChecked: [tStarSymbol, tUnderscoreSymbol],
          );

          // assert
          expect(result, []);
        },
      );

      test(
        'should return a valid node when given appropriate parameters',
        () async {
          // arrange
          const tStartIndex = 0;
          const tEndIndex = 5;

          final expected = [
            const ParsedNode(
              startIndex: 2,
              endIndex: 5,
              symbol: starSymbolChar,
              children: [
                ParsedNode(
                  startIndex: 3,
                  endIndex: 4,
                  symbol: underscoreSymbolChar,
                )
              ],
            ),
            const ParsedNode(
              startIndex: 6,
              endIndex: 7,
              symbol: underscoreSymbolChar,
            )
          ];

          // act
          final result = tParser1.parse(
            startIndex: tStartIndex,
            endIndex: tEndIndex,
            symbolsToBeChecked: [tStarSymbol, tUnderscoreSymbol],
          );

          // assert
          expect(result, equals(expected));
        },
      );
    },
  );
}
