import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:visitmalaysia/infoScreen.dart';
import 'destination.dart';
import 'infoScreen.dart';
import 'package:toast/toast.dart';
void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
  String curtype = "Destination";
  String titlecenter = "No data found";
  List destinationdata;
  String selectedState;
  List _dropDownState = [
    "Perlis",
    "Kedah",
    "Pulau Pinang",
    "Perak",
    "Kelantan",
    "Terengganu",
    "Selangor",
    "Wilayah Persekutuan",
    "Negeri Sembilan",
    "Pahang",
    "Melaka",
    "Johor",
    "Sabah",
    "Sarawak",
  ];

  String curstate = "Kedah";
  @override
  void initState() {
    super.initState();
    _loadDestination();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Locations',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: DropdownButton(
                hint: Text(
                  'Select State',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ), // Not necessary for Option 1
                value: selectedState,
                onChanged: (newValue) {
                  setState(() {
                    selectedState = newValue;
                    print(selectedState);
                  });
                  _sortItem(selectedState);
                },
                items: _dropDownState.map((selectedState) {
                  return DropdownMenuItem(
                    child: new Text(selectedState,
                        style: TextStyle(color: Colors.red)),
                    value: selectedState,
                  );
                }).toList(),
              )),
              Text(curstate,
                  style: TextStyle(
                    color: Colors.red,
                  )),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.8,
                      children: List.generate(destinationdata.length, (index) {
                        return Container(
                            child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => _destinationInfo(index),
                                        child: Container(
                                          height: screenHeight / 5.9,
                                          width: screenWidth / 3.5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                "http://slumberjer.com/visitmalaysia/images/${destinationdata[index]['imagename']}",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(destinationdata[index]['loc_name'],
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      SizedBox(height: 6),
                                      Text(
                                        destinationdata[index]['state'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )));
                      })))
            ],
          ),
        ),
      ),
    );
  }

  /*_onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.black,
              height: screenHeight / 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _destinationInfo(index),
                    child: Container(
                        height: screenWidth / 1.5,
                        width: screenWidth / 1.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: NetworkImage(
                                    "http://slumberjer.com/visitmalaysia/images/${destinationdata[index]['imagename']}")))),
                  )
                ],
              ),
            ));
      },
    );
  }*/

  void _loadDestination() {
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

  _destinationInfo(int index) async {
    Location destination = new Location(
        pid: destinationdata[index]['pid'],
        locName: destinationdata[index]['loc_name'],
        state: destinationdata[index]['state'],
        description: destinationdata[index]['description'],
        latitude: destinationdata[index]['latitude'],
        longitude: destinationdata[index]['longitude'],
        url: destinationdata[index]['url'],
        contact: destinationdata[index]['contact'],
        address: destinationdata[index]['address'],
        imagename: destinationdata[index]['imagename']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                InfoScreen(destination: destination)));
  }

  void _sortItem(String state) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = 
      "http://slumberjer.com/visitmalaysia/load_destinations.php";
    http.post(urlLoadJobs, body: {
      "state" : state,
    }).then((res) {
      setState(() {
        curstate = state;
        var extractdata = json.decode(res.body);
        destinationdata = extractdata["locations"];
        FocusScope.of(context).requestFocus(new FocusNode());
      pr.hide();
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
    } catch (e){
      Toast.show("Error", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    }
}


