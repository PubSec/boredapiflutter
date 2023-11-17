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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool state = false;
  late final AnimationController _animationController;

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
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.5,
      upperBound: 0.6,
    );
    _animationController.repeat(
        reverse: true, period: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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
                ScaleTransition(
                  scale: _animationController,
                  child: Container(
                    transformAlignment: AlignmentDirectional.center,
                    height: 80,
                    width: 250,
                    child: FloatingActionButton(
                      tooltip: 'display random activity',
                      backgroundColor: Colors.indigo[900],
                      onPressed: () {
                        activityApiResponse();
                      },
                      child: const Text(
                        'Random Activity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
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
Participants: ${activityResponse!['participants'].toString()} 
                          ''',
                          softWrap: true,
                          maxLines: 5,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
