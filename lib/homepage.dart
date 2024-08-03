import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location is Disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  String? lat;
  String? long;
  String? locationMessage;
  String? address;

  Future<void> _openMap(String lat, String long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrl(Uri.parse(googleUrl))
        ? await launchUrl(Uri.parse(googleUrl))
        : throw 'Could not launch';
  }

  _openInMaps() async {
    // Replace latitude and longitude with your actual values
    double latitude = 37.422;
    double longitude = -122.084;

    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Location"),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage.toString()),
            ElevatedButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';

                  setState(() {
                    locationMessage = 'latitude : $lat , Longitude : $long';
                  });
                });
              },
              child: Text(
                "Button",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _openInMaps();
              },
              child: Text("Open in Map"),
            ),
          ],
        ),
      ),
    );
  }
}
