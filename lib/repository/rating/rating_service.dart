import 'package:firebase_database/firebase_database.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/preferences/preferences_repository.dart';

class RatingService {
  final databaseReference = FirebaseDatabase.instance.reference();
  PreferenceRepository _preferenceRepository = PreferenceRepository();

  void createData(
      String quizname,
      String identifier,
      String feelings,
      double clienteService,
      double teamWork,
      double confidence,
      double innovation,
      double attentionDetails) {
    databaseReference.child(quizname).child(identifier).set({
      'feelings': feelings,
      'clienteService': clienteService,
      'teamWork': teamWork,
      'confidence': confidence,
      'innovation': innovation,
      'attentionDetails': attentionDetails,
    });
  }

  readData() async {
     String quizname = await _preferenceRepository.getData('data');
    Map data;
    await databaseReference
        .child(quizname)
        .once()
        .then((value) => data = value.value);
    var data2 = data.values.toList();
    List<RatingData> list = data2.map((e) => RatingData.fromJson(e)).toList();

    return list;
  }
}
