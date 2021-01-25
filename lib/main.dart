import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ideasman_test/screen.dart';

void main() async {
  Map _score;
  var _game;
  if (year.text == null || year.text.length != 4) {
    _score = await getScores("2015", "07", "28");
  } else if (year.text != null || year.text.length == 4) {
    _score = await getScores(year.text, month.text, day.text);
  }
  _game = _score['data']['games']['game'];
  //
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Screen(
      game: _game,
    ),
  ));
}

//
Future<Map> getScores(String yearIn, String monthIn, String dayIn) async {
  String day = "", month = "", year = "";
  if (yearIn != null || monthIn != null || dayIn != null) {
    year = yearIn;
    month = monthIn;
    day = dayIn;
  } else {
    year = "2017";
    month = "09";
    day = "28";
  }
  String apiUrl = "http://gd2.mlb.com/components/game/mlb/year_" +
      year +
      "/month_" +
      month +
      "/day_" +
      day +
      "/master_scoreboard.json";
  http.Response response = await http.get(apiUrl);
  if (response.body.toString() != null) {
    return json.decode(response.body);
  } else {
    return {"failed": "Message failed"};
  }
}
