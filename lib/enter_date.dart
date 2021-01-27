
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterDate extends StatelessWidget {
  var _year= TextEditingController();
  var _month = TextEditingController();
  var _day = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ENTER DATE"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: Container(
        color: Colors.grey,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child:
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child:  TextField(
                    decoration: InputDecoration(
                        labelText: "YYYY",
                        labelStyle: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black54
                        )
                    ),
                    style: TextStyle(color: Colors.black54, fontSize: 25.0),
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
                            color: Colors.black54
                        )
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black54, fontSize: 25.0),
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
                            color: Colors.black54
                        )
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black54, fontSize: 25.0),
                    controller: _day,
                  ),
                )),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0)),
            ListTile(
              title: FlatButton(onPressed: () {
                //getDate();

                if((_year.text == null || _year.text.length != 4) ||
                    (_month.text == null || _month.text.length != 2) ||
                    (_day.text == null || _day.text.length != 2)){
                  _showMessage(context, Text("All the fields are required to be filled with appropriate values",
                    style: TextStyle(fontSize: 20.0, color: Colors.red),));
                }
                else{
                  Navigator.pop(context,  {
                    'year': _year.text,
                    'month': _month.text,
                    'day': _day.text
                  });
                }},
                child: Text("GET RESULT", style: TextStyle(
                    fontSize: 22.0,
                    fontStyle: FontStyle.normal
                ),),
                textColor: Colors.white70,
                color: Colors.black54,
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
        "Attention",
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
