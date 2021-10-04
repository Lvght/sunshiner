import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

part 'state_model.g.dart';

class StateModel = StateModelBase with _$StateModel;

abstract class StateModelBase with Store {
  String? country;

  @observable
  String? state;

  @observable
  Position? position;

  String? removeDiacritics(String? str) {
    if (str == null) return str;
    String withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str!.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  @action
  void setUserLocale({Position? position, String? state, String? country}) {
    this.country = removeDiacritics(country);
    this.state = removeDiacritics(state);
    this.position = position;
  }
}
