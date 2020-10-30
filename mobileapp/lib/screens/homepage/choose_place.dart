import 'package:flutter/material.dart';
import 'package:mobileapp/enum/selectedType.dart';

class ChoosePlace extends StatefulWidget {
  final Function onPlaceChange;
  final int selectedIndex;

  const ChoosePlace({Key key, this.onPlaceChange, this.selectedIndex})
      : super(key: key);
  @override
  _ChoosePlaceState createState() => _ChoosePlaceState();
}

class _ChoosePlaceState extends State<ChoosePlace> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        color: Colors.white,
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _createBottomNavigationBarItem(),
        ),
      ),
    );
  }

  List<Widget> _createBottomNavigationBarItem() {
    return SelectedType.values
        .asMap()
        .map((index, element) => MapEntry(
            index,
            FlatButton(
              onPressed: () {
                widget.onPlaceChange(element, index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    element.iconData,
                    color: _getIconAndTextColor(index),
                  ),
                  Text(
                    element.name,
                    style: TextStyle(color: _getIconAndTextColor(index)),
                  )
                ],
              ),
            )))
        .values
        .toList();
  }

  Color _getIconAndTextColor(int index) {
    return widget.selectedIndex == index ? Colors.blue : Colors.black;
  }
}
