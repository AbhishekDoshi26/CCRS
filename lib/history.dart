import 'historydisp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:toast/toast.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {@required this.doc,
      this.description,
      this.category,
      this.subject,
      this.status,
      this.down});

  final doc;
  final description;
  final category;
  final subject;
  final status;
  final down;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Text("Form ID: " + doc),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text("See More"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => historydisplay(
                                  doc: doc,
                                  description: description,
                                  category: category,
                                  subject: subject,
                                  status: status,
                                  down: down)));
                      Toast.show(
                          "Please wait...Image will be loaded soon.", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }),
              ],
            )));
  }
}

// ignore: camel_case_types
class display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              Text(
                "History",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Forms')
                        .where("03 Email Id", isEqualTo: s)
                        .orderBy("01 Submitted On", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      if (!snapshot.hasData)
                        return new Text(
                            'No forms are available now!!!\n\nPlease try again later.',
                            style: TextStyle(fontSize: 15));
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text(
                            'Retrieving Forms...',
                            style: TextStyle(fontSize: 20),
                          );
                        default:
                          return new ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return CustomCard(
                                doc: document.documentID,
                                category: document['04 Category'],
                                subject: document['05 Subject'],
                                description: document['06 Description'],
                                status: document['08 Status'],
                                down: document['07 ImageURL'],
                              );
                            }).toList(),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
