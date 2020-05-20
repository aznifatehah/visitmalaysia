import 'dart:convert';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:visitmalaysia/destination.dart';
import 'package:http/http.dart' as http;
//import 'package:url_launcher/url_launcher.dart';

void main() => runApp(InfoScreen());

class InfoScreen extends StatefulWidget {
  final Location destination;
  const InfoScreen({Key key, this.destination}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}
 @override
class _InfoScreenState extends State<InfoScreen> {
  double screenHeight, screenWidth;
  List destinationdata;
  String urlLoadJobs =
      "http://slumberjer.com/visitmalaysia/load_destinations.php";
  @override
  void initState() {
    super.initState();
    _loadData();

}

Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // var imagename;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Info Page'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(height: 10),
            Container(
                height: screenHeight / 3,
                width: screenWidth / 1.5,
                // destinationdata==null,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: NetworkImage(
                            "http://slumberjer.com/visitmalaysia/images/${widget.destination.imagename}")))),
            SizedBox(height: 6),
            Container(
              width: screenWidth / 1.2,
              //height: screenHeight / 2,
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    Table(defaultColumnWidth: FlexColumnWidth(1.0), children: [
                      TableRow(children: [
                        TableCell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: Text("Desciption",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))),
                        ),
                        TableCell(
                            child: Container(
                          height: 65,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: Text(
                                //destinationdata[index]['description']
                                //"des",
                                widget.destination.description,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )),
                        )),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 25,
                              child: Text("URL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))),
                        ),
                        TableCell(
                            child: Container(
                          height: 50,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 20,
                              child: Text(
                                //destinationdata[index]['url']
                                widget.destination.url,
                                //"url",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )),
                        )),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: Text("Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))),
                        ),
                        TableCell(
                            child: Container(
                          height: 30,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: Text(
                                //destinationdata[index]['address']
                                widget.destination.address,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )),
                        )),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: Text("Contact",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))),
                        ),
                        TableCell(
                          child: Container(
                            height: 30,
                            child: Container(
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    //_callPhone(index);
                                  },child: Text(widget.destination.contact,style: TextStyle(
                          color: Colors.black,
                        ),)
                                )),
                          ),
                        )
                      ]),
                    ]),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _loadData() {
    String urlLoadJobs =
        "http://slumberjer.com/visitmalaysia/load_destinations.php";

    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        destinationdata = extractdata["locations"];
      });
    }).catchError((err) {
      print(err);
    });
  }

  /*_onImageDisplay(int index) {
    Container(
      color: Colors.blue,
      height: screenHeight / 2.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: screenWidth / 1.5,
              width: screenWidth / 1.5,
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.black),
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: NetworkImage(
                          "http://slumberjer.com/visitmalaysia/images/${destinationdata[index]['imagename']}")))),
        ],
      ),
    );
  }*/

}