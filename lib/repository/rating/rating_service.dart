import 'package:firebase_database/firebase_database.dart';

class RatingService {
  final databaseReference = FirebaseDatabase.instance.reference();

  void createData(String identifier, double clienteService, double teamWork,
      double confidence, double innovation, double attentionDetails) {
        
    databaseReference.child(identifier).set({
      'clienteService': clienteService,
      'teamWork': teamWork,
      'confidence': confidence,
      'innovation': innovation,
      'attentionDetails': attentionDetails,
    });
  }
}
