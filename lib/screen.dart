import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ideasman_test/date_model.dart';

final TextEditingController year = TextEditingController();
final TextEditingController month = TextEditingController();
final TextEditingController day = TextEditingController();

class Screen extends StatefulWidget {
  var game;
  final DateModel models;
  Screen({Key key, this.models, this.game}) : super(key: key);
  @override
  _ScreenState createState() => _ScreenState(models, game);
}

class _ScreenState extends State<Screen> {

  var game;
  final DateModel models;
  _ScreenState(this.models, this.game);
  @override
  void initState() {
    super.initState();
    Screen(
      game: game,
    );
  }

  @override
  Widget build(BuildContext context) {
//    models = ModalRoute.of(context).settings.arguments;
    Widget favourite = Text("");
    return Scaffold(
        appBar: new AppBar(
          title: new Text(
            "SCOREBOARD TEST",
          ),
          centerTitle: true,
          backgroundColor: Colors.black54,
        ),
        backgroundColor: Colors.black54,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "YYYY",
                        labelStyle:
                            TextStyle(fontSize: 25.0, color: Colors.white70)),
                    style: TextStyle(color: Colors.white70, fontSize: 25.0),
                    keyboardType: TextInputType.number,
                    controller: year,
                  ),
                )),
                Expanded(
                    child: Container(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "MM",
                        labelStyle:
                            TextStyle(fontSize: 25.0, color: Colors.white70)),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white70, fontSize: 25.0),
                    controller: month,
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "DD",
                        labelStyle:
                            TextStyle(fontSize: 25.0, color: Colors.white70)),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white70, fontSize: 25.0),
                    controller: day,
                  ),
                )),
                Expanded(
                    child: Container(
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      //getDate();
                      if ((year.text == null || year.text.length != 4) ||
                          (month.text == null || month.text.length != 2) ||
                          (day.text == null || day.text.length != 2)) {
                        _showMessage(
                            context,
                            Text(
                              "All the fields are required to be filled with appropriate values",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white70),
                            ));
                      } else {
                        final models =
                            DateModel(year.text, month.text, day.text);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                Screen(game: game, models: models),
                            settings: RouteSettings(arguments: models)));
                      }
                    },
                    color: Colors.blue,
                  ),
                ))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: myFavourite(game, 'home'),
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
                                    _showMessage(
                                        context,
                                        Results(
                                            game[position]['linescore']
                                                ['inning'],
                                            game[position],
                                            'home'));
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
                                            'away'));
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
        ));
  }

  //
  void _showMessage(BuildContext context, Widget message) {
    var alert = AlertDialog(
      title: Text(
        "Attention",
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
          margin: EdgeInsets.only(right: 5.0),
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
          "No Games Today",
          style: TextStyle(fontSize: 50.0, color: Colors.white70),
        ),
      );
    }
  }
}
