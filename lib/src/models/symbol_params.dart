import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SymbolParams extends Equatable {
  final String symbolCharacter;
  final TextStyle? style;

  const SymbolParams({
    required this.symbolCharacter,
    this.style,
  }) : assert(symbolCharacter.length < 2);

  @override
  List<Object> get props => [symbolCharacter];
}
