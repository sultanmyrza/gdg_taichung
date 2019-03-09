import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    var reviewCollection = Firestore.instance.collection("gdg_taichung/polls/livecodeReview");


    
    return Scaffold(
      appBar: AppBar(
        title: Text("GDG taichung"),
      ),
      body: StreamBuilder(
        stream: reviewCollection.snapshots(),
        builder: _buildVotes,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.plus_one),
      ),
    );
  }

  Widget _buildVotes(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if(!snapshot.hasData){
      return CircularProgressIndicator();
    }else {
      var reviews = snapshot.data.documents;
      
      return ListView(children: reviews.map((review) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(review['title']),
            trailing: Text(review['vote'].toString()),
            onTap: () {
              print("ok");
               review.reference.updateData({
              'vote': review['vote'] + 1,
            });
            },
          ),
        );
      }).toList(),);
    }
  }
}
