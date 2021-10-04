// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StateModel on StateModelBase, Store {
  final _$stateAtom = Atom(name: 'StateModelBase.state');

  @override
  String? get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(String? value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$positionAtom = Atom(name: 'StateModelBase.position');

  @override
  Position? get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(Position? value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  final _$StateModelBaseActionController =
      ActionController(name: 'StateModelBase');

  @override
  void setUserLocale({Position? position, String? state, String? country}) {
    final _$actionInfo = _$StateModelBaseActionController.startAction(
        name: 'StateModelBase.setUserLocale');
    try {
      return super
          .setUserLocale(position: position, state: state, country: country);
    } finally {
      _$StateModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
position: ${position}
    ''';
  }
}
