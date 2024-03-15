import 'dart:convert';
import 'variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled3/homepage.dart';
void main()=> runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Loading(),
));

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future<void> getData() async {

     try {
       final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 6));
       print("connected");
       data = [jsonDecode(response.body)];
       print(data[0]['results'][0]['name']['first']);
       await Future.delayed(Duration(seconds: 3));
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homepage()));
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
  void initState() {
    getData(); // will run at the start of the application
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https://i.pinimg.com/originals/5c/87/9a/5c879ab8cba794923686df4b950f497b.gif'),
          Text('Random User API', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          LinearProgressIndicator(color: Colors.green,)
        ],
      ),
    );
  }
}
