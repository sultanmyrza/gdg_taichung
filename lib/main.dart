import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Solution(title: 'Flutter Demo Home Page'),
    );
  }
}

class Solution extends StatefulWidget {
  Solution({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SolutionState createState() => _SolutionState();
}

class _SolutionState extends State<Solution> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var codeLab = Firestore.instance.collection("polls/gdg_taichung/codelab");
    var pollsCollection = Firestore.instance.collection("polls/gdg_taichung");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: codeLab.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            var votes = snapshot.data.documents;

            return PageView(
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("polls/gdg_taichung/codelab")
                      .snapshots(),
                  builder: _buildCodelabList,
                ),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("polls/gdg_taichung/language")
                      .snapshots(),
                  builder: _buildLanguageList,
                )
              ],
            );

            return ListView(
              children: votes.map((vote) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    title: Text(vote['title']),
                    trailing: Text(vote['votes'].toString()),
                    onTap: () => vote.reference.updateData({
                          'votes': vote['votes'] + 1,
                        }),
                  ),
                );
              }).toList(),
            );

            return Text("Data loaded");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildCodelabList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    } else {
      var codelabs = snapshot.data.documents;
      return ListView(
        children: codelabs.map((codelab) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(codelab['title']),
              trailing: Text(codelab['votes'].toString()),
              onTap: () => codelab.reference.updateData({
                    'votes': codelab['votes'] + 1,
                  }),
            ),
          );
        }).toList(),
      );
      return Text("data loaded");
    }
  }

  Widget _buildLanguageList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    } else {
      var languages = snapshot.data.documents;
      return ListView(
        children: languages.map((language) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(language['title']),
              trailing: Text(language['speakers'].toString()),
              onTap: () => language.reference.updateData({
                'speakers': language['speakers'] + 1,
              }),
            ),
          );
        }).toList(),
      );

    }
  }
}
