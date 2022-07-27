import 'package:fast_rich_text/src/models/parsed_node.dart';
import 'package:fast_rich_text/src/utils/parser.dart';
import 'package:fast_rich_text/src/utils/string_to_node_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parser() should return a valid ParsedNode when given appropriateData',
    () {
      // arrange
      const tText = "*Lorem Ipsum* is simply dummy text"
          " of *the printing and typesetting* industry. "
          "*Lorem Ipsum has _been the industry's_ standard "
          "dummy text ever since the 1500s, when an unknown* "
          "printer took a galley of type and scrambled it to make "
          "a type specimen book. _It has *survived* not only five centuries, "
          "but also the leap into electronic typesetting, remaining essentially "
          "unchanged._ *It was popularised in the 1960s with the release of Letraset "
          "sheets containing* Lorem Ipsum passages, and more recently with desktop publishing "
          "software like Aldus PageMaker including "
          "versions of Lorem Ipsum";

      final tParser = Parser(
        text: tText,
        symbols: ['*', '_', '~'],
        stringToNodeParser: StringToNodeParser.it,
      );

      const tParsedNode = ParsedNode(
        startIndex: 0,
        endIndex: tText.length - 1,
        children: [
          ParsedNode(
            startIndex: 0,
            endIndex: 12,
            symbol: '*',
          ),
          ParsedNode(
            startIndex: 38,
            endIndex: 67,
            symbol: '*',
          ),
          ParsedNode(
            startIndex: 79,
            endIndex: 175,
            symbol: '*',
            children: [
              ParsedNode(
                startIndex: 96,
                endIndex: 116,
                symbol: '_',
              ),
            ],
          ),
          ParsedNode(
            startIndex: 254,
            endIndex: 377,
            symbol: '_',
            children: [
              ParsedNode(
                startIndex: 262,
                endIndex: 271,
                symbol: '*',
              ),
            ],
          ),
          ParsedNode(
            startIndex: 379,
            endIndex: 458,
            symbol: '*',
          ),
        ],
      );

      // act
      final result = tParser.parse();

      // assert
      expect(result, tParsedNode);
    },
  );
}
