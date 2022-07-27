import 'package:fast_rich_text/src/models/parsed_node.dart';
import 'package:fast_rich_text/src/models/special_symbol.dart';
import 'package:fast_rich_text/src/utils/string_to_node_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'special_symbol_test.mocks.dart';

@GenerateMocks([StringToNodeParser])
void main() {
  const starSymbolChar = '*';
  const starSymbolIndexes = [2, 5, 8, 12, 15];
  const allIndexes = [2, 3, 4, 5, 6, 7, 8, 10, 12, 15, 17, 20, 29, 38];

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

  group('indexes', () {
    test(
      'should return the correct index of char at the pointer in the symbol indexes',
      () async {
        // arrange
        const tPointer = 3;
        const indexOf5inSymbolIndexes = 1;

        // act
        final result = tStarSymbol.charIndexInSymbolList(tPointer);

        // assert
        expect(result, indexOf5inSymbolIndexes);
      },
    );

    test(
      'should return true if indexes contain a given index',
      () async {
        // arrange
        const tPointer = 3;
        // act
        final result = tStarSymbol.isSymbol(tPointer);

        // assert
        expect(result, true);
      },
    );

    test(
      'should return false if indexes does not contain a given index',
      () async {
        // arrange
        const tPointer = 1;

        // act
        final result = tStarSymbol.isSymbol(tPointer);

        // assert
        expect(result, false);
      },
    );

    test(
      'should return the charIndexInSymbolList at pointer incremented by 1',
      () async {
        // arrange
        const tPointer = 3;
        final expectedRes = tStarSymbol.charIndexInSymbolList(tPointer) + 1;

        // act
        final result = tStarSymbol.nextSymbolIndex(tPointer);

        // assert
        expect(result, expectedRes);
      },
    );

    test(
      'should return the pointer index after a symbol matched pair',
      () async {
        // arrange

        const tPointer = 0;
        const expected = 4;

        // act
        final result =
            tStarSymbol.getPointerIndexAfterSymbolMatchedPair(tPointer);

        // assert
        expect(result, expected);
      },
    );

    test(
      'should return the pointer index before a symbol matched pair',
      () async {
        // arrange

        const tPointer = 0;
        const expected = 2;

        // act
        final result =
            tStarSymbol.getPointerIndexBeforeSymbolMatchedPair(tPointer);

        // assert
        expect(result, expected);
      },
    );
  });

  group('isOutOfBound', () {
    test(
      "should return true when the next matched symbol after pointer is at symbol's last index",
      () async {
        // arrange
        const tPointer = 9;

        // act
        final result = tStarSymbol.isOutOfBound(
          tPointer,
          startIndex: 0,
          endIndex: allIndexes.length - 1,
        );

        // assert
        expect(result, true);
      },
    );

    test(
      "should return true when the next matched symbol after pointer is out of scope",
      () async {
        // arrange
        const tPointer = 3;

        // act
        final result = tStarSymbol.isOutOfBound(
          tPointer,
          startIndex: 3,
          endIndex: 5,
        );

        // assert
        expect(result, true);
      },
    );

    test(
      "should return false when the next matched symbol is valid",
      () async {
        // arrange
        const tPointer = 3;

        // act
        final result = tStarSymbol.isOutOfBound(
          tPointer,
          startIndex: 3,
          endIndex: 9,
        );

        // assert
        expect(result, false);
      },
    );
  });

  group(
    'parse()',
    () {
      late MockStringToNodeParser stringToNodeParser;
      setUp(() {
        stringToNodeParser = MockStringToNodeParser();
      });
      test(
        'should return a parsedNode with empty children when symbolsToBeChecked is empty',
        () async {
          when(
            stringToNodeParser.parse(
              startIndex: anyNamed('startIndex'),
              endIndex: anyNamed('endIndex'),
              symbolsToBeChecked: [],
            ),
          ).thenAnswer((realInvocation) => []);

          const tStartIndex = 2; //@ symbolIndexes[0];
          const tEndIndex = 5; //@ symbolIndexes[3];
          const tPointer = 0; //index of 2 at allIndexes

          // arrange
          const tParsedNodeWithNoChildren = ParsedNode(
            startIndex: tStartIndex,
            symbol: '*',
            endIndex: tEndIndex,
            children: [],
          );

          // act
          final res = tStarSymbol.parse(
            tPointer,
            parser: stringToNodeParser,
          );

          // assert
          expect(res, tParsedNodeWithNoChildren);
          verify(stringToNodeParser
              .parse(startIndex: 1, endIndex: 2, symbolsToBeChecked: []));
          verifyNoMoreInteractions(stringToNodeParser);
        },
      );
      test(
        'should return a parsedNode with empty children when parser is null',
        () async {
          when(
            stringToNodeParser.parse(
              startIndex: anyNamed('startIndex'),
              endIndex: anyNamed('endIndex'),
              symbolsToBeChecked: [],
            ),
          ).thenAnswer((_) => []);

          const tStartIndex = 2; //@ symbolIndexes[0];
          const tEndIndex = 5; //@ symbolIndexes[3];
          const tPointer = 0; //index of 2 at allIndexes

          // arrange
          const tParsedNodeWithNoChildren = ParsedNode(
            startIndex: tStartIndex,
            symbol: '*',
            endIndex: tEndIndex,
            children: [],
          );

          // act
          final res = tStarSymbol.parse(
            tPointer,
          );

          // assert
          expect(res, tParsedNodeWithNoChildren);
          verifyZeroInteractions(stringToNodeParser);
          verifyNoMoreInteractions(stringToNodeParser);
        },
      );

      test(
        'should return a parsedNode with valid children when symbolsToBeChecked is not empty',
        () async {
          const tUnderscoreNode = ParsedNode(
            startIndex: 3,
            endIndex: 4,
            symbol: underscoreSymbolChar,
          );
          when(
            stringToNodeParser.parse(
              startIndex: 1,
              endIndex: 2,
              symbolsToBeChecked: [tUnderscoreSymbol],
            ),
          ).thenAnswer((realInvocation) => [tUnderscoreNode]);

          const tStartIndex = 2; //@ symbolIndexes[0];
          const tEndIndex = 5; //@ symbolIndexes[3];
          const tPointer = 0; //index of 2 at allIndexes

          // arrange
          const tParsedNodeWithChildren = ParsedNode(
            startIndex: tStartIndex,
            symbol: '*',
            endIndex: tEndIndex,
            children: [tUnderscoreNode],
          );

          // act
          final res = tStarSymbol.parse(tPointer,
              parser: stringToNodeParser,
              symbolsToBeChecked: [tUnderscoreSymbol]);

          // assert
          expect(res, tParsedNodeWithChildren);
          verify(
            stringToNodeParser.parse(
              startIndex: 1,
              endIndex: 2,
              symbolsToBeChecked: [tUnderscoreSymbol],
            ),
          );
          verifyNoMoreInteractions(stringToNodeParser);
        },
      );
    },
  );
}
