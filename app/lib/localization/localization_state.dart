import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LocalizationState extends Equatable {
  const LocalizationState();

  @override
  List<Object> get props => [];
}

class LocalizationUnintialized extends LocalizationState { }

class LocalizationLoading extends LocalizationState {
  
}

class LocalizationLoaded extends LocalizationState { 
  final Map<String, String> items;
 
  const LocalizationLoaded({@required this.items}) : assert(items != null);
  
  @override
  List<Object> get props => [items];

  @override
  String toString() => 'LocalizationLoaded {items : $items }';
  
}

class LocalizationError extends LocalizationState {

}