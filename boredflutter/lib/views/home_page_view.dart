import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String? stringResponse;
Map? mappedResponse;
Map? dataResponse;
String? apiResponse;
Map? activityResponse;

class _MyHomePageState extends State<MyHomePage> {
  rive.Artboard? riveArtboard;

  @override
  void initState() {
    super.initState();
    //apiResponse();
    rootBundle.load('assets/man.riv').then((data) async {
      try {
        final file = rive.RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller = rive.StateMachineController.fromArtboard(
            artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
        }
        setState(() {
          riveArtboard = artboard;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }

  // Future apiResponse() async {
  //   http.Response response;
  //   response = await http.get(Uri.parse("https://reqres.in/api/users/2"));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       // stringResponse = response.body;
  //       mappedResponse = json.decode(response.body);
  //       dataResponse = mappedResponse!['data'];
  //     });
  //   }
  // }

  Future activityApiResponse() async {
    http.Response response;
    response =
        await http.get(Uri.parse("http://www.boredapi.com/api/activity"));
    if (response.statusCode == 200) {
      setState(() {
        // apiResponse = response.body;
        activityResponse = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: riveArtboard == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 400,
                  child: Center(
                    child: rive.Rive(
                      fit: BoxFit.fill,
                      artboard: riveArtboard!,
                    ),
                  ),
                ),
                const Text(
                  'Are you bored?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xff1CDAC5),
                      Color.fromARGB(255, 224, 224, 255),
                    ]),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(top: 70),
                  alignment: Alignment.bottomCenter,

                  // child: dataResponse == null
                  //     ? const CircularProgressIndicator()
                  //     : Text(dataResponse!['first_name'].toString()),
                  child: activityResponse == null
                      ? const Text('Activity will appear here')
                      : Text(
                          '''
Activity: ${activityResponse!['activity'].toString()}
Type: ${activityResponse!['type'].toString()}  
                          ''',
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),
                ),
                // Container(
                //   height: 50,
                //   decoration: const BoxDecoration(
                //     gradient: LinearGradient(colors: [
                //       Color(0xff1CDAC5),
                //       Color.fromARGB(255, 224, 224, 255),
                //     ]),
                //   ),
                //   padding: const EdgeInsets.all(10.0),

                //   alignment: Alignment.bottomCenter,

                //   // child: dataResponse == null
                //   //     ? const CircularProgressIndicator()
                //   //     : Text(dataResponse!['first_name'].toString()),
                //   child: activityResponse == null
                //       ? const Text('Activity will appear here')
                //       : Text(
                //           '${activityResponse!['type'].toString()}',
                //         ),
                // ),
              ],
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          right: 115,
          bottom: 230,
        ),
        width: 120,
        child: FloatingActionButton(
          tooltip: 'display random activity',
          elevation: 5,
          backgroundColor: Colors.indigo[900],
          onPressed: () {
            activityApiResponse();
          },
          child: const Text(
            'Random Activity',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
