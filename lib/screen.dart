import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ideasman_test/enter_date.dart';


class Screen extends StatefulWidget {
  Screen();
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  static String _yearEntered;
  static String _monthEntered;
  static String _dayEntered;

  _ScreenState();

  Future  _receiveModel (BuildContext context) async {
    final Map model = await Navigator.push(context, MaterialPageRoute<Map>(
        builder: (context){
          return EnterDate();
        }
    ));

    if(model != null && model.containsKey("year") ){
      setState(() {
        _yearEntered = model['year'];
        _monthEntered = model['month'];
        _dayEntered = model['day'];
      });
    }
    else {
      print("Nothing");
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text(
            "SCOREBOARD TEST",
          ),
          centerTitle: true,
          backgroundColor: Colors.black54,
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: (){
              _receiveModel(context);
            })
          ],
        ),
        backgroundColor: Colors.black54,
        body: updateScores(_yearEntered == null ? "2015" : _yearEntered,
            _monthEntered == null ? "07" : _monthEntered,
            _dayEntered == null ? "29": _dayEntered));
  }
  // Future Class
  Future<Map> getScoreResults(String year, String month, String day) async {
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
    }
  }
  // Future Builder

  Widget updateScores(String year, String month, String day){
    return FutureBuilder(
        future: getScoreResults(year, month, day),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
          if(snapshot.hasData && snapshot.data['data']['games']['game'] == null){
            return new Container(
              child: Center(
                child: Text(" No Match Today\n ${_yearEntered == null ? '2015' : _yearEntered}/"
                    "${_monthEntered == null ? '07' : _monthEntered}/${_dayEntered == null ? '29' : _dayEntered}", style: TextStyle(fontSize: 40.0, color: Colors.white),),
              ),
            );
          }
          else if(snapshot.hasData){
            Map content = snapshot.data;
            return mainBody(content);
          }
          else if(snapshot.hasError){
            return new Container(
              child: Center(
                child: Text("${snapshot.error.toString()} Failed...", style: TextStyle(fontSize: 35.0, color: Colors.white),),
              ),
            );
          }
          else{
            return new Container(
              alignment: Alignment.center,
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 160,
                height: 160,
              ),
            );
          }
        });
  }

  //
  void _showMessage(BuildContext context, Widget message, String titile) {
    var alert = AlertDialog(
      title: Text(
        titile,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      backgroundColor: Colors.black,
      content: Builder(builder: (context) {
        MediaQuery.of(context).size.height;
        MediaQuery.of(context).size.width;
        return message;
      }),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      insetPadding: EdgeInsets.zero,
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back"))
      ],
    );
    showDialog(context: context, child: alert);
  }
  Widget winnersHome(List<dynamic> result, int position){
    String home = result[position]['linescore']['r']['home'].toString();
    String away = result[position]['linescore']['r']['away'].toString();
    Widget bold;
    if(int.parse(home) > int.parse(away)){
      bold = Text(
        "${result[position]['home_team_name'].toString()} \t${result[position]['linescore']['r']['home'].toString()}\t:",
        style: TextStyle(
            fontSize: 23.0, color: Colors.grey, fontWeight: FontWeight.w900),
      );
    }
    else{
      bold = Text(
        " ${result[position]['home_team_name'].toString()} \t${result[position]['linescore']['r']['home'].toString()}\t",
        style: TextStyle(
            fontSize: 21.0, color: Colors.grey),
      );
    }
    return bold;

  }
  //
  Widget winnersAway(List<dynamic> result, int position){
    String home = result[position]['linescore']['r']['home'].toString();
    String away = result[position]['linescore']['r']['away'].toString();
    Widget bold;
    if(int.parse(home) < int.parse(away)){
      bold = Text(
        ":\t${result[position]['linescore']['r']['away'].toString()} \t${result[position]['away_team_name'].toString()}",
        style: TextStyle(
          fontSize: 23.0, color: Colors.grey, fontWeight: FontWeight.w900,),
      );
    }
    else{
      bold = Text(
        "\t${result[position]['linescore']['r']['away'].toString()} \t${result[position]['away_team_name'].toString()}",
        style: TextStyle(
            fontSize: 21.0, color: Colors.grey),
      );
    }
    return bold;

  }

  Widget Results(List<dynamic> results, Map team, String match) {
    List<Widget> list = List<Widget>();
    List<Widget> list2 = List<Widget>();
    List<Widget> header = List<Widget>();
    list.add(Text("Inning: ",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white)));
    list.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    list2.add(Padding(padding: EdgeInsets.only(right: 99.5)));
    header.add(Padding(padding: EdgeInsets.only(right: 99.5)));
//    list1.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    for (var i = 0; i < results.length; i++) {
      list.add(
        Container(
          margin: EdgeInsets.only(right: 5.0),
          child: Text(
            results[i][match].toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white),
          ),
        ),
      );
    }
    list2.add(holder(team, match, 'r'));
    list2.add(Padding(padding: EdgeInsets.only(right: 9.5)));
    list2.add(holder(team, match, 'h'));
    list2.add(Padding(padding: EdgeInsets.only(right: 9.5)));
    list2.add(holder(team, match, 'e'));
    list2.add(Padding(padding: EdgeInsets.only(right: 9.5)));
    list2.add(holder(team, match, 'hr'));
    list2.add(Padding(padding: EdgeInsets.only(right: 9.5)));
    list2.add(holder(team, match, 'sb'));
    list2.add(Padding(padding: EdgeInsets.only(right: 9.5)));
    list2.add(holder(team, match, 'so'));
    header.add(Text(
      "R",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
    ));
    header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    header.add(Text(
      "H",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
    ));
    header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    header.add(Text(
      "E",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
    ));
    header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    header.add(Text(
      "HR",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
    ));
    header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    header.add(Text(
      "SB",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
    ));
    header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    header.add(Text(
      "SO",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
    ));
    header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
    Widget container = Container(
      margin: EdgeInsets.only(top: 5.0, left: 0.0),
      child: Text("status: \t\t${team['status']['status']}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.white)),
    );
    Widget inning = Container(
      margin: EdgeInsets.only(top: 5.0, left: 0.0),
      child: Text("Inning State: \t\t${team['status']['inning_state']}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.white)),
    );
    return Container(
        width: double.infinity,
        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: header),
            Row(children: list2),
            container,
            inning,
            Row(children: list)
          ],
        ));
  }

  Widget holder(Map team, String match, String value) {
    return Container(
      margin: EdgeInsets.only(right: 4.0),
      child: Text(
        "${team['linescore'][value][match]}",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
      ),
    );
  }

  Widget myFavourite(List<dynamic> results, String match) {
    List<Widget> home_team = List<Widget>();
    List<Widget> away_team = List<Widget>();
    List<Widget> header = List<Widget>();
    bool check = false;
    header.add(Padding(padding: EdgeInsets.only(right: 99.0)));
    for (var i = 0; i < results.length; i++) {
      if (results[i]['home_team_name'].toString() == "Blue Jays" ||
          results[i]['away_team_name'].toString() == "Blue Jays") {
        check = true;
        home_team.add(Container(
          margin: EdgeInsets.only(right: 10.0),
          child: Text(
            "${results[i]['home_team_name'].toString()}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
        ));
        home_team.add(Padding(padding: EdgeInsets.only(right: 17.5)));
        away_team.add(Container(
          margin: EdgeInsets.only(right: 10.0),
          child: Text(
            "${results[i]['away_team_name'].toString()}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
        ));
        away_team.add(Padding(padding: EdgeInsets.only(right: 17.5)));

        for (var j = 0; j < results[i]['linescore']['inning'].length; j++) {
          home_team.add(
            Container(
              margin: EdgeInsets.only(right: 7.0),
              child: Text(
                results[i]['linescore']['inning'][j]['home'].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white),
              ),
            ),
          );
          away_team.add(
            Container(
              margin: EdgeInsets.only(right: 7.0),
              child: Text(
                results[i]['linescore']['inning'][j]['away'].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white),
              ),
            ),
          );
          header.add(Text(
            "${j + 1}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ));
          header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
          //away
        }
        header.add(Text(
          "R",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
        header.add(Text(
          "H",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
        header.add(Text(
          "E",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        header.add(Padding(padding: EdgeInsets.only(right: 7.5)));
        home_team.add(Text(
          "${results[i]['linescore']['r']['home']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        home_team.add(Padding(padding: EdgeInsets.only(right: 7.5)));
        away_team.add(Text(
          "${results[i]['linescore']['r']['away']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        away_team.add(Padding(padding: EdgeInsets.only(right: 7.5)));
        home_team.add(Text(
          "${results[i]['linescore']['h']['home']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        home_team.add(Padding(padding: EdgeInsets.only(right: 9.5)));
        away_team.add(Text(
          "${results[i]['linescore']['h']['away']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        away_team.add(Padding(padding: EdgeInsets.only(right: 9.5)));
        home_team.add(Text(
          "${results[i]['linescore']['e']['home']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        home_team.add(Padding(padding: EdgeInsets.only(right: 5.5)));
        away_team.add(Text(
          "${results[i]['linescore']['e']['away']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ));
        away_team.add(Padding(padding: EdgeInsets.only(right: 5.5)));

        return Container(
            height: 100.0,
            width: double.infinity,
            child: Column(
              children: [
                Row(children: header),
                Row(children: home_team),
                Padding(padding: EdgeInsets.only(bottom: 10.0)),
                Row(children: away_team),
              ],
            ));
      }
    }
    if (check == false) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "Blue Jay has no game today",
          style: TextStyle(fontSize: 30.0, color: Colors.white70),
        ),
      );
    }
  }
  //

  Widget mainBody(Map content){
    var game = content['data']['games']['game'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          alignment: Alignment.centerRight,
          child: myFavourite(game, 'home'),
        ),
        Container(
          child: Text("Date: ${_yearEntered == null ? '2015' : _yearEntered}/"
              "${_monthEntered == null ? '07' : _monthEntered}/${_dayEntered == null ? '29' : _dayEntered}",
            style: TextStyle(color: Colors.white, fontSize: 23.0),),
        ),
        Padding(padding: EdgeInsets.only(bottom: 3.0)),
        Expanded(
            child: ListView.builder(
                itemCount: game.length,
                padding: EdgeInsets.all(16.0),
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              child: Center(
                                  child: winnersHome(game, position)
                              ),
                              onTap: () {
                                _showMessage(context, Results(
                                    game[position]['linescore']
                                    ['inning'],
                                    game[position],
                                    'home'),"Details");
                              },
                            ),
                            GestureDetector(
                              child: Center(
                                child: winnersAway(game, position),
                              ),
                              onTap: () {
                                _showMessage(
                                    context,
                                    Results(
                                        game[position]['linescore']
                                        ['inning'],
                                        game[position],
                                        'away'), "Details");
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }))
      ],
    );
  }

}
