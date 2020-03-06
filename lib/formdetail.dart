import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer2/mailer.dart';
import 'package:toast/toast.dart';

String _st;
// ignore: must_be_immutable
class FormDetail extends StatefulWidget {
  FormDetail(
      {@required this.doc,
      this.description,
      this.category,
      this.subject,
      this.down,
      this.uemail,
      this.ph,
      this.nm,
      this.add});

  final doc;
  final description;
  final category;
  final subject;
  final down;
  final uemail;
  final ph;
  final nm;
  final add;

  @override
  _FormDetailState createState() => _FormDetailState();
}

class _FormDetailState extends State<FormDetail> {
  final db = Firestore.instance;

  void sendMail() {
    GmailSmtpOptions options = new GmailSmtpOptions()
      ..username = 'teamenigma96@gmail.com'
      ..password = 'opagpdcvbjrvkdzw';
    SmtpTransport emailTransport = new SmtpTransport(options);
    Envelope envelope = new Envelope()
      ..from = 'teamenigma96@gmail.com'
      ..recipients.add(widget.uemail)
      ..subject = 'Grievance Solved!!!'
      //..attachments.add(new Attachment(file: new File(fileName)))
      ..html =
          "<html><body><p><font size=3>Thanks for contacting us!<br>Your grievance for Form ID: <b>${widget.doc}</b> has been resolved and closed successfully!!</font></p></body></html>";
    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/back.jpg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
            color: Colors.grey.shade800,
            colorBlendMode: BlendMode.darken,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Text(
                    widget.doc,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Google-Sans',
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Text(
                            "Name: " + widget.nm,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontFamily: 'Google-Sans'),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Text(
                            "Phone Number: " + widget.ph,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontFamily: 'Google-Sans'),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Text(
                            "Address: " + widget.add,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontFamily: 'Google-Sans'),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Text(
                            "Category: " + widget.category,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontFamily: 'Google-Sans'),
                          ),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Text("Subject: " + widget.subject,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontFamily: 'Google-Sans')),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          Text("Description: " + widget.description,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontFamily: 'Google-Sans')),
                          Padding(padding: const EdgeInsets.only(top: 20)),
                          widget.down != null
                              ? Image.network(
                                  widget.down,
                                )
                              : new Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Radio(value: 'Pending', groupValue: _st, onChanged: (value) {
                                setState(() {
                                  _st =value;
                                });
                                print(_st);
                              }),
                              Text('Pending'),
                              Radio(value: 'Close', groupValue: _st, onChanged: (value) {
                                setState(() {
                                  _st ="Admin Closed";
                                });
                                print(_st);
                              }),
                              Text('Close'),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 90, right: 90),
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Set Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Google-Sans',
                                      fontSize: 18)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              splashColor: Colors.lightBlueAccent,
                              onPressed: () {
                                //sendMail();
                                db
                                    .collection('Forms')
                                    .document(widget.doc)
                                    .updateData({'09 Status': _st});
                                Toast.show(
                                    "Form " + widget.doc + " closed successfully",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
