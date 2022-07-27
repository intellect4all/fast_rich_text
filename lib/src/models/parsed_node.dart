import 'package:equatable/equatable.dart';

/// The class to hold context about the current Node.
class ParsedNode extends Equatable {
  /// The index in the original text where formatting for this node should start
  final int startIndex;

  // The index in the original text where formatting for this node should end
  final int endIndex;

  /// Symbol at this node, indicating the text formatting to apply.
  ///
  /// Defaults to '' and treat the node as normal when no symbol supplied
  final String symbol;

  /// Other nodes present inside this node.
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
