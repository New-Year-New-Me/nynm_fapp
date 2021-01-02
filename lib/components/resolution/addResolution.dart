import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nynm_fapp/podo/resolution.dart';

class AddResolution extends StatefulWidget {
  @override
  _AddResolutionState createState() => _AddResolutionState();
}

class _AddResolutionState extends State<AddResolution> {
  TextEditingController resolutionController = new TextEditingController();
  ResolutionType type = ResolutionType.CONTINUOUS;
  DateTime endDate = DateTime.now().add(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Resolution"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: resolutionController,
                cursorColor: Colors.black38,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Colors.black54, fontSize: 32),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Give a gist of the resolution your are building",
                    hintMaxLines: 5,
                    hintStyle: TextStyle(fontWeight: FontWeight.w100)),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChoiceChip(
                  label: Text("Continuous"),
                  selected: type == ResolutionType.CONTINUOUS,
                  onSelected: (selected) {
                    if (selected)
                      setState(() {
                        type = ResolutionType.CONTINUOUS;
                      });
                  },
                ),
                ChoiceChip(
                  label: Text("Attainable"),
                  selected: type == ResolutionType.ATTAINABLE,
                  onSelected: (selected) {
                    if (selected)
                      setState(() {
                        type = ResolutionType.ATTAINABLE;
                      });
                  },
                )
              ],
            ),
            if (type == ResolutionType.ATTAINABLE)
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    DateFormat.yMMMMEEEEd().format(endDate),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  // Expanded(child: Container()),
                  IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.calendar_today_outlined),
                      onPressed: pickDate)
                ]),
              ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                colorBrightness: Brightness.dark,
                color: Colors.blue,
                onPressed: next,
                child: Text("Add"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void next() async {
    if (resolutionController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill the resolution title", backgroundColor: Colors.red);
      return;
    }
    Resolution resolution =
        Resolution(resolutionController.text, type, endDate);
    Navigator.pop(context, resolution);
  }

  void pickDate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 60)))
      ..then((date) {
        setState(() {
          endDate = date;
        });
      });
  }
}
