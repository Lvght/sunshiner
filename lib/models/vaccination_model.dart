// Province_State,Country_Region,Date,Doses_admin,People_partially_vaccinated,People_fully_vaccinated,Report_Date_St
// ring,UID

class VaccinationModel {
  final int uid;
  final String country;
  final String state;
  final DateTime date;
  final int dosesApplied;
  final int partiallyVaccinated;
  final int fullyVaccinated;
  final DateTime reportDate;

  // Construtor.
  VaccinationModel(
      {required this.country,
      required this.state,
      required this.date,
      required this.dosesApplied,
      required this.partiallyVaccinated,
      required this.fullyVaccinated,
      required this.reportDate,
      required this.uid});

  VaccinationModel.fromCsv(List props)
      : state = props[0] ?? "",
        country = props[1] ?? "",
        date = DateTime.parse(props[2]),
        dosesApplied = props[3] is int ? props[3] : 0,
        partiallyVaccinated = props[4] is int ? props[4] : 0,
        fullyVaccinated = props[5] is int ? props[5] : 0,
        reportDate = DateTime.parse(props[6]),
        uid = props[7] is int ? props[7] : 0;

  @override
  String toString() {
    String result = country +
        " " +
        state +
        " " +
        date.toString() +
        " " +
        dosesApplied.toString() +
        " " +
        partiallyVaccinated.toString() +
        " " +
        fullyVaccinated.toString() +
        " " +
        reportDate.toString() +
        " " +
        uid.toString();
    return result;
  }
}
