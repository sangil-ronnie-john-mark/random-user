import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? name;
  String? country;
  String? gender;
  String? email;
  String? username;
  String? phoneNumber;

  Future<void> getData() async {

    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 6));
      print("connected");
      setState(() {
        data = [jsonDecode(response.body)];
      });

      print(data[0]['results'][0]['phone']);
      String image = data[0]['results'][0]['picture']['large'];
      name = data[0]['results'][0]['name']['title'] + '. ' + data[0]['results'][0]['name']['first'] +' '+ data[0]['results'][0]['name']['last'];
       country = data[0]['results'][0]['location']['country'];
       gender = data[0]['results'][0]['gender'];
       email = data[0]['results'][0]['email'];
       username = data[0]['results'][0]['login']['username'];
      phoneNumber = data[0]['results'][0]['phone'];
      await Future.delayed(Duration(seconds: 3));
      } catch(e) {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text('Message'),
          content: Text('No internet connection'),
          actions: [
            TextButton(onPressed: (){
              getData();
              Navigator.pop(context);
            }, child: Text('Retry'))
          ],
        );
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('Home'),
        centerTitle: true,
      ),
      body: RefreshIndicator(child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  ClipOval(child: Image.network(data[0]['results'][0]['picture']['large'])),
                  Text('$name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),)

                ],
              )),

          Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.pin_drop_outlined, color: Colors.red[800],),
                    Text('$country'),
                  ],
                ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon((gender == 'male')? Icons.male_outlined : Icons.female_outlined, color: (gender == 'male')? Colors.blue[800] : Colors.pink[800],),
                      Text('$gender'),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.email, color: Colors.red[800],),
                      Text('$email'),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.person, color: Colors.green[800],),
                      Text('$username'),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.call, color: Colors.purple[800],),
                      Text('$phoneNumber'),
                    ],
                  ),





                ],
              )),
        ],
      ), onRefresh: getData),
    );
  }
}
