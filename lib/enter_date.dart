
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterDate extends StatelessWidget {
//  DateModel model;
 final TextEditingController _year= TextEditingController();
  final TextEditingController _month = TextEditingController();
  final TextEditingController  _day = TextEditingController();
 // List<Map> dateHolder = List();
  String message ="";

  void getDate(){
    try{
      if(_year.text == null && _year.text.length != 4 ||
          _month.text != null && _month.text.length != 2 ||
          _day.text != null && _day.text.length != 2){
        message = "All fields are required with appropriate digits value";
        //model =new DateModel("2015","07","28");
//        model = new DateModel("2015", "07", "28");

      }
      else if(_year.text != null && _year.text.length == 4 ||
          _month.text != null && _month.text.length == 2 ||
          _day.text != null && _day.text.length == 2){
        print(_year.text);
//      dateHolder.add({"year": _year.text});
//      dateHolder.add({"month": _month.text});
//      dateHolder.add({"day": _day.text});
        // model = new DateModel(_year.text,_month.text,_day.text);
//        model.year=_year.text;
//        model.month=_month.text;
//        model.day=_day.text;
//        model = new DateModel(_year.text, _month.text, _day.text);
//        print(model.day);
      }
    } catch(e){
      print(e.toString());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ENTER DATE"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child:
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child:  TextField(
                    decoration: InputDecoration(
                      labelText: "YYYY",
                      labelStyle: TextStyle(
                        fontSize: 25.0,
                          color: Colors.white70
                      )
                    ),
                    style: TextStyle(color: Colors.white70, fontSize: 25.0),
                    keyboardType: TextInputType.number,
                    controller: _year,
                  ),
                )),
                Expanded(child:
                Container(
                  child:  TextField(
                    decoration: InputDecoration(
                      labelText: "MM",
                        labelStyle: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white70
                        )
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white70, fontSize: 25.0),
                    controller: _month,
                  ),
                )),
                Expanded(child:
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child:  TextField(
                    decoration: InputDecoration(
                      labelText: "DD",
                        labelStyle: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white70
                        )
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white70, fontSize: 25.0),
                    controller: _day,
                  ),
                )),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0)),
            ListTile(
              title: FlatButton(onPressed: () {
                //getDate();

                if((_year.text == null && _year.text.length != 4) ||
                    (_month.text == null && _month.text.length != 2) ||
                    (_day.text == null && _day.text.length != 2)){
                  _showMessage(context, Text("All the field is required to fill with appropriate values",
                  style: TextStyle(fontSize: 20.0),));
                }
                else{
//                  model = new DateModel(_year.text, _month.text, _day.text);
                Navigator
              .pop(context, {
                  'year': _year.text,
                  'month': _month.text,
                  'day': _day.text
                });}},
                child: Text("GET RESULT", style: TextStyle(
                  fontSize: 22.0,
                  fontStyle: FontStyle.italic
                ),),
                textColor: Colors.white70,
                color: Colors.blue,
                focusColor: Colors.amber,
              ),
            )

          ],
        ),
      ),
    );
  }
  void _showMessage(BuildContext context, Widget message) {
    var alert = AlertDialog(
      title: Text(
        "Details",
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      backgroundColor: Colors.black,
      content: Builder(builder: (context) {
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
            child: Text("OK"))
      ],
    );
    showDialog(context: context, child: alert);
  }
}
