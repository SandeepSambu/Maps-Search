import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String location;
  const Details({super.key, required this.location});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
          leading: IconButton(onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)
          ),
        ),
        body: Text("Welcome to ${widget.location}"),
      ),
    );
  }
}