import 'package:equatable/equatable.dart';

class ParsedNode extends Equatable {
  final int startIndex;
  final int endIndex;

  /// symbol at this node, indicating the TextFormatting to apply
  final String symbol;

  /// other nodes present inside this node
  final List<ParsedNode> children;

  const ParsedNode({
    this.children = const [],
    required this.startIndex,
    required this.endIndex,
    this.symbol = '',
  });

  @override
  List<Object?> get props => [
        startIndex,
        endIndex,
        symbol,
        children,
      ];
}
