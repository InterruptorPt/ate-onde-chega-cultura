import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String name;

  const Loading({Key key, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text('A carregar ' + this.name)
            ],
          ),
        ),
      ),
    );
  }
}
