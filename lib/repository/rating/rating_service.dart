import 'package:firebase_database/firebase_database.dart';
import 'package:hr_huntlng/models/rating.dart';

class RatingService {
  final databaseReference = FirebaseDatabase.instance.reference();

  void createData(String identifier, double clienteService, double teamWork,
      double confidence, double innovation, double attentionDetails) {
    databaseReference.child('data').child(identifier).set({
      'clienteService': clienteService,
      'teamWork': teamWork,
      'confidence': confidence,
      'innovation': innovation,
      'attentionDetails': attentionDetails,
    });
  }

  readData() async {
    Map data;
    await databaseReference
        .child('data')
        .once()
        .then((value) => data = value.value);
    var data2 = data.values.toList();
    List<RatingData> list = data2.map((e) => RatingData.fromJson(e)).toList();

    return list;
  }
}
