// To parse this JSON data, do
//
//     final ratingData = ratingDataFromJson(jsonString);

import 'dart:convert';

RatingData ratingDataFromJson(String str) => RatingData.fromJson(json.decode(str));

String ratingDataToJson(RatingData data) => json.encode(data.toJson());

class RatingData {
    RatingData({
        this.innovation,
        this.attentionDetails,
        this.teamWork,
        this.confidence,
        this.clienteService,
    });

    int innovation;
    int attentionDetails;
    int teamWork;
    int confidence;
    int clienteService;

    factory RatingData.fromJson(dynamic json) => RatingData(
        innovation: json["innovation"],
        attentionDetails: json["attentionDetails"],
        teamWork: json["teamWork"],
        confidence: json["confidence"],
        clienteService: json["clienteService"],
    );

    Map<String, dynamic> toJson() => {
        "innovation": innovation,
        "attentionDetails": attentionDetails,
        "teamWork": teamWork,
        "confidence": confidence,
        "clienteService": clienteService,
    };
}
