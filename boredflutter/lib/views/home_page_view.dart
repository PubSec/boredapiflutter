import 'package:boredflutter/utilites/material_state_method/background_color_method.dart';
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

Map? activityResponse;

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool state = false;
  late final AnimationController _animationController;

  rive.Artboard? riveArtboard;

  @override
  void initState() {
    super.initState();

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

  Future activityApiResponse() async {
    http.Response response;
    response =
        await http.get(Uri.parse("http://www.boredapi.com/api/activity"));
    if (response.statusCode == 200) {
      setState(() {
        activityResponse = json.decode(response.body);
      });
    }
  }

  final filledStar = const Icon(Icons.star);

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
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                getBackgroundColor),
                      ),
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
                  child: activityResponse == null
                      ? const Text('Activity will appear here')
                      : ListTile(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          isThreeLine: true,
                          leading: const Icon(
                            Icons.local_activity_rounded,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Activity: ${activityResponse!["activity"].toString()}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          titleTextStyle: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          subtitle: Text(
                            'Type: ${activityResponse!["type"].toString()}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  showCloseIcon: true,
                                  closeIconColor: Colors.white,
                                  content: Text('Added to Favorites'),
                                ),
                              );
                            },
                            icon: filledStar,
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.blue.shade400,
          elevation: 100,
          tooltip: 'go to favorites',
          onPressed: () {
            Navigator.of(context).pushNamed('favorite');
          },
          child: const Text(
            'Favorites',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
